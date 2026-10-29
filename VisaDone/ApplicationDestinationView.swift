import AppKit
import SwiftUI

struct ApplicationDestinationView: View {
    @Bindable var model: VisaDoneModel
    var map: DestinationMapData = .bundled
    @State private var hoveredRegion: String?
    @State private var hoveredCountry: String?
    @State private var chromeHeight: CGFloat = 32
    @State private var search = ""
    @State private var showingCurrentApplication = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme

    private var inEurope: Bool { model.destinationRegionID == "Europe" }
    private var visibleCountries: [DestinationMapRegion] {
        return map.countries.filter {
            search.isEmpty || ($0.name + ($0.english ?? "")).localizedStandardContains(search)
        }.sorted {
            ($0.english ?? $0.name).compare($1.english ?? $1.name,
                options: [.caseInsensitive, .diacriticInsensitive], locale: Locale(identifier: "en")) == .orderedAscending
        }
    }

    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .background { worldContent.ignoresSafeArea(.container, edges: .top) }
                .overlay(alignment: .topLeading) {
                    if inEurope {
                        DestinationBackButton(action: returnToWorld)
                        .frame(width: chromeHeight, height: chromeHeight)
                        .help("返回世界地图").accessibilityLabel("返回世界地图")
                        .padding(.leading, 14).padding(.top, 14)
                    } else {
                        Text("选择你的目的地")
                            .font(.system(size: 22, weight: .semibold)).foregroundStyle(.white)
                            .padding(.leading, 28).padding(.top, 22)
                            .allowsHitTesting(false)
                    }
                }
                .overlay(alignment: .topTrailing) {
                    if !inEurope, let region = map.continents.first(where: { $0.id == hoveredRegion }) {
                        Text(region.name).font(.system(size: 13, weight: .medium)).foregroundStyle(.white)
                            .padding(.trailing, 28).padding(.top, 26).allowsHitTesting(false)
                    }
                }
                    .overlay(alignment: .bottomTrailing) {
                        if let source = GlobeRasterSource.bundled {
                            HStack(spacing: 5) {
                                switch source {
                                case .mapbox:
                                    Link(destination: URL(string: "https://www.mapbox.com/")!) {
                                        Image("MapboxLogo").resizable().scaledToFit().frame(width: 80,height: 20)
                                    }
                                    Link("© Mapbox", destination: URL(string: "https://www.mapbox.com/about/maps/")!)
                                    Text("·")
                                    Link("© OpenStreetMap", destination: URL(string: "https://www.openstreetmap.org/copyright")!)
                                    Text("·")
                                    Link("改进地图", destination: URL(string: "https://apps.mapbox.com/feedback/")!)
                                case .maptiler:
                                    Link(destination: URL(string: "https://www.maptiler.com/")!) {
                                        Image("MapTilerLogo").resizable().scaledToFit().frame(width: 74,height: 19)
                                    }
                                    Link("© MapTiler", destination: URL(string: "https://www.maptiler.com/copyright/")!)
                                    Text("·")
                                    Link("© OpenStreetMap", destination: URL(string: "https://www.openstreetmap.org/copyright")!)
                                }
                            }
                            .font(.system(size: 10))
                            .foregroundStyle(.white.opacity(0.85))
                            .padding(7)
                            .background(.black.opacity(0.5),in: .rect(cornerRadius: 5))
                            .padding(.trailing,12).padding(.bottom,10)
                        }
                    }
                .overlay(alignment: .bottomLeading) {
                    Group {
                        if inEurope {
                            DestinationCountryDrawer(countries: visibleCountries,
                                selection: $model.destinationCountryID, hoveredCountry: $hoveredCountry, search: $search,
                                controlHeight: chromeHeight,
                                expandedHeight: min(740, geometry.size.height - 84))
                                .transition(.opacity)
                        } else {
                            ApplicationProgressDrawer(application: model.ongoingApplication) {
                                showingCurrentApplication = true
                            }
                            .transition(.opacity)
                        }
                    }
                    .frame(width: min(380, max(320, geometry.size.width * 0.31)))
                    .padding(.leading, 14).padding(.bottom, 14)
                }
        }
        .background { Color.black.ignoresSafeArea() }
        .background { DestinationToolbarMetrics(height: $chromeHeight).frame(width: 0, height: 0) }
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.25), value: inEurope)
        .sheet(isPresented: $showingCurrentApplication) {
            OngoingApplicationSheet(application: model.ongoingApplication)
        }
    }

    private func returnToWorld() {
        model.destinationRegionID = nil
        model.destinationCountryID = nil
        hoveredRegion = nil
        hoveredCountry = nil
        search = ""
    }

    private var worldContent: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                DestinationGlobe(store: model.destinationGlobeStore, map: map,
                    hoveredID: $hoveredRegion, dark: colorScheme == .dark,
                    reduceMotion: reduceMotion, focusedRegionID: model.destinationRegionID,
                    hoveredCountryID: hoveredCountry, selectedCountryID: model.destinationCountryID,
                    onCountryHover: { hoveredCountry = $0 }) { id in
                        if inEurope {
                            model.destinationCountryID = id
                        } else if id == "Europe" {
                            hoveredRegion = nil
                            model.destinationRegionID = id
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .accessibilityLabel("世界地球仪，拖动旋转并选择地区")
            }
            .scrollIndicators(.hidden).scrollDisabled(true)
            .scrollEdgeEffectStyle(.soft, for: .top)
            .scrollEdgeEffectHidden(false, for: .top)
        }
    }
}

