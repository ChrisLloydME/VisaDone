// SPDX-License-Identifier: GPL-2.0-only
// AppKit notification center: native Messages-style sidebar and Telegram chat UI.
// Message geometry and glass components adapted from Telegram contributors.
// See DesignResources/Notifications/README.md and Licenses/Telegram-GPL-2.0.txt.
import AppKit
import SwiftUI

// Shared desktop scale: functional bars, two-line navigation, conversation rows.
private enum InboxMetrics {
    static let control: CGFloat = 36
    static let navigation: CGFloat = 48
    static let row: CGFloat = 72
    static let topAccessory: CGFloat = 60
    static let gutter: CGFloat = 12
}

private enum InboxStyle {
    static var accent: NSColor {
        NSColor(named: "AccentColor") ?? NSColor(name: nil) {
            $0.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
                ? NSColor(srgbRed: 0.44, green: 0.78, blue: 0.72, alpha: 1)
                : NSColor(srgbRed: 0.08, green: 0.36, blue: 0.33, alpha: 1)
        }
    }
    static var incoming: NSColor { NSColor(name: nil) { $0.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? NSColor(calibratedWhite: 0.21, alpha: 1) : .white } }
    static var outgoing: NSColor { NSColor(name: nil) { $0.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? InboxStyle.accent.blended(withFraction: 0.70, of: NSColor(calibratedWhite: 0.12, alpha: 1))! : InboxStyle.accent.blended(withFraction: 0.86, of: .white)! } }
    static func label(_ text: String = "", _ size: CGFloat = 13, _ weight: NSFont.Weight = .regular, _ color: NSColor = .labelColor) -> NSTextField {
        let label = NSTextField(labelWithString: text)
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = color
        label.lineBreakMode = .byTruncatingTail
        return label
    }
    static func symbol(_ name: String, size: CGFloat = 18) -> NSImage? {
        NSImage(systemSymbolName: name, accessibilityDescription: nil)?.withSymbolConfiguration(.init(pointSize: size, weight: .regular))
    }
}

private class InboxFlippedView: NSView {
    override var isFlipped: Bool { true }
    var onLayout: (() -> Void)?
    override func layout() { super.layout(); onLayout?() }
}

// An AppKit split-item accessory owns the system scroll-edge treatment. A sibling
// glass view alone cannot register an overlay edge with the scrolling content.
private final class InboxSearchAccessory: NSSplitViewItemAccessoryViewController {
    private let surface: NSView
    init(surface: NSView) {
        self.surface = surface
        super.init(nibName: nil, bundle: nil)
        automaticallyAppliesContentInsets = false
        preferredScrollEdgeEffectStyle = .soft
    }
    required init?(coder: NSCoder) { fatalError() }
    override func loadView() {
        let content = InboxFlippedView(frame: NSRect(x: 0, y: 0, width: 320, height: InboxMetrics.topAccessory))
        content.heightAnchor.constraint(equalToConstant: InboxMetrics.topAccessory).isActive = true
        content.addSubview(surface)
        content.onLayout = { [weak self, weak content] in
            guard let self, let content else { return }
            self.surface.frame = NSRect(x: InboxMetrics.gutter, y: InboxMetrics.gutter, width: max(0,content.bounds.width-InboxMetrics.gutter*2), height: InboxMetrics.control)
        }
        view = content
    }
}

private final class InboxAvatar: NSView {
    var image: NSImage? { didSet { needsDisplay = true } }
    var system = false { didSet { needsDisplay = true } }
    override var isFlipped: Bool { true }
    override func draw(_ dirtyRect: NSRect) {
        NSBezierPath(ovalIn: bounds).addClip()
        if let image {
            let ratio = max(bounds.width / image.size.width, bounds.height / image.size.height)
            let size = NSSize(width: image.size.width * ratio, height: image.size.height * ratio)
            image.draw(in: NSRect(x: (bounds.width-size.width)/2, y: (bounds.height-size.height)/2, width: size.width, height: size.height), from: .zero, operation: .sourceOver, fraction: 1, respectFlipped: true, hints: nil)
        } else {
            InboxStyle.accent.setFill(); bounds.fill()
            let symbol = InboxStyle.symbol(system ? "bell.fill" : "person.fill", size: bounds.width * 0.43)
            symbol?.lockFocus(); NSColor.white.set(); NSRect(origin: .zero, size: symbol?.size ?? .zero).fill(using: .sourceAtop); symbol?.unlockFocus()
            symbol?.draw(in: bounds.insetBy(dx: bounds.width * 0.27, dy: bounds.height * 0.27), from: .zero, operation: .sourceOver, fraction: 1, respectFlipped: true, hints: nil)
        }
    }
    func set(_ conversation: InboxConversation) {
        system = conversation.kind == .system
        image = conversation.author.flatMap { NSImage(named: $0.avatarImage) }
    }
}

