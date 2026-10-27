//
//  ContentView.swift
//  VisaDone
//
//  Created by Christopher Lloyd on 2026.10.27.
//

import SwiftUI

/// The app shell. Navigation lives in the native window toolbar; the three
/// destinations are deliberately independent so they can grow separately.
struct ContentView: View {
    @Bindable var model: VisaDoneModel

    var body: some View {
        ZStack {
            switch model.section {
            case .discovery:
                DiscoveryView(model: model)
                    .searchable(text: $model.searchText, placement: .toolbar, prompt: "搜索签证、目的地或攻略")
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
                Picker("页面", selection: $model.section) {
                    ForEach(AppSection.allCases) { section in
                        Text(section.title).tag(section)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .fixedSize(horizontal: true, vertical: true)
                .accessibilityLabel("页面")
                .help("切换社区发现、签证申请和个人主页")
            }
        }
        .navigationTitle("VisaDone")
        .sheet(isPresented: $model.isComposing) {
            ComposePostView(model: model)
        }
    }
}

#Preview {
    ContentView(model: VisaDoneModel())
        .frame(width: 1280, height: 840)
}
