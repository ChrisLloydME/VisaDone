//
//  ContentView.swift
//  VisaDone
//
//  Created by Christopher Lloyd on 2026.10.27.
//

import AppKit
import SwiftUI

/// The app shell. Navigation lives in the native window toolbar; the four
/// destinations are deliberately independent so they can grow separately.
struct ContentView: View {
    @Bindable var model: VisaDoneModel

    var body: some View {
        ZStack {
            switch model.section {
            case .discovery:
                DiscoveryView(model: model)
                    .searchable(text: $model.searchText, placement: .toolbar, prompt: "搜索签证、目的地或攻略")
            case .notifications:
                NotificationsView(model: model)
            case .application:
                // Intentionally blank for now.
                Color.clear
            case .profile:
                ProfileView(model: model)
            }
        }
        .toolbarBackgroundVisibility(model.section == .discovery ? .automatic : .hidden, for: .windowToolbar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                SectionNavigation(selection: $model.section)
                .fixedSize(horizontal: true, vertical: true)
                .accessibilityLabel("页面")
                .help("切换社区发现、签证申请、通知中心和个人主页")
            }
        }
        .navigationTitle("VisaDone")
        .sheet(isPresented: $model.isComposing) {
            ComposePostView(model: model)
        }
    }
}

/// Configure both pieces directly: SwiftUI's segmented Picker drops the
/// symbol from a title-and-icon Label on macOS.
private struct SectionNavigation: NSViewRepresentable {
    @Binding var selection: AppSection

    func makeNSView(context: Context) -> NSSegmentedControl {
        let control = NSSegmentedControl(
            labels: AppSection.allCases.map(\.title),
            trackingMode: .selectOne,
            target: context.coordinator,
            action: #selector(Coordinator.selectSection(_:))
        )
        control.segmentStyle = .automatic
        control.controlSize = .regular
        control.font = .systemFont(ofSize: 13, weight: .semibold)
        control.segmentDistribution = .fillEqually

        let symbols = ["safari", "doc.text", "bell", "person.crop.circle"]
        let configuration = NSImage.SymbolConfiguration(pointSize: 13, weight: .medium)
        for (index, section) in AppSection.allCases.enumerated() {
            let image = NSImage(systemSymbolName: symbols[index], accessibilityDescription: nil)?
                .withSymbolConfiguration(configuration)
            control.setImage(image, forSegment: index)
            control.setImageScaling(.scaleProportionallyDown, forSegment: index)
            control.setWidth(96, forSegment: index)
            control.setToolTip(section.title, forSegment: index)
        }
        control.setAccessibilityLabel("页面")
        control.selectedSegment = AppSection.allCases.firstIndex(of: selection) ?? 0
        return control
    }

    func updateNSView(_ control: NSSegmentedControl, context: Context) {
        context.coordinator.selection = $selection
        control.selectedSegment = AppSection.allCases.firstIndex(of: selection) ?? 0
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(selection: $selection)
    }

    final class Coordinator: NSObject {
        var selection: Binding<AppSection>

        init(selection: Binding<AppSection>) {
            self.selection = selection
        }

        @objc func selectSection(_ sender: NSSegmentedControl) {
            guard AppSection.allCases.indices.contains(sender.selectedSegment) else { return }
            selection.wrappedValue = AppSection.allCases[sender.selectedSegment]
        }
    }
}

#Preview {
    ContentView(model: VisaDoneModel())
        .frame(width: 1280, height: 840)
}