// iMessage-style conversation content inside AppKit's native macOS sidebar rows.
// Selection/material come from NSTableView.Style.sourceList, not a painted Telegram row.
private final class MessagesConversationCell: NSTableCellView {
    private let avatar = InboxAvatar()
    private let title = InboxStyle.label("", 13, .semibold)
    private let date = InboxStyle.label("", 11, .regular, .secondaryLabelColor)
    private let preview = InboxStyle.label("", 12.5, .regular, .secondaryLabelColor)
    private let postTitle = InboxStyle.label("", 10.5, .regular, .tertiaryLabelColor)
    private let unread = NSView()
    private let separator = NSBox()
    private let mute = NSImageView()
    private var conversation: InboxConversation?
    override var isFlipped: Bool { true }
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        [avatar,title,date,preview,postTitle,unread,separator,mute].forEach(addSubview)
        preview.maximumNumberOfLines = 2; preview.cell?.wraps = true
        unread.wantsLayer = true; unread.layer?.cornerRadius = 3
        separator.boxType = .separator
        mute.image = InboxStyle.symbol("bell.slash.fill", size: 10)
    }
    required init?(coder: NSCoder) { fatalError() }
    func set(_ conversation: InboxConversation, selected: Bool) {
        self.conversation = conversation
        avatar.set(conversation)
        title.stringValue = conversation.name
        date.stringValue = conversation.time
        // Like Messages: the preview is the actual latest message, not an extra row of labels.
        preview.stringValue = (conversation.kind == .comment && conversation.messages.last?.outgoing == true ? "你：" : "") + conversation.preview.replacingOccurrences(of: "\n", with: " ")
        postTitle.isHidden = conversation.kind != .comment
        postTitle.stringValue = ProfileFixtures.authoredPosts.first { $0.id == conversation.postID }.map { "↳  " + $0.title } ?? "社区讨论"
        unread.isHidden = conversation.unread == 0
        unread.layer?.backgroundColor = NSColor.controlAccentColor.cgColor
        unread.setAccessibilityLabel("\(conversation.unread) 条未读")
        mute.isHidden = !conversation.muted
        applyNativeTextColors()
        separator.isHidden = selected
        setAccessibilityLabel("\(conversation.name)，\(conversation.time)，\(conversation.preview)")
        needsLayout = true
    }
    override var backgroundStyle: NSView.BackgroundStyle {
        didSet { applyNativeTextColors() }
    }
    private func applyNativeTextColors() {
        // Selection is gray when focus moves to the chat; white text only belongs to emphasized rows.
        let emphasized = backgroundStyle == .emphasized
        title.textColor = emphasized ? .alternateSelectedControlTextColor : .labelColor
        preview.textColor = emphasized ? .alternateSelectedControlTextColor : .secondaryLabelColor
        postTitle.textColor = emphasized ? .alternateSelectedControlTextColor : .tertiaryLabelColor
        date.textColor = emphasized ? .alternateSelectedControlTextColor : .secondaryLabelColor
        mute.contentTintColor = emphasized ? .alternateSelectedControlTextColor : .tertiaryLabelColor
    }
    override func layout() {
        super.layout()
        // Native source-list insets + these coordinates yield Messages' 26/72pt alignment.
        avatar.frame = NSRect(x: 10, y: 16, width: 36, height: 36)
        unread.frame = NSRect(x: 0, y: 31, width: 6, height: 6)
        date.sizeToFit()
        let dateWidth = min(72,date.frame.width)
        date.frame = NSRect(x: bounds.width-dateWidth-8, y: 13, width: dateWidth, height: 16)
        let muteWidth: CGFloat = mute.isHidden ? 0 : 15
        title.frame = NSRect(x: 56, y: 11, width: max(0,date.frame.minX-63-muteWidth), height: 18)
        mute.frame = NSRect(x: title.frame.maxX+3, y: 14, width: 11, height: 11)
        preview.frame = NSRect(x: 56, y: 31, width: max(0,bounds.width-64), height: 31)
        postTitle.frame = NSRect(x: 56, y: 67, width: max(0,bounds.width-64), height: 15)
        separator.frame = NSRect(x: 56, y: bounds.height-1, width: max(0,bounds.width-64), height: 1)
    }
}

// Keep native button hit testing, keyboard focus and accessibility, but give the
// image and title explicit non-overlapping slots instead of a push-button bezel.
private final class SidebarTabButtonCell: NSButtonCell {
    override func imageRect(forBounds rect: NSRect) -> NSRect {
        NSRect(x: rect.midX-10, y: rect.minY+4, width: 20, height: 18)
    }
    override func titleRect(forBounds rect: NSRect) -> NSRect {
        NSRect(x: rect.minX+4, y: rect.minY+24, width: rect.width-8, height: 13)
    }
}
private final class SidebarTabButton: NSButton {
    override var isFlipped: Bool { true }
}

private final class InboxPlaceholder: NSTextField {
    override func hitTest(_ point: NSPoint) -> NSView? { nil }
}

private final class InboxComposerText: NSTextView {
    var send: (() -> Void)?
    override func keyDown(with event: NSEvent) {
        if (event.keyCode == 36 || event.keyCode == 76) && !event.modifierFlags.contains(.shift) && !hasMarkedText() { send?(); return }
        super.keyDown(with: event)
    }
}

