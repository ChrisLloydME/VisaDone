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
    @State private var screenshotAppearance = ScreenshotAppearanceController.shared

    var body: some Scene {
        WindowGroup("VisaDone") {
            ContentView(model: model)
                .frame(minWidth: 980, minHeight: 660)
                .environment(\.locale, Locale(identifier: "zh_Hans_CN"))
                .preferredColorScheme(screenshotAppearance.mode.colorScheme)
                .onAppear {screenshotAppearance.showAtLaunch()}
                .background {
                    WindowSidebarMaterial()
                        .ignoresSafeArea()
                }
                .containerBackground(.clear, for: .window)
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

            CommandGroup(after:.windowArrangement) {
                Button("截图外观…") {screenshotAppearance.show()}
                    .keyboardShortcut("a",modifiers:[.command,.option])
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
    func applicationDidFinishLaunching(_ notification:Notification) {
        NotificationCenter.default.addObserver(self,selector:#selector(mainWindowWillClose(_:)),name:NSWindow.willCloseNotification,object:nil)
    }
    @objc private func mainWindowWillClose(_ notification:Notification) {
        guard let window=notification.object as? NSWindow,!(window is NSPanel),window.canBecomeMain else {return}
        DispatchQueue.main.async {
            let hasMainWindow=NSApp.windows.contains {$0.isVisible && !($0 is NSPanel) && $0.canBecomeMain}
            if !hasMainWindow {
                ScreenshotAppearanceController.shared.close()
                NSApp.terminate(nil)
            }
        }
    }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}

// One behind-window material for the entire main window, including the titlebar.
// Use AppKit's semantic sidebar recipe rather than approximating it with a
// SwiftUI material thickness or stacking a translucent color over the content.
private struct WindowSidebarMaterial: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let effect = SidebarWindowEffectView()
        effect.material = .sidebar
        effect.blendingMode = .behindWindow
        effect.state = .followsWindowActiveState
        return effect
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

private final class SidebarWindowEffectView: NSVisualEffectView {
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        guard let window else { return }
        window.isOpaque = false
        window.backgroundColor = .clear
        window.titlebarAppearsTransparent = true
    }
}
