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
                .containerBackground(.thinMaterial, for: .window)
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

final class VisaDoneAppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
