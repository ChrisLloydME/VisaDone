import AppKit
import ImageIO
import SceneKit
import simd

struct MapTilerConfiguration: Decodable {
    let apiKey: String
    let mapID: String
    static let bundled: Self? = {
        guard let url = Bundle.main.url(forResource: "MapTiler.local", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let config = try? JSONDecoder().decode(Self.self, from: data),
              !config.apiKey.isEmpty, !config.apiKey.hasPrefix("YOUR_") else { return nil }
        return config
    }()
}

struct MapboxConfiguration: Decodable {
    let accessToken: String
    let owner: String
    let styleID: String
    static let bundled: Self? = {
        guard let url = Bundle.main.url(forResource: "Mapbox.local", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let config = try? JSONDecoder().decode(Self.self, from: data),
              config.accessToken.hasPrefix("pk."), !config.owner.isEmpty, !config.styleID.isEmpty else { return nil }
        return config
    }()
}

enum GlobeRasterSource {
    case mapbox(MapboxConfiguration)
    case maptiler(MapTilerConfiguration)
    static var bundled: Self? {
        if let config = MapboxConfiguration.bundled { return .mapbox(config) }
        if let config = MapTilerConfiguration.bundled { return .maptiler(config) }
        return nil
    }
    var name: String {
        switch self { case .mapbox: "Mapbox"; case .maptiler: "MapTiler" }
    }
    func tileURL(zoom: Int, x: Int, y: Int) -> URL? {
        let tile = "\(zoom)/\(x)/\(y)"
        var components: URLComponents
        switch self {
        case .mapbox(let config):
            components = URLComponents(string: "https://api.mapbox.com")!
            components.path = "/styles/v1/\(config.owner)/\(config.styleID)/tiles/512/\(tile)@2x"
            components.queryItems = [URLQueryItem(name: "access_token",value: config.accessToken)]
        case .maptiler(let config):
            components = URLComponents(string: "https://api.maptiler.com")!
            components.path = "/maps/\(config.mapID)/\(tile)@2x.png"
            components.queryItems = [URLQueryItem(name: "key",value: config.apiKey)]
        }
        return components.url
    }
}

/// Native XYZ image tiles. Mapbox uses a device-local, 30-day offline set.
/// The complete fixed-resolution globe is prepared before any tiles are shown.
@MainActor final class GlobeRasterTiles {
    struct Region {
        let id: String
        let rings: [[[Double]]]
    }
    private struct Tile: Hashable {
        let x: Int
        let y: Int
        static let zoom = 4
        static let count = 1 << zoom
        var key: String { "\(Self.zoom)/\(x)/\(y)" }
        func coordinate(u: Double, v: Double) -> (longitude: Double, latitude: Double) {
            let n = Double(Self.count)
            return ((Double(x)+u)/n*2 * .pi - .pi, atan(sinh(.pi*(1-2*(Double(y)+v)/n))))
        }
    }
    private weak var view: SCNView?
    private let earth: SCNNode
    private let continentNodes: [String: SCNNode]
    private let regions: [Region]
    private let config: GlobeRasterSource
    private let session: URLSession
    // Fixed z=4 has only 256 possible tiles. Keep visited native surfaces
    // for this demo session so revisiting does not discard/rebuild textures.
    private var loaded: [Tile: [SCNNode]] = [:]
    private var requesting: Set<Tile> = []
    private var pending: [Tile] = []
    private var needed: Set<Tile> = []
    private var failedUntil: [Tile: Date] = [:]
    private var scheduled: Task<Void, Never>?
    private var authorizationFailed = false
    private let offlineDirectory: URL?
    private let offlineLifetime: TimeInterval = 30 * 24 * 60 * 60
    private var preparing = false
    private var presented = false
    private var retry: Task<Void, Never>?