private struct DestinationCountryDrawer: View {
    let countries: [DestinationMapRegion]
    @Binding var selection: String?
    @Binding var hoveredCountry: String?
    @Binding var search: String
    let controlHeight: CGFloat
    let expandedHeight: CGFloat
    @State private var expanded = true
    @State private var dragHeight: CGFloat?
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    private let collapsedHeight: CGFloat = 64
    private var restingHeight: CGFloat { expanded ? expandedHeight : collapsedHeight }
    private var height: CGFloat { dragHeight ?? restingHeight }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button { setExpanded(!expanded) } label: {
                VStack(spacing: 6) {
                    Capsule().fill(.secondary.opacity(0.45)).frame(width: 34, height: 4)
                    HStack {
                        Text("新申请").font(.system(size: 22, weight: .bold))
                        Spacer()
                        Image(systemName: expanded ? "chevron.down" : "chevron.up")
                            .font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 22).padding(.top, 9).padding(.bottom, 10)
                .frame(height: collapsedHeight).contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .layoutPriority(1)
            .highPriorityGesture(DragGesture(minimumDistance: 4, coordinateSpace: .global)
                .onChanged { value in
                    dragHeight = min(expandedHeight, max(collapsedHeight, restingHeight - value.translation.height))
                }
                .onEnded { value in
                    setExpanded(restingHeight - value.predictedEndTranslation.height > (expandedHeight + collapsedHeight) / 2)
                })
            .accessibilityLabel("新申请地区选择器")
            .accessibilityValue(expanded ? "已展开" : "已收起")

            VStack(alignment: .leading, spacing: 0) {
                ScrollViewReader { proxy in
                    List(selection: $selection) {
                        ForEach(countries) { country in
                            HStack(spacing: 12) {
                                Image(country.flagAssetName).resizable().scaledToFill()
                                    .frame(width: 32, height: 32).clipShape(Circle())
                                    .accessibilityHidden(true)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(country.name).font(.system(size: 13, weight: .medium))
                                    Text(country.english ?? "").font(.system(size: 11)).foregroundStyle(.secondary)
                                }
                                Spacer(minLength: 0)
                            }
                            .padding(.vertical, 5)
                            .tag(country.id)
                            .id(country.id)
                            .listRowBackground(hoveredCountry == country.id && selection != country.id ? Color.accentColor.opacity(0.08) : Color.clear)
                            .onHover { inside in
                                if inside { hoveredCountry = country.id }
                                else if hoveredCountry == country.id { hoveredCountry = nil }
                            }
                            .accessibilityLabel(country.name + "，" + (country.english ?? ""))
                        }
                    }
                    .listStyle(.inset).scrollContentBackground(.hidden)
                    .scrollEdgeEffectStyle(.soft, for: [.top, .bottom])
                    .scrollEdgeEffectHidden(false, for: .top)
                    .safeAreaBar(edge: .top, spacing: 0) {
                        DestinationCountrySearch(text: $search)
                            .frame(height: controlHeight)
                            .glassEffect(.regular.interactive(), in: .capsule)
                            .padding(.horizontal, 14).padding(.top, 6).padding(.bottom, 12)
                    }
                    .overlay {
                        if countries.isEmpty { ContentUnavailableView.search(text: search).controlSize(.small) }
                    }
                    .padding(.horizontal, 8)
                    .onChange(of: selection) { _, id in
                        if let id {
                            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
                                proxy.scrollTo(id, anchor: .center)
                            }
                        }
                    }
                }


            }
            .frame(height: expandedHeight - collapsedHeight)
            .opacity(min(1, max(0, (height - collapsedHeight) / 60)))
            .allowsHitTesting(expanded && dragHeight == nil)
            .accessibilityHidden(!expanded)
        }
        .frame(height: height, alignment: .top)
        .clipped()
        .glassEffect(.regular, in: .rect(cornerRadius: 26))
    }

    private func setExpanded(_ value: Bool) {
        withAnimation(reduceMotion ? nil : .snappy(duration: 0.25, extraBounce: 0)) {
            expanded = value
            dragHeight = nil
        }
    }
}

