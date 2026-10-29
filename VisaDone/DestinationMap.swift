import SwiftUI

// Projected offline Natural Earth geometry. Provenance: DesignResources/Maps/README.md.
struct DestinationMapRegion: Decodable, Identifiable {
    let id: String
    let name: String
    let label: [Double]
    let rings: [[[Double]]]
    var english: String? = nil
}

struct DestinationMapData: Decodable {
    let continents: [DestinationMapRegion]
    let countries: [DestinationMapRegion]

    static let bundled: DestinationMapData = {
        let url = Bundle.main.url(forResource: "destination-map", withExtension: "json")
            ?? Bundle.main.url(forResource: "destination-map", withExtension: "json", subdirectory: "Resources/Maps")
            ?? Bundle.main.url(forResource: "destination-map", withExtension: "json", subdirectory: "Maps")
        guard let url else { return .init(continents: [], countries: []) }
        return (try? load(url: url)) ?? .init(continents: [], countries: [])
    }()

    static func load(url: URL) throws -> DestinationMapData {
        try JSONDecoder().decode(Self.self, from: Data(contentsOf: url))
    }
}

struct DestinationMapShape: Shape {
    let rings: [[[Double]]]
    var viewport: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for ring in rings where ring.count > 2 {
            for (index, coordinate) in ring.enumerated() {
                let point = CGPoint(x: (coordinate[0]-viewport.minX)/viewport.width*rect.width,
                                    y: (coordinate[1]-viewport.minY)/viewport.height*rect.height)
                if index == 0 { path.move(to: point) } else { path.addLine(to: point) }
            }
            path.closeSubpath()
        }
        return path
    }
}

private struct DestinationMapHitArea: Shape {
    let region: DestinationMapRegion
    let viewport: CGRect
    let includeLabel: Bool
    func path(in rect: CGRect) -> Path {
        var path = DestinationMapShape(rings: region.rings, viewport: viewport).path(in: rect)
        if includeLabel {
            let point = mapPoint(region.label, viewport: viewport, size: rect.size)
            var labelTarget = Path()
            labelTarget.addRoundedRect(in: CGRect(x: point.x-32, y: point.y-16, width: 64, height: 32), cornerSize: CGSize(width: 6, height: 6))
            path = path.union(labelTarget)
        }
        return path
    }
}

private func mapPoint(_ coordinate: [Double], viewport: CGRect, size: CGSize) -> CGPoint {
    CGPoint(x: (coordinate[0]-viewport.minX)/viewport.width*size.width,
            y: (coordinate[1]-viewport.minY)/viewport.height*size.height)
}

enum DestinationTerrain {
    static let image: NSImage? = {
        if let cached = NSImage(named: "destination-terrain") { return cached }
        let url = Bundle.main.url(forResource: "destination-terrain", withExtension: "png")
            ?? Bundle.main.url(forResource: "destination-terrain", withExtension: "png", subdirectory: "Resources/Maps")
            ?? Bundle.main.url(forResource: "destination-terrain", withExtension: "png", subdirectory: "Maps")
        return url.flatMap { NSImage(contentsOf: $0) }
    }()
    static func ocean(_ scheme: ColorScheme) -> Color {
        // Exactly the source raster's flat water color; the surrounding page
        // continues this same water instead of exposing the map image's bounds.
        scheme == .dark
            ? Color(red: 111.0/255*0.42, green: 171.0/255*0.50, blue: 211.0/255*0.60)
            : Color(red: 111.0/255, green: 171.0/255, blue: 211.0/255)
    }
}

struct DestinationMapCanvas: View {
    let map: DestinationMapData
    var europe = false
    var selectedID: String?
    @Binding var hoveredID: String?
    var onSelect: (String) -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme
    private var viewport: CGRect { europe ? CGRect(x: 0.425, y: 0.055, width: 0.245, height: 0.27) : CGRect(x: 0.05, y: 0.005, width: 0.92, height: 0.85) }
    private var regions: [DestinationMapRegion] { europe ? map.countries : map.continents }
    private var land: Color { mapPaint(.labelColor, fraction: colorScheme == .dark ? 0.15 : 0.13) }
    private var hoveredLand: Color { mapPaint(.labelColor, fraction: colorScheme == .dark ? 0.20 : 0.17) }