    init(view: SCNView, earth: SCNNode, continents: [String: SCNNode], regions: [Region], config: GlobeRasterSource) {
        self.view = view; self.earth = earth; continentNodes = continents
        self.regions = regions; self.config = config
        if case .mapbox(let mapbox) = config {
            let root = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("VisaDone/MapboxOffline", isDirectory: true)
            // Each published style has an independent cache; no token is stored in filenames.
            offlineDirectory = root.appendingPathComponent(mapbox.owner, isDirectory: true)
                .appendingPathComponent(mapbox.styleID, isDirectory: true).appendingPathComponent("z4-1024", isDirectory: true)
            try? FileManager.default.createDirectory(at: offlineDirectory!, withIntermediateDirectories: true)
            if let files = FileManager.default.enumerator(at: root, includingPropertiesForKeys: [.contentModificationDateKey, .isRegularFileKey]) {
                for case let file as URL in files {
                    if let values = try? file.resourceValues(forKeys: [.contentModificationDateKey, .isRegularFileKey]),
                       values.isRegularFile == true, let date = values.contentModificationDate,
                       Date().timeIntervalSince(date) >= 30 * 24 * 60 * 60 {
                        try? FileManager.default.removeItem(at: file)
                    }
                }
            }
        } else { offlineDirectory = nil }
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("VisaDone/\(config.name)", isDirectory: true)
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        let settings = URLSessionConfiguration.default
        settings.urlCache = URLCache(memoryCapacity: 32*1024*1024, diskCapacity: 256*1024*1024, directory: cacheDirectory)
        settings.requestCachePolicy = .useProtocolCachePolicy
        settings.httpAdditionalHeaders = ["User-Agent": "VisaDone/1.0"]
        settings.httpMaximumConnectionsPerHost = 4
        settings.timeoutIntervalForRequest = 20
        session = URLSession(configuration: settings)
    }