// Native text layout plus the original Telegram nine-slice bubble images.
// Unlike a fixed-width card, each bubble follows its actual text/attachment size.
private final class TelegramMessageView: InboxFlippedView {
    private let backdrop = NSImageView()
    private let bodyText = NSTextView()
    private let stamp = InboxStyle.label("", 11, .regular, .secondaryLabelColor)
    private let status = NSImageView()
    private let photo = NSImageView()
    private let fileTitle = InboxStyle.label("", 13, .medium)
    private let fileMeta = InboxStyle.label("PDF · 公开版本", 11, .regular, .secondaryLabelColor)
    private let fileIcon = NSImageView()
    private let attachment = NSButton()
    private let message: InboxMessage
    private let neighbors: MessageBubbleImageNeighbors
    var openAttachment: (() -> Void)?
    var bubbleWidth: CGFloat = 0
    private var bubbleRect = NSRect.zero
    private var cachedAppearance = ""
    init(message: InboxMessage, neighbors: MessageBubbleImageNeighbors) {
        self.message = message; self.neighbors = neighbors
        super.init(frame: .zero)
        [backdrop, photo, fileIcon, fileTitle, fileMeta, attachment, bodyText, stamp, status].forEach(addSubview)
        backdrop.imageScaling = .scaleAxesIndependently
        bodyText.isEditable = false; bodyText.isSelectable = true; bodyText.drawsBackground = false
        bodyText.textContainerInset = .zero; bodyText.textContainer?.lineFragmentPadding = 0
        bodyText.isVerticallyResizable = false; bodyText.isHorizontallyResizable = false
        let paragraph = NSMutableParagraphStyle(); paragraph.lineSpacing = 2
        bodyText.textStorage?.setAttributedString(NSAttributedString(string: message.text, attributes: [.font: NSFont.systemFont(ofSize: 14), .foregroundColor: NSColor.labelColor, .paragraphStyle: paragraph]))
        stamp.stringValue = message.time.split(separator: " ").last.map(String.init) ?? message.time
        stamp.lineBreakMode = .byClipping
        status.image = InboxStyle.symbol("checkmark", size: 10); status.contentTintColor = InboxStyle.accent
        status.isHidden = !message.outgoing
        photo.image = message.image.flatMap { NSImage(named: $0) }; photo.imageScaling = .scaleAxesIndependently
        photo.wantsLayer = true; photo.layer?.cornerRadius = 12; photo.layer?.masksToBounds = true
        photo.isHidden = message.image == nil
        fileTitle.stringValue = message.document ?? ""
        fileIcon.image = InboxStyle.symbol("doc.fill", size: 32); fileIcon.contentTintColor = InboxStyle.accent
        [fileTitle,fileMeta,fileIcon].forEach { $0.isHidden = message.document == nil }
        attachment.isBordered = false; attachment.title = ""; attachment.target = self; attachment.action = #selector(open)
        attachment.isHidden = message.document == nil && message.image == nil
    }
    required init?(coder: NSCoder) { fatalError() }
    @objc private func open() { openAttachment?() }
    func highlight(_ query: String) {
        guard let storage = bodyText.textStorage else { return }
        let range = NSRange(location: 0, length: storage.length)
        storage.removeAttribute(.backgroundColor, range: range)
        guard !query.isEmpty else { return }
        let found = (message.text as NSString).range(of: query, options: [.caseInsensitive])
        if found.location != NSNotFound { storage.addAttribute(.backgroundColor, value: InboxStyle.accent.withAlphaComponent(0.3), range: found) }
    }
    override func viewDidChangeEffectiveAppearance() { super.viewDidChangeEffectiveAppearance(); cachedAppearance = ""; needsLayout = true }
    func measure(width: CGFloat) -> CGFloat {
        let maxContent = min(380, max(180, width-110))
        let storage = bodyText.textStorage!
        let manager = bodyText.layoutManager!
        let container = bodyText.textContainer!
        container.containerSize = NSSize(width: maxContent, height: 10000)
        manager.ensureLayout(for: container)
        let used = manager.usedRect(for: container)
        let glyphs = manager.glyphRange(for: container)
        let lastLine: NSRect = glyphs.length > 0 ? manager.lineFragmentUsedRect(forGlyphAt: NSMaxRange(glyphs)-1, effectiveRange: nil) : .zero
        let metaWidth = ceil((stamp.stringValue as NSString).size(withAttributes: [.font: stamp.font!]).width) + 8 + (message.outgoing ? 18 : 0)
        var contentWidth = ceil(used.width)
        if used.height < 26 { contentWidth = min(maxContent, contentWidth+metaWidth+10) }
        if message.image != nil { contentWidth = min(320,maxContent) }
        if message.document != nil { contentWidth = max(contentWidth, min(294,maxContent)) }
        contentWidth = max(contentWidth, 64)
        container.containerSize = NSSize(width: contentWidth, height: 10000)
        manager.ensureLayout(for: container)
        let measured = manager.usedRect(for: container)
        let dateFits = lastLine.width + metaWidth + 10 <= contentWidth
        let extraDate: CGFloat = dateFits ? 0 : 16
        let mediaHeight: CGFloat = message.image != nil ? floor(contentWidth*2/3)+7 : message.document != nil ? 60 : 0
        let height = max(36, ceil(measured.height)+16+mediaHeight+extraDate)
        bubbleWidth = contentWidth+28
        let x = message.outgoing ? width-bubbleWidth-16 : 16
        bubbleRect = NSRect(x: x, y: 0, width: bubbleWidth, height: height)
        backdrop.frame = bubbleRect
        let textX = x + (message.outgoing ? 11 : 17)
        bodyText.frame = NSRect(x: textX, y: mediaHeight+7, width: contentWidth, height: ceil(measured.height)+1)
        // Reflow to measured content width, preserving the last-line date reservation.
        container.containerSize = NSSize(width: contentWidth, height: 10000)
        manager.ensureLayout(for: container)
        stamp.frame = NSRect(x: bubbleRect.maxX-metaWidth-(message.outgoing ? 12 : 17), y: height-17, width: metaWidth-(message.outgoing ? 15 : 0), height: 13)
        status.frame = NSRect(x: bubbleRect.maxX-23, y: height-16, width: 11, height: 11)
        if message.image != nil {
            photo.frame = NSRect(x: textX-7, y: 3, width: contentWidth+14, height: mediaHeight-7)
            attachment.frame = photo.frame
        }
        if message.document != nil {
            fileIcon.frame = NSRect(x: textX+2, y: 13, width: 36, height: 36)
            fileTitle.frame = NSRect(x: textX+48, y: 13, width: contentWidth-48, height: 20)
            fileMeta.frame = NSRect(x: textX+48, y: 35, width: contentWidth-48, height: 16)
            attachment.frame = NSRect(x: textX, y: 3, width: contentWidth, height: 56)
        }
        let appearance = effectiveAppearance.name.rawValue
        if cachedAppearance != appearance {
            effectiveAppearance.performAsCurrentDrawingAppearance {
                let color = message.outgoing ? InboxStyle.outgoing : InboxStyle.incoming
                let (image,insets) = messageBubbleImageModern(incoming: !message.outgoing, fillColor: color, strokeColor: .clear, neighbors: neighbors)
                let rendered = NSImage(cgImage: image, size: NSSize(width: 38, height: 32))
                rendered.capInsets = insets; rendered.resizingMode = .stretch
                backdrop.image = rendered
            }
            cachedAppearance = appearance
        }
        _ = storage
        return height
    }
}

