//
//  VisaDoneApp.swift
//  VisaDone
//
//  Created by Christopher Lloyd on 2026.10.27.
//

import SwiftUI

@main
struct VisaDoneApp: App {
    @State private var model = VisaDoneModel()

    var body: some Scene {
        WindowGroup("VisaDone") {
            ContentView(model: model)
                .frame(minWidth: 980, minHeight: 660)
        }
        .defaultSize(width: 1240, height: 800)
        .windowResizability(.contentMinSize)
        .windowToolbarStyle(UnifiedWindowToolbarStyle(showsTitle: true))
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Post…") {
                    model.section = .discovery
                    model.isComposing = true
                }
                .keyboardShortcut("n", modifiers: .command)
                .disabled(model.section != .discovery)
            }

            CommandMenu("Navigate") {
                ForEach(AppSection.allCases) { section in
                    Button(section.title) {
                        model.section = section
                    }
                    .keyboardShortcut(section.keyboardShortcut, modifiers: .command)
                }
            }
        }
    }
}