    func scheduleVisibleTiles() {
        guard !presented else { return }
        scheduled?.cancel()
        scheduled = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(250))
            guard !Task.isCancelled else { return }
            self?.updateVisibleTiles()
        }
    }
    private func updateVisibleTiles() {
        guard let view, view.bounds.width > 0, view.bounds.height > 0, !authorizationFailed else { return }
        var visible: [(tile: Tile, priority: CGFloat)] = []
        let viewport = view.bounds.insetBy(dx: -50, dy: -50)
        for y in 0..<Tile.count {
            for x in 0..<Tile.count {
                let tile = Tile(x: x, y: y)
                var screenPoints: [CGPoint] = []
                for v in [0.0,0.5,1.0] {
                    for u in [0.0,0.5,1.0] {
                        let coordinate = tile.coordinate(u: u, v: v)
                        let p = DestinationGlobeView.position(longitude: coordinate.longitude, latitude: coordinate.latitude)
                        let world = earth.convertPosition(p, to: nil)
                        // At camera z=4, only the cap with world-normal z>1/4
                        // faces the camera. Do not request the hidden hemisphere.
                        guard world.z > 0.20 else { continue }
                        let screen = view.projectPoint(world)
                        if screen.z >= 0, screen.z <= 1 { screenPoints.append(CGPoint(x: screen.x,y: screen.y)) }
                    }
                }
                guard let first = screenPoints.first else { continue }
                let rectangle = screenPoints.dropFirst().reduce(CGRect(origin: first, size: CGSize(width: 1,height: 1))) {
                    $0.union(CGRect(origin: $1,size: CGSize(width: 1,height: 1)))
                }
                guard rectangle.intersects(viewport) else { continue }
                let distance = hypot(rectangle.midX-view.bounds.midX,rectangle.midY-view.bounds.midY)
                visible.append((tile,distance))
            }
        }
        if offlineDirectory != nil {
            // No zoom: these 256 tiles are the entire map, not an open-ended pyramid.
            // Prioritize the first frame, then prepare the rest before revealing it.
            let front = Set(visible.map(\.tile))
            for y in 0..<Tile.count {
                for x in 0..<Tile.count {
                    let tile = Tile(x: x, y: y)
                    if !front.contains(tile) { visible.append((tile, .greatestFiniteMagnitude)) }
                }
            }
        }
        needed = Set(visible.map(\.tile))
        pending = visible.sorted { $0.priority < $1.priority }.map(\.tile).filter {
            loaded[$0] == nil && !requesting.contains($0) && (failedUntil[$0] ?? .distantPast) < Date()
        }
        pump()
        presentCompleteGlobe()
    }
    private func pump() {
        while requesting.count < 4, !pending.isEmpty, !authorizationFailed {
            let tile = pending.removeFirst()
            guard needed.contains(tile), loaded[tile] == nil else { continue }
            requesting.insert(tile)
            Task { [weak self] in await self?.load(tile) }
        }
    }
    private func load(_ tile: Tile) async {
        defer { requesting.remove(tile); pump(); presentCompleteGlobe() }
        if let file = offlineFile(tile),
           let values = try? file.resourceValues(forKeys: [.contentModificationDateKey]),
           let date = values.contentModificationDate, Date().timeIntervalSince(date) < offlineLifetime,
           let data = try? Data(contentsOf: file), let image = decode(data) {
            install(tile, image: image)
            return
        }
        guard let url = config.tileURL(zoom: Tile.zoom,x: tile.x,y: tile.y) else { return }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        request.setValue("VisaDone/1.0", forHTTPHeaderField: "User-Agent")
        do {
            let (data,response) = try await session.data(for: request)
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            guard status == 200 else {
                if status == 401 || status == 403 { authorizationFailed = true }
                failedUntil[tile] = Date(timeIntervalSinceNow: 60)
                if !authorizationFailed { scheduleRetry() }
                NSLog("%@ tile returned HTTP %ld",config.name,status)
                return
            }
            guard let image = decode(data) else { scheduleRetry(); return }
            if let file = offlineFile(tile) { try? data.write(to: file, options: .atomic) }
            // Complete the in-flight surface even if the user has rotated.
            // Returning to it should reuse its texture, not rebuild the tile.
            guard loaded[tile] == nil else { return }
            install(tile,image: image)
        } catch {
            failedUntil[tile] = Date(timeIntervalSinceNow: 30)
            scheduleRetry()
            // Do not log URLs or URLSession's error text: they contain the key.
            NSLog("%@ tile could not be loaded; local surface retained",config.name)
        }
    }
    private func install(_ tile: Tile, image: CGImage) {
        let geometry = mesh(tile)
        let material = paint(image)
        geometry.firstMaterial = material
        let base = SCNNode(geometry: geometry)
        base.name = "\(config.name) \(tile.key)"
        base.categoryBitMask = 2
        base.scale = SCNVector3(1.0006,1.0006,1.0006)
        base.isHidden = offlineDirectory != nil
        earth.addChildNode(base)
        var nodes = [base]
        for region in regions {
            guard let parent = continentNodes[region.id], let mask = mask(region,tile: tile) else { continue }
            let raisedGeometry = geometry.copy() as! SCNGeometry
            let raisedPaint = paint(image)
            raisedPaint.transparent.contents = mask
            raisedPaint.transparencyMode = .aOne
            raisedGeometry.firstMaterial = raisedPaint
            let raised = SCNNode(geometry: raisedGeometry)
            raised.categoryBitMask = 2
            raised.scale = SCNVector3(1.0077,1.0077,1.0077)
            raised.renderingOrder = 7
            raised.isHidden = offlineDirectory != nil
            parent.addChildNode(raised)
            nodes.append(raised)
        }
        loaded[tile] = nodes
        view?.needsDisplay = true
    }
    private func offlineFile(_ tile: Tile) -> URL? {
        offlineDirectory?.appendingPathComponent("\(tile.x)-\(tile.y).png")
    }
    private func decode(_ data: Data) -> CGImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        return CGImageSourceCreateImageAtIndex(source, 0, [kCGImageSourceShouldCacheImmediately: true] as CFDictionary)
    }
    private func scheduleRetry() {
        guard retry == nil, !authorizationFailed else { return }
        retry = Task { [weak self] in
            try? await Task.sleep(for: .seconds(61))
            guard !Task.isCancelled, let self else { return }
            self.retry = nil
            self.updateVisibleTiles()
        }
    }
    private func presentCompleteGlobe() {
        guard offlineDirectory != nil, !preparing, !presented,
              loaded.count == Tile.count * Tile.count, let view else { return }
        preparing = true
        let nodes = loaded.values.flatMap { $0 }
        // Upload textures before revealing them, so disk hits cannot cause patchwork either.
        view.prepare(nodes) { [weak self] success in
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.preparing = false
                guard success else { self.scheduleRetry(); return }
                SCNTransaction.begin()
                SCNTransaction.disableActions = true
                for node in self.loaded.values.flatMap({ $0 }) { node.isHidden = false }
                SCNTransaction.commit()
                self.presented = true
                self.view?.needsDisplay = true
                NSLog("Mapbox offline globe ready: 256 tiles, complete surface presented")
            }
        }
    }
    private func paint(_ image: CGImage) -> SCNMaterial {
        let material = SCNMaterial()
        material.lightingModel = .constant
        material.diffuse.contents = image
        material.diffuse.wrapS = .clamp
        material.diffuse.wrapT = .clamp
        material.diffuse.minificationFilter = .linear
        material.diffuse.magnificationFilter = .linear
        material.diffuse.mipFilter = .linear
        material.diffuse.maxAnisotropy = 8
        return material
    }
    private func mesh(_ tile: Tile) -> SCNGeometry {
        let divisions = 32
        var vertices: [SCNVector3] = [], uv: [CGPoint] = [], indices: [Int32] = []
        for row in 0...divisions {
            for column in 0...divisions {
                let u = Double(column)/Double(divisions), v = Double(row)/Double(divisions)
                let coordinate = tile.coordinate(u: u, v: v)
                vertices.append(DestinationGlobeView.position(longitude: coordinate.longitude,latitude: coordinate.latitude))
                uv.append(CGPoint(x: u,y: v))
            }
        }
        for row in 0..<divisions {
            for column in 0..<divisions {
                let a = Int32(row*(divisions+1)+column), b = a+1, c = a+Int32(divisions+1), d = c+1
                indices += [a,c,b,b,c,d]
            }
        }
        return SCNGeometry(sources: [.init(vertices: vertices),.init(textureCoordinates: uv)],elements: [.init(indices: indices,primitiveType: .triangles)])
    }
    private func mask(_ region: Region, tile: Tile) -> CGImage? {
        let size = 256
        guard let context = CGContext(data: nil,width: size,height: size,bitsPerComponent: 8,bytesPerRow: size*4,space: CGColorSpaceCreateDeviceRGB(),bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return nil }
        let bounds = CGRect(x: 0,y: 0,width: size,height: size)
        // Core Graphics paths are bottom-up; tile UVs / PNG rows are top-down.
        context.translateBy(x: 0,y: CGFloat(size))
        context.scaleBy(x: 1,y: -1)
        context.setFillColor(CGColor(gray: 1,alpha: 1))
        var intersects = false
        for ring in region.rings {
            let path = CGMutablePath()
            for (index, coordinate) in ring.enumerated() {
                let latitude = max(-85.05112878,min(85.05112878,coordinate[1])) * .pi/180
                let x = ((coordinate[0]+180)/360*Double(Tile.count)-Double(tile.x))*Double(size)
                let y = ((1-asinh(tan(latitude)) / .pi)/2*Double(Tile.count)-Double(tile.y))*Double(size)
                let point = CGPoint(x: x,y: y)
                if index == 0 { path.move(to: point) } else { path.addLine(to: point) }
            }
            path.closeSubpath()
            if path.boundingBoxOfPath.intersects(bounds) {
                intersects = true;context.addPath(path);context.fillPath()
            }
        }
        guard intersects else { return nil }
        return context.makeImage()
    }
}
