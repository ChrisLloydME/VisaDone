import AppKit
import SceneKit
import SwiftUI
import simd

/// Session-owned globe state survives SwiftUI tab / destination transitions.
@MainActor final class DestinationGlobeStore {
    lazy var view = DestinationGlobeView()
}

/// Native SceneKit globe. AppKit owns pointer, wheel and keyboard input.
struct DestinationGlobe: NSViewRepresentable {
    var store: DestinationGlobeStore? = nil
    let map: DestinationMapData
    @Binding var hoveredID: String?
    let dark: Bool
    let reduceMotion: Bool
    var focusedRegionID: String? = nil
    var hoveredCountryID: String? = nil
    var selectedCountryID: String? = nil
    var onCountryHover: ((String?) -> Void)? = nil
    var onSelect: (String) -> Void
    func makeNSView(context: Context) -> DestinationGlobeView {
        let view = store?.view ?? DestinationGlobeView()
        configure(view)
        return view
    }
    func updateNSView(_ view: DestinationGlobeView, context: Context) { configure(view) }
    static func dismantleNSView(_ view: DestinationGlobeView, coordinator: ()) {
        view.onHover = nil
        view.onSelect = nil
        view.onCountryHover = nil
    }
    private func configure(_ view: DestinationGlobeView) {
        view.onHover = { hoveredID = $0 }
        view.onSelect = onSelect
        view.onCountryHover = onCountryHover
        view.reduceMotion = reduceMotion
        view.setFocusedRegion(focusedRegionID)
        view.setCountryInteraction(hovered: hoveredCountryID, selected: selectedCountryID)
    }
}

private struct GlobeRegion: Decodable {
    let id: String
    let rings: [[[Double]]]
}

final class DestinationGlobeView: SCNView {
    var onHover: ((String?) -> Void)?
    var onSelect: ((String) -> Void)?
    var onCountryHover: ((String?) -> Void)?
    var reduceMotion = false
    private let countries = GlobeCountryData.bundled
    private lazy var countryPaths = countries.map { ($0.id, $0.hitPath) }
    private var countryNodes: [String: SCNNode] = [:]
    private var hoveredCountryID: String?
    private var selectedCountryID: String?
    private let earth = SCNNode()
    private var focusedRegionID: String?
    private var paths: [(String, CGPath)] = []
    private var mapTiles: GlobeRasterTiles?
    private var hovered: String?
    private var tracking: NSTrackingArea?
    private var yaw: Float = -24 * .pi / 180
    private var pitch: Float = 38 * .pi / 180
    private var dragOrigin = NSPoint.zero
    private var dragYaw: Float = 0
    private var dragPitch: Float = 0
    private var dragged = false
    private static let flattening = 1.0 / 298.257223563
    private static let e2 = flattening * (2-flattening)
    override var acceptsFirstResponder: Bool { true }
    override var isOpaque: Bool { false }

