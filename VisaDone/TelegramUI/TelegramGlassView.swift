// SPDX-License-Identifier: GPL-2.0-only
// Adapted from TelegramMessenger/telegram-macos TGUIKit:
// AdaptiveGlassEffectView and FlippedGlassEffectContainerView.
// Copyright Telegram contributors. No private selectors or legacy fallback required.
import AppKit

final class TelegramGlassSurface: NSGlassEffectView {
    private final class Content: NSView { override var isFlipped: Bool { true } }
    let contents: NSView = Content()
    override var isFlipped: Bool { true }
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        style = .regular
        cornerRadius = 20
        contentView = contents
    }
    required init?(coder: NSCoder) { fatalError() }
    override var cornerConfiguration: NSViewCornerConfiguration? { .capsule(maximumRadius: cornerRadius) }
    override func menu(for event: NSEvent) -> NSMenu? { nil }
}

final class TelegramGlassGroup: NSGlassEffectContainerView {
    private final class Content: NSView { override var isFlipped: Bool { true } }
    override var isFlipped: Bool { true }
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        spacing = 5
        contentView = Content()
    }
    required init?(coder: NSCoder) { fatalError() }
    func addSurface(_ surface: TelegramGlassSurface) { contentView?.addSubview(surface) }
}
