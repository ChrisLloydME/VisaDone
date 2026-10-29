import AppKit
import SceneKit
import simd

struct GlobeCountryData: Decodable {
    let id: String
    let name: String
    let english: String
    let rings: [[[Double]]]
    static let bundled: [Self] = {
        guard let url = Bundle.main.url(forResource: "globe-countries", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return [] }
        return (try? JSONDecoder().decode([Self].self, from: data)) ?? []
    }()
    var hitPath: CGPath {
        let path = CGMutablePath()
        for ring in rings {
            for (index, p) in ring.enumerated() {
                let point = CGPoint(x: (p[0]+180)/360, y: (90-p[1])/180)
                if index == 0 { path.move(to: point) } else { path.addLine(to: point) }
            }
            path.closeSubpath()
        }
        return path
    }
}

/// A geographic focus overlay, attached to the same ellipsoid as the cached map.
/// No screen-space projection, extruded country, or additional network texture.
@MainActor enum GlobeCountrySurface {
    static func make(_ country: GlobeCountryData) -> SCNNode {
        let points = country.rings.flatMap { $0 }
        let node = SCNNode()
        node.name = "country-focus-" + country.id
        node.categoryBitMask = 2
        guard let first = points.first else { return node }
        let minX = points.map { $0[0] }.min() ?? first[0]
        let maxX = points.map { $0[0] }.max() ?? first[0]
        let minY = points.map { $0[1] }.min() ?? first[1]
        let maxY = points.map { $0[1] }.max() ?? first[1]
        let bounds = CGRect(x: minX-0.02, y: minY-0.02, width: maxX-minX+0.04, height: maxY-minY+0.04)
        let divisions = 64
        var vertices: [SCNVector3] = [], uv: [CGPoint] = [], indices: [Int32] = []
        for row in 0...divisions {
            for column in 0...divisions {
                let u = Double(column)/Double(divisions), v = Double(row)/Double(divisions)
                vertices.append(DestinationGlobeView.position(longitude: (bounds.minX+u*bounds.width) * .pi/180,
                    latitude: (bounds.maxY-v*bounds.height) * .pi/180))
                uv.append(CGPoint(x: u, y: v))
            }
        }
        for row in 0..<divisions {
            for column in 0..<divisions {
                let a = Int32(row*(divisions+1)+column), b = a+1, c = a+Int32(divisions+1), d = c+1
                indices += [a,c,b,b,c,d]
            }
        }
        let fill = SCNGeometry(sources: [.init(vertices: vertices), .init(textureCoordinates: uv)],
            elements: [.init(indices: indices, primitiveType: .triangles)])
        let paint = SCNMaterial()
        paint.lightingModel = .constant
        paint.diffuse.contents = NSColor.controlAccentColor.withAlphaComponent(0.20)
        paint.transparent.contents = mask(country, bounds: bounds)
        paint.transparencyMode = .aOne
        paint.writesToDepthBuffer = false
        fill.firstMaterial = paint
        let surface = SCNNode(geometry: fill)
        surface.scale = SCNVector3(1.0018,1.0018,1.0018)
        surface.categoryBitMask = 2
        surface.renderingOrder = 12
        node.addChildNode(surface)
        node.addChildNode(outline(country))
        return node
    }

    private static func mask(_ country: GlobeCountryData, bounds: CGRect) -> CGImage? {
        let size = 1024
        guard let context = CGContext(data: nil,width: size,height: size,bitsPerComponent: 8,bytesPerRow: size*4,
            space: CGColorSpaceCreateDeviceRGB(),bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return nil }
        context.translateBy(x: 0,y: CGFloat(size))
        context.scaleBy(x: 1,y: -1)
        context.setFillColor(CGColor(gray: 1, alpha: 1))
        for ring in country.rings {
            for (index,p) in ring.enumerated() {
                let point = CGPoint(x: (p[0]-bounds.minX)/bounds.width*Double(size),
                    y: (bounds.maxY-p[1])/bounds.height*Double(size))
                if index == 0 { context.move(to: point) } else { context.addLine(to: point) }
            }
            context.closePath()
        }
        context.fillPath()
        return context.makeImage()
    }

    static func outline(_ country: GlobeCountryData, color: NSColor = .controlAccentColor,
                        halfWidth: Float = 0.0005, radius: Float = 1.0022) -> SCNNode {
        var vertices: [SCNVector3] = [], indices: [Int32] = []
        for ring in country.rings where ring.count > 2 {
            for (a,b) in zip(ring,ring.dropFirst()+[ring[0]]) {
                let steps = max(1,Int(ceil(max(abs(a[0]-b[0]),abs(a[1]-b[1]))/0.25)))
                for step in 0..<steps {
                    func position(_ fraction: Double) -> SIMD3<Float> {
                        let p = DestinationGlobeView.position(longitude: (a[0]+(b[0]-a[0])*fraction) * .pi/180,
                            latitude: (a[1]+(b[1]-a[1])*fraction) * .pi/180)
                        return SIMD3(Float(p.x),Float(p.y),Float(p.z))*radius
                    }
                    let p = position(Double(step)/Double(steps)), q = position(Double(step+1)/Double(steps))
                    guard simd_length(q-p) > 0.000001 else { continue }
                    let across = simd_normalize(simd_cross(simd_normalize(p+q),q-p))*halfWidth
                    let start = Int32(vertices.count)
                    for v in [p-across,p+across,q-across,q+across] { vertices.append(SCNVector3(v)) }
                    indices += [start,start+1,start+2,start+1,start+3,start+2]
                }
            }
        }
        let geometry = SCNGeometry(sources: [.init(vertices: vertices)],elements: [.init(indices: indices,primitiveType: .triangles)])
        let material = SCNMaterial()
        material.lightingModel = .constant
        material.diffuse.contents = color
        material.isDoubleSided = true
        material.writesToDepthBuffer = false
        geometry.firstMaterial = material
        let node = SCNNode(geometry: geometry)
        node.categoryBitMask = 2
        node.renderingOrder = 13
        return node
    }
}
