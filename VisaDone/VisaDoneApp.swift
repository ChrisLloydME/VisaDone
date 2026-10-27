//
//  VisaDoneApp.swift
//  VisaDone
//
//  Created by Christopher Lloyd on 2026.10.27.
//

import AppKit
import SwiftUI

@main
struct VisaDoneApp: App {
    @NSApplicationDelegateAdaptor(VisaDoneAppDelegate.self) private var appDelegate
    @State private var model = VisaDoneModel()

    var body: some Scene {
        WindowGroup("VisaDone") {
            ContentView(model: model)
                .frame(minWidth: 980, minHeight: 660)
                .environment(\.locale, Locale(identifier: "zh_Hans_CN"))
                .containerBackground(.thinMaterial, for: .window)
        }
        .defaultSize(width: 1240, height: 800)
        .windowResizability(.contentMinSize)
        .windowToolbarStyle(UnifiedWindowToolbarStyle(showsTitle: false))
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("发布帖子…") {
                    model.section = .discovery
                    model.isComposing = true
                }
                .keyboardShortcut("n", modifiers: .command)
                .disabled(model.section != .discovery)
            }

            CommandMenu("前往") {
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

final class VisaDoneAppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