    // Resolve semantic colors once into opaque sRGB paint. Vibrant text colors
    // layered inside Canvas otherwise acquire the window's backdrop tint.
    private func mapPaint(_ color: NSColor, fraction: CGFloat) -> Color {
        let appearance = NSAppearance(named: colorScheme == .dark ? .darkAqua : .aqua)!
        var paint = NSColor.gray
        appearance.performAsCurrentDrawingAppearance {
            let base = NSColor.windowBackgroundColor.usingColorSpace(.sRGB)!
            let foreground = color.usingColorSpace(.sRGB)!
            paint = base.blended(withFraction: fraction, of: foreground)!.usingColorSpace(.sRGB)!
        }
        return Color(nsColor: paint)
    }

    var body: some View {
        GeometryReader { geometry in
            let aspect = 1.924 * viewport.width/viewport.height
            let width = min(geometry.size.width, geometry.size.height*aspect)
            let size = CGSize(width: width, height: width/aspect)
            let hitAreas = regions.map { region in
                (region.id, DestinationMapHitArea(region: region, viewport: viewport, includeLabel: !europe || ["ISL", "GBR", "FRA", "DEU", "ITA", "ESP", "NOR", "SWE", "FIN"].contains(region.id)).path(in: CGRect(origin: .zero, size: size)))
            }
            ZStack {
                if europe {
                    ForEach(map.continents) { region in
                        DestinationMapShape(rings: region.rings, viewport: viewport)
                            .fill(Color.clear)
                            .overlay {
                                RaisedMapSurface(shape: DestinationMapShape(rings: region.rings, viewport: viewport), viewport: viewport, elevation: 0, topColor: land, edgeColor: land, outlineColor: .white.opacity(0.25), outlineWidth: 0.4, shadowOpacity: 0, selected: false)
                            }
                            .allowsHitTesting(false)
                    }
                }
                ForEach(regions) { region in
                    regionButton(region, size: size)
                        .zIndex(hoveredID == region.id ? 2 : (selectedID == region.id ? 1 : 0))
                }
            }
            .frame(width: size.width, height: size.height)
            // Track against stationary coastlines, so lifting a shape never moves
            // its hover target and causes enter/exit flicker along the coast.
            .onContinuousHover { phase in
                switch phase {
                case .active(let point):
                    let target = hitAreas.reversed().first { $0.1.contains(point) }?.0
                    if hoveredID != target { hoveredID = target }
                case .ended: hoveredID = nil
                }
            }
            .pointerStyle(hoveredID == nil ? .default : .link)
            .clipped()
            .position(x: geometry.size.width/2, y: geometry.size.height/2)
        }
    }

    private func regionButton(_ region: DestinationMapRegion, size: CGSize) -> some View {
        let hovered = hoveredID == region.id
        let selected = selectedID == region.id
        let shape = DestinationMapShape(rings: region.rings, viewport: viewport)
        let showLabel = !europe || ["ISL", "GBR", "FRA", "DEU", "ITA", "ESP", "NOR", "SWE", "FIN"].contains(region.id)
        let labelPoint = mapPoint(region.label, viewport: viewport, size: size)
        let elevation: CGFloat = hovered && !reduceMotion ? (europe ? 1 : 2.5) : 0
        return Button { onSelect(region.id) } label: {
            ZStack(alignment: .topLeading) {
                RaisedMapSurface(
                    shape: shape,
                    viewport: viewport,
                    elevation: elevation,
                    topColor: selected ? mapPaint(NSColor(named: "AccentColor") ?? .controlAccentColor, fraction: 0.5) : (hovered ? hoveredLand : land),
                    edgeColor: mapPaint(.labelColor, fraction: colorScheme == .dark ? 0.28 : 0.23),
                    outlineColor: selected ? Color.accentColor : .white.opacity(colorScheme == .dark ? 0.3 : 0.65),
                    outlineWidth: selected ? 1.5 : (europe ? 0.7 : 0.45),
                    shadowOpacity: colorScheme == .dark ? 0.18 : 0.08,
                    selected: selected
                )
                if showLabel {
                    Text(region.name)
                        .font(.system(size: europe ? 11 : 13, weight: hovered || selected ? .semibold : .medium))
                        .foregroundStyle(selected ? Color.accentColor : Color.primary.opacity(hovered ? 1 : 0.75))
                        .padding(.horizontal, europe ? 6 : 9).padding(.vertical, 4)
                        .background {
                            if europe { RoundedRectangle(cornerRadius: 4).fill(.background.opacity(0.9)) }
                        }
                        .fixedSize()
                        .position(labelPoint)
                        .offset(x: -elevation*0.22, y: -elevation)
                }
            }
            .frame(width: size.width, height: size.height)
            .contentShape(DestinationMapHitArea(region: region, viewport: viewport, includeLabel: showLabel))
        }
        .buttonStyle(.plain)
        .animation(reduceMotion ? nil : .easeOut(duration: 0.18), value: hovered)
        .animation(.easeOut(duration: 0.15), value: selected)
        .accessibilityLabel(region.name)
        .accessibilityAddTraits(selected ? .isSelected : [])
        .help(region.name)
    }
}