    init() {
        super.init(frame: .zero, options: [SCNView.Option.preferredRenderingAPI.rawValue: SCNRenderingAPI.metal.rawValue])
        let world = SCNScene()
        scene = world
        backgroundColor = .black
        world.background.contents = NSColor.black
        allowsCameraControl = false
        autoenablesDefaultLighting = false
        antialiasingMode = .multisampling4X
        preferredFramesPerSecond = 60
        rendersContinuously = false
        wantsLayer = true
        layer?.isOpaque = false
        let camera = SCNNode()
        camera.camera = SCNCamera()
        camera.camera?.fieldOfView = 21
        camera.camera?.projectionDirection = .vertical
        camera.camera?.zNear = 0.05
        camera.camera?.zFar = 100
        camera.position = SCNVector3(0, 0, 4)
        world.rootNode.addChildNode(camera)
        pointOfView = camera

        let geometry = Self.ellipsoid()
        let image = Self.image("earth-natural", extension: "jpg")
        let base = SCNNode(geometry: geometry)
        base.name = "earth"
        base.categoryBitMask = 1
        base.geometry?.firstMaterial = Self.paint(image)
        earth.addChildNode(base)
        let data = Bundle.main.url(forResource: "globe-regions", withExtension: "json").flatMap { try? Data(contentsOf: $0) }
        let regions = data.flatMap { try? JSONDecoder().decode([GlobeRegion].self, from: $0) } ?? []
        for region in regions {
            let path = CGMutablePath()
            for ring in region.rings {
                for (index, coordinate) in ring.enumerated() {
                    let point = CGPoint(x: (coordinate[0]+180)/360, y: (90-coordinate[1])/180)
                    if index == 0 { path.move(to: point) } else { path.addLine(to: point) }
                }
                path.closeSubpath()
            }
            paths.append((region.id, path))
        }
        world.rootNode.addChildNode(earth)
        orient()
        addStars(to: world)
        if let config = GlobeRasterSource.bundled {
            mapTiles = GlobeRasterTiles(view: self, earth: earth, continents: [:],
                regions: regions.map { .init(id: $0.id,rings: $0.rings) }, config: config)
            mapTiles?.scheduleVisibleTiles()
        }
        setAccessibilityRole(.image)
        setAccessibilityLabel("世界地球仪")
        setAccessibilityHelp("拖动或滚动旋转地球，点击欧洲选择目的地；方向键也可以旋转。")
        setAccessibilityCustomActions([NSAccessibilityCustomAction(name: "选择欧洲", target: self, selector: #selector(openEurope))])
    }
    required init?(coder: NSCoder) { fatalError() }

    private static func paint(_ image: NSImage?) -> SCNMaterial {
        let material = SCNMaterial()
        material.lightingModel = .constant
        material.diffuse.contents = image ?? NSColor.darkGray
        material.diffuse.wrapS = .repeat
        material.diffuse.wrapT = .clamp
        material.diffuse.minificationFilter = .linear
        material.diffuse.magnificationFilter = .linear
        material.diffuse.mipFilter = .linear
        material.isDoubleSided = false
        return material
    }
    private static func image(_ name: String, extension ext: String) -> NSImage? {
        if let cached = NSImage(named: name) { return cached }
        return Bundle.main.url(forResource: name, withExtension: ext).flatMap { NSImage(contentsOf: $0) }
    }
    static func position(longitude: Double, latitude: Double) -> SCNVector3 {
        let n = 1/sqrt(1-e2*pow(sin(latitude),2))
        return SCNVector3(n*cos(latitude)*sin(longitude), n*(1-e2)*sin(latitude), n*cos(latitude)*cos(longitude))
    }
    private static func ellipsoid() -> SCNGeometry {
        let rows = 192, columns = 384
        var vertices: [SCNVector3] = [], normals: [SCNVector3] = [], uv: [CGPoint] = [], indices: [Int32] = []
        for row in 0...rows {
            let latitude = Double(row)/Double(rows)*Double.pi-Double.pi/2
            for column in 0...columns {
                let longitude = Double(column)/Double(columns)*Double.pi*2-Double.pi
                vertices.append(position(longitude: longitude, latitude: latitude))
                normals.append(SCNVector3(cos(latitude)*sin(longitude),sin(latitude),cos(latitude)*cos(longitude)))
                uv.append(CGPoint(x: Double(column)/Double(columns), y: 1-Double(row)/Double(rows)))
            }
        }
        for row in 0..<rows {
            for column in 0..<columns {
                let a = Int32(row*(columns+1)+column), b = a+1, c = a+Int32(columns+1), d = c+1
                indices.append(contentsOf: [a,b,c,b,d,c])
            }
        }
        return SCNGeometry(sources: [.init(vertices: vertices), .init(normals: normals), .init(textureCoordinates: uv)], elements: [.init(indices: indices, primitiveType: .triangles)])
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        if let tracking { removeTrackingArea(tracking) }
        let area = NSTrackingArea(rect: .zero, options: [.activeInKeyWindow,.mouseMoved,.mouseEnteredAndExited,.inVisibleRect], owner: self)
        addTrackingArea(area); tracking = area
    }
    override func mouseMoved(with event: NSEvent) {
        let id = region(at: convert(event.locationInWindow, from: nil))
        hover(id)
        ((focusedRegionID == "Europe" ? id != nil : id == "Europe") ? NSCursor.pointingHand : NSCursor.openHand).set()
    }
    override func mouseExited(with event: NSEvent) { hover(nil); NSCursor.arrow.set() }
    override func mouseDown(with event: NSEvent) {
        window?.makeFirstResponder(self)
        dragOrigin = convert(event.locationInWindow, from: nil)
        dragYaw = yaw; dragPitch = pitch; dragged = false
    }
    override func mouseDragged(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil)
        let dx = point.x-dragOrigin.x, dy = point.y-dragOrigin.y
        if hypot(dx,dy)>3 { dragged = true }
        guard dragged else { return }
        let down = isFlipped ? dy : -dy
        yaw = dragYaw+Float(dx)*0.003
        pitch = min(1.55,max(-1.55,dragPitch+Float(down)*0.003))
        hover(nil); orient(); NSCursor.closedHand.set()
    }
    override func mouseUp(with event: NSEvent) {
        let id = region(at: convert(event.locationInWindow, from: nil))
        if !dragged, let id { onSelect?(id) }
        hover(id); NSCursor.openHand.set()
    }
    override func scrollWheel(with event: NSEvent) {
        yaw += Float(event.scrollingDeltaX)*0.0025
        pitch = min(1.55,max(-1.55,pitch+Float(event.scrollingDeltaY)*0.0025))
        hover(nil); orient()
    }
    override func magnify(with event: NSEvent) {}
    override func smartMagnify(with event: NSEvent) {}
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 123: yaw -= 0.06
        case 124: yaw += 0.06
        case 125: pitch = min(1.55,pitch+0.06)
        case 126: pitch = max(-1.55,pitch-0.06)
        case 36,49:
            if focusedRegionID == "Europe", let id = hoveredCountryID { onSelect?(id) }
            else if hovered == "Europe" { onSelect?("Europe") }
            return
        default: super.keyDown(with: event); return
        }
        hover(nil); orient()
    }
    @objc private func openEurope() -> Bool { onSelect?("Europe"); return true }
    override func layout() {
        super.layout()
        mapTiles?.scheduleVisibleTiles()
    }
    func setFocusedRegion(_ id: String?) {
        guard focusedRegionID != id else { return }
        focusedRegionID = id
        // Keep Europe to the right of the left-hand destination drawer.
        yaw = (id == "Europe" ? 8 : -24) * .pi / 180
        pitch = (id == "Europe" ? 45 : 38) * .pi / 180
        hover(nil)
        refreshCountries()
        orient(animated: true)
    }
    private func orient(animated: Bool = false) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = animated && !reduceMotion ? 0.85 : 0
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        earth.simdOrientation = simd_quatf(angle: pitch, axis: SIMD3(1,0,0))*simd_quatf(angle: yaw, axis: SIMD3(0,1,0))
        SCNTransaction.commit()
        needsDisplay = true
        mapTiles?.scheduleVisibleTiles()
    }
    private func region(at point: NSPoint) -> String? {
        guard let hit = hitTest(point, options: [.categoryBitMask: 1, .searchMode: SCNHitTestSearchMode.closest.rawValue]).first else { return nil }
        let p = hit.localCoordinates, horizontal = hypot(Double(hit.localCoordinates.x),Double(hit.localCoordinates.z))
        var latitude = atan2(Double(p.y),horizontal*(1-Self.e2))
        for _ in 0..<5 {
            let n = 1/sqrt(1-Self.e2*pow(sin(latitude),2))
            latitude = atan2(Double(p.y)+Self.e2*n*sin(latitude),horizontal)
        }
        let coordinate = CGPoint(x: atan2(Double(p.x),Double(p.z))/(2 * .pi)+0.5, y: 0.5-latitude / .pi)
        if focusedRegionID == "Europe" { return countryPaths.first { $0.1.contains(coordinate) }?.0 }
        return paths.first { $0.1.contains(coordinate) }?.0
    }
    private func hover(_ id: String?) {
        if focusedRegionID == "Europe" {
            guard hoveredCountryID != id else { return }
            hoveredCountryID = id
            onCountryHover?(id)
            toolTip = countries.first(where: { $0.id == id }).map { $0.name + " · " + $0.english }
            refreshCountries()
            return
        }
        guard hovered != id else { return }
        hovered = id; onHover?(id); needsDisplay = true
    }
    func setCountryInteraction(hovered: String?, selected: String?) {
        guard hoveredCountryID != hovered || selectedCountryID != selected else { return }
        hoveredCountryID = hovered
        selectedCountryID = selected
        refreshCountries()
    }
    private func refreshCountries() {
        let active = focusedRegionID == "Europe" ? Set([hoveredCountryID,selectedCountryID].compactMap { $0 }) : []
        for id in active where countryNodes[id] == nil {
            guard let country = countries.first(where: { $0.id == id }) else { continue }
            let node = GlobeCountrySurface.make(country)
            node.opacity = 0
            earth.addChildNode(node)
            countryNodes[id] = node
        }
        SCNTransaction.begin()
        SCNTransaction.animationDuration = reduceMotion ? 0 : 0.12
        for (id,node) in countryNodes {
            node.opacity = active.contains(id) ? (id == selectedCountryID ? 1 : 0.65) : 0
        }
        SCNTransaction.commit()
        // Retain only a handful of geographic masks, never a texture per country.
        if countryNodes.count > 6 {
            for id in Array(countryNodes.keys) where !active.contains(id) {
                countryNodes.removeValue(forKey: id)?.removeFromParentNode()
            }
        }
        needsDisplay = true
    }
    private func addStars(to scene: SCNScene) {
        var seed: UInt64 = 0x56495341444F4E45
        func random() -> Double { seed = seed &* 6364136223846793005 &+ 1442695040888963407; return Double(seed >> 11)/Double(UInt64.max >> 11) }
        var points: [SCNVector3] = []
        for _ in 0..<12000 {
            let y = random()*2-1, angle = random()*Double.pi*2, r = sqrt(1-y*y)
            points.append(SCNVector3(40*r*cos(angle),40*y,40*r*sin(angle)))
        }
        let element = SCNGeometryElement(indices: points.indices.map { Int32($0) }, primitiveType: .point)
        element.pointSize = 1
        element.minimumPointScreenSpaceRadius = 0.4
        element.maximumPointScreenSpaceRadius = 0.8
        let geometry = SCNGeometry(sources: [.init(vertices: points)], elements: [element])
        let material = SCNMaterial(); material.lightingModel = .constant
        material.diffuse.contents = NSColor(white: 0.55, alpha: 1)
        geometry.firstMaterial = material
        let stars = SCNNode(geometry: geometry); stars.categoryBitMask = 4
        scene.rootNode.addChildNode(stars)
    }
}