final class NativeNotificationController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, NSSearchFieldDelegate, NSTextViewDelegate {
    let inbox: NotificationInbox
    var onOpenPost: ((String) -> Void)?
    var onOpenAttachment: (() -> Void)?
    private let splitController = NSSplitViewController()
    private let sidebarController = NSViewController()
    private let chatController = NSViewController()
    private var searchAccessory: InboxSearchAccessory?
    private var initialSplitPositionSet = false
    private var isLayingOutPanes = false
    private let sidebar = InboxFlippedView()
    private let chat = InboxFlippedView()
    private let commentHost = NSHostingView(rootView: AnyView(EmptyView()))
    private var sidebarRowHeight: CGFloat { inbox.filter == .comment ? 94 : InboxMetrics.row }
    private let searchSurface = TelegramGlassSurface()
    private let search = NSSearchField()
    private let sidebarTabs = TelegramGlassSurface()
    private let sidebarTabSelection = NSView()
    private let sidebarTabKinds: [InboxKind] = [.direct,.comment]
    private var sidebarTabButtons: [NSButton] = []
    private let listScroll = NSScrollView()
    private let listDocument = InboxFlippedView()
    private let table = NSTableView()
    private let peerName = InboxStyle.label("", 13, .semibold)
    private let peerStatus = InboxStyle.label("", 11, .regular, .secondaryLabelColor)
    private let peerAvatar = InboxAvatar()
    private let options = NSButton()
    private let headerGlass = TelegramGlassGroup()
    private let peerSurface = TelegramGlassSurface()
    private let actionSurface = TelegramGlassSurface()
    private let searchMessages = NSButton()
    private let historySearch = NSSearchField()
    private let reference = NSButton()
    private let history = NSScrollView()
    private let document = InboxFlippedView()
    private let date = InboxStyle.label("今天", 11, .medium, .secondaryLabelColor)
    private let composerGlass = TelegramGlassGroup()
    private let attachSurface = TelegramGlassSurface()
    private let fieldSurface = TelegramGlassSurface()
    private let sendSurface = TelegramGlassSurface()
    private let attachButton = NSButton()
    private let emojiButton = NSButton()
    private let inputScroll = NSScrollView()
    private let input = InboxComposerText()
    private let placeholder = InboxPlaceholder(labelWithString: "发送消息…")
    private let sendButton = NSButton()
    private let systemFooter = InboxStyle.label("此账号仅用于接收服务通知", 12, .regular, .secondaryLabelColor)
    private let emptyLabel = InboxStyle.label("选择一条会话，继续讨论", 14, .regular, .secondaryLabelColor)
    private var rows: [InboxConversation] = []
    private var messages: [TelegramMessageView] = []
    private var currentID = ""
    private var messageSignature = ""
    private var pendingScrollToBottom = false
    private var loadingDraft = false
    init(inbox: NotificationInbox) { self.inbox = inbox; super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { fatalError() }
    override func loadView() {
        let root = InboxFlippedView(); view = root
        // Let the native split controller connect accessory edges to descendant scroll views.
        sidebarController.view = sidebar
        chatController.view = chat
        let sidebarItem = NSSplitViewItem(viewController: sidebarController)
        sidebarItem.minimumThickness = 260; sidebarItem.maximumThickness = 390
        sidebarItem.holdingPriority = .init(251)
        sidebarItem.canCollapse = false
        let chatItem = NSSplitViewItem(viewController: chatController)
        chatItem.minimumThickness = 500
        let accessory = InboxSearchAccessory(surface: searchSurface)
        searchAccessory = accessory
        sidebarItem.addTopAlignedAccessoryViewController(accessory)
        splitController.addSplitViewItem(sidebarItem)
        splitController.addSplitViewItem(chatItem)
        splitController.splitView.isVertical = true
        splitController.splitView.dividerStyle = .thin
        addChild(splitController)
        root.addSubview(splitController.view)
        root.onLayout = { [weak self] in self?.layoutPanes() }
        sidebar.onLayout = { [weak self] in self?.layoutPanes() }
        chat.onLayout = { [weak self] in self?.layoutPanes() }
        // The shared SwiftUI window supplies the material. Keep both panes transparent.
        [listScroll,sidebarTabs].forEach(sidebar.addSubview)
        searchSurface.contents.addSubview(search)
        searchSurface.cornerRadius = 18
        // Preserve the native search field's editing, menu, clear button and accessibility;
        // let NSGlassEffectView provide its actual system glass bezel.
        search.isBezeled = false
        search.drawsBackground = false
        search.placeholderString = "搜索"; search.font = .systemFont(ofSize: 13)
        search.controlSize = .large; search.delegate = self
        search.sendsSearchStringImmediately = true; search.sendsWholeSearchString = false
        search.focusRingType = .none
        let searchMenu = NSMenu()
        searchMenu.addItem(withTitle: "全部标为已读", action: #selector(markAllRead), keyEquivalent: "").target = self
        search.searchMenuTemplate = searchMenu
        search.toolTip = "搜索当前分类中的联系人和消息"
        sidebarTabs.cornerRadius = InboxMetrics.navigation/2
        sidebarTabSelection.wantsLayer = true
        sidebarTabSelection.layer?.cornerRadius = (InboxMetrics.navigation-8)/2
        sidebarTabSelection.layer?.backgroundColor = NSColor.labelColor.withAlphaComponent(0.07).cgColor
        sidebarTabs.contents.addSubview(sidebarTabSelection)
        let symbols = ["person.fill", "text.bubble.fill"]
        for (index,kind) in sidebarTabKinds.enumerated() {
            let button = SidebarTabButton(frame: .zero)
            button.cell = SidebarTabButtonCell(textCell: kind.rawValue)
            button.title = kind.rawValue
            button.target = self; button.action = #selector(filterTabChanged(_:))
            button.tag = index
            button.setButtonType(.momentaryChange)
            button.isBordered = false
            button.font = .systemFont(ofSize: 11, weight: .semibold)
            button.alignment = .center
            button.image = InboxStyle.symbol(symbols[index], size: 18)
            button.imagePosition = .imageAbove
            button.imageScaling = .scaleProportionallyDown
            sidebarTabs.contents.addSubview(button)
            sidebarTabButtons.append(button)
        }
        listDocument.addSubview(table)
        listScroll.documentView = listDocument
        listScroll.automaticallyAdjustsContentInsets = false
        listScroll.drawsBackground = false; listScroll.hasVerticalScroller = true; listScroll.autohidesScrollers = true
        table.addTableColumn(NSTableColumn(identifier: .init("conversation")))
        table.headerView = nil; table.rowHeight = InboxMetrics.row; table.intercellSpacing = .zero
        table.style = .sourceList; table.usesAutomaticRowHeights = false
        table.backgroundColor = .clear; table.selectionHighlightStyle = .regular
        listScroll.contentView.drawsBackground = false
        listScroll.scrollerStyle = .overlay
        table.dataSource = self; table.delegate = self; table.focusRingType = .none
        table.columnAutoresizingStyle = .firstColumnOnlyAutoresizingStyle
        let menu = NSMenu(); menu.delegate = nil
        menu.addItem(withTitle: "标为未读", action: #selector(markUnread), keyEquivalent: "").target = self
        menu.addItem(withTitle: "切换静音", action: #selector(toggleMute), keyEquivalent: "").target = self
        table.menu = menu
        // New Telegram layout: history extends behind two independent glass groups.
        [history,reference,historySearch,headerGlass,composerGlass,emptyLabel,commentHost].forEach(chat.addSubview)
        commentHost.isHidden = true
        headerGlass.addSurface(peerSurface); headerGlass.addSurface(actionSurface)
        [peerName,peerStatus,peerAvatar].forEach(peerSurface.contents.addSubview)
        [searchMessages,options].forEach(actionSurface.contents.addSubview)
        composerGlass.addSurface(attachSurface); composerGlass.addSurface(fieldSurface); composerGlass.addSurface(sendSurface)
        attachSurface.contents.addSubview(attachButton)
        [inputScroll,placeholder,emojiButton,systemFooter].forEach(fieldSurface.contents.addSubview)
        sendSurface.contents.addSubview(sendButton)
        historySearch.isHidden = true; historySearch.placeholderString = "搜索当前会话"; historySearch.delegate = self
        searchMessages.image = InboxStyle.symbol("magnifyingglass", size: 16); searchMessages.isBordered = false
        searchMessages.target = self; searchMessages.action = #selector(toggleHistorySearch)
        searchMessages.toolTip = "搜索当前会话"
        attachButton.image = InboxStyle.symbol("paperclip", size: 16); attachButton.isBordered = false
        attachButton.target = self; attachButton.action = #selector(showAttachments); attachButton.toolTip = "分享文件"
        emojiButton.image = InboxStyle.symbol("face.smiling", size: 16); emojiButton.isBordered = false
        emojiButton.target = self; emojiButton.action = #selector(showEmoji); emojiButton.toolTip = "表情"
        [searchMessages,attachButton,emojiButton,options].forEach { $0.contentTintColor = .labelColor }
        peerStatus.textColor = InboxStyle.accent
        options.image = InboxStyle.symbol("ellipsis", size: 17); options.isBordered = false; options.contentTintColor = .secondaryLabelColor
        options.target = self; options.action = #selector(showOptions)
        options.toolTip = "会话选项"

        reference.isBordered = false; reference.alignment = .left; reference.font = .systemFont(ofSize: 11.5)
        reference.contentTintColor = InboxStyle.accent; reference.target = self; reference.action = #selector(openPost)
        history.documentView = document; history.hasVerticalScroller = true; history.autohidesScrollers = true
        history.drawsBackground = false
        history.backgroundColor = .clear
        history.contentView.drawsBackground = false
        document.addSubview(date); date.alignment = .center
        inputScroll.documentView = input; inputScroll.drawsBackground = false; inputScroll.hasVerticalScroller = true; inputScroll.autohidesScrollers = true
        input.font = .systemFont(ofSize: 13); input.textColor = .labelColor; input.drawsBackground = false
        input.isRichText = false; input.isAutomaticQuoteSubstitutionEnabled = false
        input.textContainerInset = NSSize(width: 0, height: 3)
        input.textContainer?.lineFragmentPadding = 0; input.isVerticallyResizable = true
        input.autoresizingMask = [.width]; input.delegate = self
        input.send = { [weak self] in self?.sendMessage() }
        placeholder.isSelectable = false; placeholder.font = .systemFont(ofSize: 13); placeholder.textColor = .placeholderTextColor
        sendButton.image = InboxStyle.symbol("paperplane.fill", size: 17); sendButton.isBordered = false
        sendButton.target = self; sendButton.action = #selector(sendMessage); sendButton.toolTip = "发送 · Return"
        refresh()
    }
    override func viewDidAppear() { super.viewDidAppear(); view.needsLayout = true }
    func refresh() {
        guard isViewLoaded else { return }
        rows = inbox.visibleConversations
        if search.stringValue != inbox.query { search.stringValue = inbox.query }
        search.placeholderString = inbox.filter == .all ? "搜索" : "搜索\(inbox.filter.rawValue)"
        for (index,button) in sidebarTabButtons.enumerated() {
            let kind = sidebarTabKinds[index]
            let selected = kind == inbox.filter
            button.state = .off
            button.isBordered = false
            button.contentTintColor = selected ? InboxStyle.accent : .labelColor
            button.attributedTitle = NSAttributedString(string: kind.rawValue, attributes: [
                .font: NSFont.systemFont(ofSize: 11, weight: .semibold),
                .foregroundColor: selected ? InboxStyle.accent : NSColor.labelColor
            ])
            let unread = inbox.conversations.filter { kind == .direct ? $0.kind != .comment : $0.kind == .comment }.reduce(0) { $0 + $1.unread }
            button.toolTip = unread > 0 ? "\(kind.rawValue) · \(unread) 条未读" : kind.rawValue
            button.setAccessibilityLabel("\(kind.rawValue)\(selected ? "，当前分类" : "")，\(unread) 条未读")
        }
        table.rowHeight = sidebarRowHeight
        table.reloadData()
        let selectedIndex = rows.firstIndex { $0.id == inbox.selectedID }
        if let selectedIndex { table.selectRowIndexes(IndexSet(integer: selectedIndex), byExtendingSelection: false) }
        guard let conversation = rows.first(where: { $0.id == inbox.selectedID }) else {
            [headerGlass,composerGlass,reference,historySearch,history].forEach { $0.isHidden = true }
            commentHost.isHidden = true
            emptyLabel.isHidden = false; layoutPanes(); return
        }
        emptyLabel.isHidden = true
        let isComment = conversation.kind == .comment
        commentHost.isHidden = !isComment
        if isComment {
            [headerGlass,composerGlass,reference,historySearch,history].forEach { $0.isHidden = true }
            commentHost.rootView = AnyView(CommentThreadView(inbox: inbox, threadID: conversation.id, onOpenPost: { [weak self] id in self?.onOpenPost?(id) }).id(conversation.id))
            layoutPanes()
            return
        }
        [headerGlass,composerGlass,history].forEach { $0.isHidden = false }
        peerName.stringValue = conversation.name; peerStatus.stringValue = conversation.subtitle; peerAvatar.set(conversation)
        date.stringValue = conversation.time.contains(":") || conversation.time == "刚刚" ? "今天" : conversation.time
        reference.isHidden = conversation.postID == nil
        reference.title = "↪  社区评论    ·    查看原帖"
        systemFooter.isHidden = conversation.kind != .system
        inputScroll.isHidden = conversation.kind == .system
        attachSurface.isHidden = conversation.kind == .system
        sendSurface.isHidden = conversation.kind == .system
        emojiButton.isHidden = conversation.kind == .system
        if currentID != conversation.id {
            loadingDraft = true; input.string = inbox.drafts[conversation.id] ?? ""; loadingDraft = false
            historySearch.isHidden = true; historySearch.stringValue = ""
        }
        placeholder.stringValue = conversation.kind == .comment ? "回复这条评论…" : "发送消息…"
        placeholder.isHidden = conversation.kind == .system || !input.string.isEmpty
        sendButton.isEnabled = !input.string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        sendButton.contentTintColor = sendButton.isEnabled ? InboxStyle.accent : .tertiaryLabelColor
        let signature = conversation.id + conversation.messages.map(\.id).joined()
        let changed = signature != messageSignature
        currentID = conversation.id
        if changed {
            messages.forEach { $0.removeFromSuperview() }; messages = []
            for (i,message) in conversation.messages.enumerated() {
                let previous = i > 0 && conversation.messages[i-1].outgoing == message.outgoing
                let next = i+1 < conversation.messages.count && conversation.messages[i+1].outgoing == message.outgoing
                let neighbors: MessageBubbleImageNeighbors = previous ? (next ? .both : .bottom) : (next ? .top(side: false) : .none)
                let item = TelegramMessageView(message: message, neighbors: neighbors)
                item.openAttachment = { [weak self] in self?.onOpenAttachment?() }
                document.addSubview(item); messages.append(item)
            }
            messageSignature = signature
            pendingScrollToBottom = true
        }
        layoutPanes()
    }
    private func layoutPanes() {
        guard isViewLoaded, !isLayingOutPanes else { return }
        isLayingOutPanes = true
        defer { isLayingOutPanes = false }
        splitController.view.frame = view.bounds
        splitController.view.layoutSubtreeIfNeeded()
        if !initialSplitPositionSet && view.bounds.width > 0 {
            splitController.splitView.setPosition(320, ofDividerAt: 0)
            initialSplitPositionSet = true
            splitController.view.layoutSubtreeIfNeeded()
        }
        let left = sidebar.bounds.width
        search.frame = NSRect(x: 10, y: 4, width: left-44, height: InboxMetrics.control-8)
        // The viewport reaches the toolbar. Only the document has initial spacing;
        // rows scroll behind the floating glass search field, not into a clipped 60pt header.
        listScroll.frame = sidebar.bounds
        let initialSpacing = InboxMetrics.topAccessory
        let listWidth = listScroll.contentSize.width
        listDocument.frame = NSRect(x: 0, y: 0, width: listWidth, height: max(listScroll.contentSize.height,initialSpacing + CGFloat(rows.count) * sidebarRowHeight + 72))
        // Let sourceList calculate its own macOS 27 insets and selection geometry.
        table.frame = NSRect(x: 0, y: initialSpacing, width: listWidth, height: CGFloat(rows.count) * sidebarRowHeight)
        table.tile()
        for row in rows.indices { _ = table.rowView(atRow: row, makeIfNecessary: true) }
        table.needsDisplay = true
        // Compact reference proportions: one glass surface, one selection, fixed image/title slots.
        let tabBarWidth = min(224,max(180,left-40))
        sidebarTabs.frame = NSRect(x: (left-tabBarWidth)/2, y: max(60,sidebar.bounds.height-InboxMetrics.navigation-InboxMetrics.gutter), width: tabBarWidth, height: InboxMetrics.navigation)
        let tabWidth = (tabBarWidth-8)/CGFloat(sidebarTabKinds.count)
        for (index,button) in sidebarTabButtons.enumerated() {
            button.frame = NSRect(x: 4+CGFloat(index)*tabWidth, y: 4, width: tabWidth, height: InboxMetrics.navigation-8)
        }
        let selectedTab = sidebarTabKinds.firstIndex(of: inbox.filter) ?? 0
        sidebarTabSelection.frame = NSRect(x: 4+CGFloat(selectedTab)*tabWidth, y: 4, width: tabWidth, height: InboxMetrics.navigation-8)
        sidebarTabs.effectiveAppearance.performAsCurrentDrawingAppearance {
            sidebarTabSelection.layer?.backgroundColor = NSColor.labelColor.withAlphaComponent(0.07).cgColor
        }
        let width = chat.bounds.width, height = chat.bounds.height
        commentHost.frame = chat.bounds
        // One functional scale: search, header and composer all use 36pt glass surfaces.
        let barHeight = InboxMetrics.control
        let side = InboxMetrics.gutter, gap: CGFloat = 8
        headerGlass.frame = NSRect(x: 0, y: 0, width: width, height: InboxMetrics.topAccessory)
        let actionsWidth: CGFloat = 72
        let peerWidth = max(80,width-side*2-gap-actionsWidth)
        peerSurface.frame = NSRect(x: side, y: side, width: peerWidth, height: barHeight)
        peerSurface.cornerRadius = barHeight/2
        actionSurface.frame = NSRect(x: side+peerWidth+gap, y: side, width: actionsWidth, height: barHeight)
        actionSurface.cornerRadius = barHeight/2
        peerAvatar.frame = NSRect(x: 4, y: 4, width: 28, height: 28)
        peerName.frame = NSRect(x: 40, y: 3, width: max(0,peerWidth-52), height: 17)
        peerStatus.frame = NSRect(x: 40, y: 20, width: max(0,peerWidth-52), height: 14)
        searchMessages.frame = NSRect(x: 2, y: 2, width: 32, height: 32)
        options.frame = NSRect(x: 38, y: 2, width: 32, height: 32)
        reference.frame = NSRect(x: 24, y: 56, width: width-48, height: 28)
        historySearch.frame = NSRect(x: side, y: 56, width: width-side*2, height: 28)
        history.frame = NSRect(x: 0, y: 0, width: width, height: height)
        let inputHeight = InboxMetrics.control
        composerGlass.frame = NSRect(x: 0, y: max(0,height-InboxMetrics.topAccessory), width: width, height: InboxMetrics.topAccessory)
        let system = inbox.selected?.kind == .system
        let fieldX = system ? side : side+inputHeight+gap
        let rightInset = system ? side : side+inputHeight+gap
        let fieldWidth = max(40,width-fieldX-rightInset)
        attachSurface.frame = NSRect(x: side, y: side, width: inputHeight, height: inputHeight)
        attachSurface.cornerRadius = inputHeight/2
        fieldSurface.frame = NSRect(x: fieldX, y: side, width: fieldWidth, height: inputHeight)
        fieldSurface.cornerRadius = inputHeight/2
        sendSurface.frame = NSRect(x: width-side-inputHeight, y: side, width: inputHeight, height: inputHeight)
        sendSurface.cornerRadius = inputHeight/2
        attachButton.frame = NSRect(x: 0, y: 0, width: inputHeight, height: inputHeight)
        sendButton.frame = attachButton.frame
        let textWidth = max(0,fieldWidth-52)
        inputScroll.frame = NSRect(x: side, y: 6, width: textWidth, height: 24)
        input.setFrameSize(NSSize(width: textWidth, height: max(24,input.frame.height)))
        input.textContainer?.containerSize = NSSize(width: textWidth, height: .greatestFiniteMagnitude)
        placeholder.frame = NSRect(x: side, y: 10, width: textWidth, height: 17)
        emojiButton.frame = NSRect(x: fieldWidth-inputHeight, y: 0, width: inputHeight, height: inputHeight)
        systemFooter.frame = NSRect(x: side, y: 11, width: fieldWidth-side*2, height: 17)
        emptyLabel.frame = NSRect(x: 20, y: height/2-10, width: width-40, height: 24); emptyLabel.alignment = .center
        layoutMessages()
        if pendingScrollToBottom && height > 200 && history.contentSize.height > 0 {
            history.contentView.scroll(to: NSPoint(x: 0, y: max(0,document.bounds.height-history.contentSize.height)))
            history.reflectScrolledClipView(history.contentView)
            pendingScrollToBottom = false
        }
    }
    private func layoutMessages() {
        let width = history.contentSize.width
        guard width > 0 else { return }
        let top: CGFloat = reference.isHidden && historySearch.isHidden ? 64 : 96
        date.frame = NSRect(x: 0, y: top, width: width, height: 18)
        var y: CGFloat = top+30
        let conversation = inbox.selected
        for (i,item) in messages.enumerated() {
            let h = item.measure(width: width)
            item.frame = NSRect(x: 0, y: y, width: width, height: h)
            let same = conversation.map { i+1 < $0.messages.count && $0.messages[i].outgoing == $0.messages[i+1].outgoing } ?? false
            y += h + (same ? 3 : 10)
        }
        let viewport = history.contentSize.height
        if y+64 < viewport {
            let offset = viewport-y-64
            date.frame.origin.y += offset
            for item in messages { item.frame.origin.y += offset }
        }
        document.setFrameSize(NSSize(width: width, height: max(viewport,y+64)))
    }
    func numberOfRows(in tableView: NSTableView) -> Int { rows.count }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = MessagesConversationCell(frame: NSRect(x: 0, y: 0, width: tableView.bounds.width, height: sidebarRowHeight))
        cell.set(rows[row], selected: rows[row].id == inbox.selectedID); return cell
    }
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard rows.indices.contains(table.selectedRow) else { return }
        let id = rows[table.selectedRow].id
        if inbox.selectedID != id { inbox.select(id); refresh() }
    }
    func controlTextDidChange(_ obj: Notification) {
        if obj.object as? NSSearchField === historySearch {
            for message in messages { message.highlight(historySearch.stringValue) }
            return
        }
        inbox.query = search.stringValue
        if !inbox.visibleConversations.contains(where: { $0.id == inbox.selectedID }), let first = inbox.visibleConversations.first { inbox.select(first.id) }
        refresh()
    }
    func textDidChange(_ notification: Notification) {
        guard !loadingDraft else { return }
        inbox.drafts[inbox.selectedID] = input.string
        placeholder.isHidden = !input.string.isEmpty
        sendButton.isEnabled = !input.string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        sendButton.contentTintColor = sendButton.isEnabled ? InboxStyle.accent : .tertiaryLabelColor
    }
    @objc private func toggleHistorySearch() {
        historySearch.isHidden.toggle()
        if !historySearch.isHidden { view.window?.makeFirstResponder(historySearch) }
        else { historySearch.stringValue = ""; messages.forEach { $0.highlight("") } }
        layoutPanes()
    }
    @objc private func showAttachments() {
        let menu = NSMenu()
        menu.addItem(withTitle: "分享冰岛九日行程 · 公开版", action: #selector(shareSampleDocument), keyEquivalent: "").target = self
        menu.popUp(positioning: nil, at: NSPoint(x: 0, y: 0), in: attachButton)
    }
    @objc private func shareSampleDocument() {
        guard let index = inbox.conversations.firstIndex(where: { $0.id == inbox.selectedID }) else { return }
        inbox.conversations[index].messages.append(InboxMessage(text: "这份是我整理的公开版本。", time: "刚刚", outgoing: true, document: "冰岛九日行程 · 公开版.pdf"))
        inbox.conversations[index].time = "刚刚"
        refresh()
    }
    @objc private func showEmoji() {
        let menu = NSMenu()
        for emoji in ["谢谢！", "收到", "👍", "😊"] {
            let item = menu.addItem(withTitle: emoji, action: #selector(insertEmoji(_:)), keyEquivalent: "")
            item.target = self
        }
        menu.popUp(positioning: nil, at: NSPoint(x: 0,y: 0), in: emojiButton)
    }
    @objc private func insertEmoji(_ sender: NSMenuItem) {
        input.insertText(sender.title, replacementRange: input.selectedRange())
        textDidChange(Notification(name: NSText.didChangeNotification, object: input))
        view.window?.makeFirstResponder(input)
    }
    @objc private func filterTabChanged(_ sender: NSButton) {
        inbox.filter = sidebarTabKinds[sender.tag]
        if !inbox.visibleConversations.contains(where: { $0.id == inbox.selectedID }), let first = inbox.visibleConversations.first { inbox.select(first.id) }
        refresh()
    }
    @objc private func markAllRead() { inbox.markAllRead(); refresh() }
    @objc private func sendMessage() { inbox.send(); loadingDraft = true; input.string = ""; loadingDraft = false; refresh() }
    @objc private func openPost() { if let id = inbox.selected?.postID { onOpenPost?(id) } }
    private func conversationID(for sender: NSMenuItem) -> String? {
        if let id = sender.representedObject as? String { return id }
        let row = table.clickedRow >= 0 ? table.clickedRow : table.selectedRow
        return rows.indices.contains(row) ? rows[row].id : nil
    }
    @objc private func markUnread(_ sender: NSMenuItem) {
        if let id = conversationID(for: sender) { inbox.markUnread(id); refresh() }
    }
    @objc private func toggleMute(_ sender: NSMenuItem) {
        if let id = conversationID(for: sender) { inbox.toggleMuted(id); refresh() }
    }
    @objc private func showOptions() {
        let menu = NSMenu()
        menu.addItem(withTitle: "标为未读", action: #selector(markUnread), keyEquivalent: "").target = self
        menu.addItem(withTitle: inbox.selected?.muted == true ? "取消静音" : "静音此会话", action: #selector(toggleMute), keyEquivalent: "").target = self
        for item in menu.items { item.representedObject = inbox.selectedID }
        menu.popUp(positioning: nil, at: NSPoint(x: 0,y: options.bounds.maxY), in: options)
    }
}