// A shallow extruded silhouette: the top and solid side walls move together.
// Hover hit testing stays on the original map geometry above, never on the lift.
private struct RaisedMapSurface: View, Animatable {
    let shape: DestinationMapShape
    let viewport: CGRect
    var elevation: CGFloat
    let topColor: Color
    let edgeColor: Color
    let outlineColor: Color
    let outlineWidth: CGFloat
    let shadowOpacity: Double
    let selected: Bool
    @Environment(\.colorScheme) private var colorScheme
    var animatableData: CGFloat {
        get { elevation }
        set { elevation = newValue }
    }

    var body: some View {
        Canvas { context, size in
            let path = shape.path(in: CGRect(origin: .zero, size: size))
            if elevation > 0.01 {
                var shadow = context
                shadow.addFilter(.shadow(color: .black.opacity(shadowOpacity * min(1, elevation/2.5)), radius: 0.8+elevation*0.35, x: 0.4, y: 1+elevation*0.2))
                shadow.translateBy(x: -elevation*0.22, y: -elevation)
                shadow.fill(path, with: .color(topColor))
                // Closely spaced opaque slices make a continuous side wall,
                // with a small clearance from the map rather than a paper shadow.
                for slice in 0...8 {
                    let depth = 0.18 + 0.82*CGFloat(slice)/8
                    var side = context
                    side.translateBy(x: -elevation*0.22*depth, y: -elevation*depth)
                    side.fill(path, with: .color(edgeColor))
                }
            }
            var top = context
            top.translateBy(x: -elevation*0.22, y: -elevation)
            if let terrain = DestinationTerrain.image {
                top.drawLayer { texture in
                    texture.clip(to: path)
                    if colorScheme == .dark {
                        texture.addFilter(.colorMultiply(Color(red: 0.42, green: 0.50, blue: 0.60)))
                    }
                    let frame = CGRect(x: -viewport.minX/viewport.width*size.width,
                                       y: -viewport.minY/viewport.height*size.height,
                                       width: size.width/viewport.width, height: size.height/viewport.height)
                    texture.draw(Image(nsImage: terrain), in: frame)
                }
                if selected { top.fill(path, with: .color(Color.accentColor.opacity(0.14))) }
            } else {
                top.fill(path, with: .color(topColor))
            }
            top.stroke(path, with: .color(outlineColor), style: StrokeStyle(lineWidth: outlineWidth, lineJoin: .round))
        }
        .allowsHitTesting(false)
    }
}

// Local flag-icons assets, shared with the profile visa history.
extension DestinationMapRegion {
    var flagAssetName: String {
        let codes = [
            "JEY": "JE",
            "GGY": "GG",
            "IMN": "IM",
            "GBR": "GB",
            "UKR": "UA",
            "CHE": "CH",
            "SWE": "SE",
            "ESP": "ES",
            "SVK": "SK",
            "SVN": "SI",
            "SRB": "RS",
            "SMR": "SM",
            "RUS": "RU",
            "ROU": "RO",
            "PRT": "PT",
            "POL": "PL",
            "NOR": "NO",
            "NLD": "NL",
            "MNE": "ME",
            "MDA": "MD",
            "MCO": "MC",
            "MLT": "MT",
            "MKD": "MK",
            "LUX": "LU",
            "LTU": "LT",
            "LIE": "LI",
            "LVA": "LV",
            "KOS": "XK",
            "ITA": "IT",
            "IRL": "IE",
            "ISL": "IS",
            "HUN": "HU",
            "GRC": "GR",
            "DEU": "DE",
            "FRA": "FR",
            "ALD": "AX",
            "FIN": "FI",
            "EST": "EE",
            "FRO": "FO",
            "DNK": "DK",
            "CZE": "CZ",
            "HRV": "HR",
            "BGR": "BG",
            "BIH": "BA",
            "BEL": "BE",
            "BLR": "BY",
            "AUT": "AT",
            "AND": "AD",
            "ALB": "AL"
        ]
        return "visaFlag" + (codes[id] ?? id)
    }
}