private struct DestinationCountrySearch: NSViewRepresentable {
    @Binding var text: String
    func makeNSView(context: Context) -> NSSearchField {
        let field = NSSearchField()
        field.placeholderString = "搜索国家或地区"
        field.controlSize = .regular
        field.font = .systemFont(ofSize: 13)
        field.isBezeled = false
        field.drawsBackground = false
        field.focusRingType = .none
        field.sendsSearchStringImmediately = true
        field.sendsWholeSearchString = false
        field.delegate = context.coordinator
        return field
    }
    func updateNSView(_ field: NSSearchField, context: Context) {
        context.coordinator.text = $text
        if field.stringValue != text { field.stringValue = text }
    }
    func makeCoordinator() -> Coordinator { Coordinator(text: $text) }
    final class Coordinator: NSObject, NSSearchFieldDelegate {
        var text: Binding<String>
        init(text: Binding<String>) { self.text = text }
        func controlTextDidChange(_ notification: Notification) {
            if let field = notification.object as? NSSearchField { text.wrappedValue = field.stringValue }
        }
    }
}

/// Use the actual navigation control height rather than guessing a larger size.
private struct DestinationToolbarMetrics: NSViewRepresentable {
    @Binding var height: CGFloat
    func makeNSView(context: Context) -> Probe { Probe() }
    func updateNSView(_ view: Probe, context: Context) {
        view.report = { if abs(height - $0) > 0.5 { height = $0 } }
        view.measure()
    }
    final class Probe: NSView {
        var report: ((CGFloat) -> Void)?
        override func viewDidMoveToWindow() { super.viewDidMoveToWindow(); measure() }
        func measure() {
            DispatchQueue.main.async { [weak self] in
                guard let self, let root = self.window?.contentView?.superview else { return }
                func navigation(in view: NSView) -> NSSegmentedControl? {
                    if let control = view as? NSSegmentedControl, control.segmentCount == 4 { return control }
                    for child in view.subviews { if let result = navigation(in: child) { return result } }
                    return nil
                }
                if let control = navigation(in: root), (24...44).contains(control.bounds.height) {
                    self.report?(control.bounds.height)
                }
            }
        }
    }
}

private struct DestinationBackButton: NSViewRepresentable {
    let action: () -> Void
    func makeNSView(context: Context) -> NSButton {
        let button = NSButton(image: NSImage(systemSymbolName: "chevron.backward", accessibilityDescription: "返回世界地图")!,
            target: context.coordinator, action: #selector(Coordinator.back))
        button.bezelStyle = .glass
        button.borderShape = .circle
        button.controlSize = .regular
        button.image = button.image?.withSymbolConfiguration(.init(pointSize: 13, weight: .medium))
        button.keyEquivalent = "\u{1b}"
        button.keyEquivalentModifierMask = []
        button.setAccessibilityLabel("返回世界地图")
        return button
    }
    func updateNSView(_ button: NSButton, context: Context) { context.coordinator.action = action }
    func makeCoordinator() -> Coordinator { Coordinator(action: action) }
    final class Coordinator: NSObject {
        var action: () -> Void
        init(action: @escaping () -> Void) { self.action = action }
        @objc func back() { action() }
    }
}
