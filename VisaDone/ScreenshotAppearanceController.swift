import AppKit
import SwiftUI

// A separate utility panel keeps screenshot controls out of the product window.
@Observable final class ScreenshotAppearanceController {
    static let shared=ScreenshotAppearanceController()
    enum Mode:String,CaseIterable,Identifiable {
        case system="跟随系统",light="浅色",dark="深色"
        var id:String {rawValue}
        var colorScheme:ColorScheme? {
            switch self {case .system:nil;case .light:.light;case .dark:.dark}
        }
        var appearance:NSAppearance? {
            switch self {case .system:nil;case .light:NSAppearance(named:.aqua);case .dark:NSAppearance(named:.darkAqua)}
        }
    }
    var mode:Mode = .system {
        didSet {NSApp.appearance=mode.appearance}
    }
    @ObservationIgnored private var panel:NSPanel?
    @ObservationIgnored private var presentedAtLaunch=false

    func showAtLaunch() {
        guard !presentedAtLaunch else {return}
        presentedAtLaunch=true
        DispatchQueue.main.async {self.show()}
    }
    func show() {
        if let panel {
            panel.orderFront(nil)
            return
        }
        let panel=NSPanel(contentRect:NSRect(x:0,y:0,width:320,height:126),
            styleMask:[.titled,.closable,.utilityWindow,.nonactivatingPanel],backing:.buffered,defer:false)
        panel.title="截图外观"
        panel.isReleasedWhenClosed=false
        panel.isFloatingPanel=true
        panel.becomesKeyOnlyIfNeeded=true
        panel.hidesOnDeactivate=true
        panel.collectionBehavior=[.fullScreenAuxiliary]
        panel.contentView=NSHostingView(rootView:ScreenshotAppearancePanel(controller:self))
        if let screen=(NSApp.mainWindow?.screen ?? NSScreen.main)?.visibleFrame {
            panel.setFrameTopLeftPoint(NSPoint(x:screen.maxX-panel.frame.width-20,y:screen.maxY-28))
        } else {panel.center()}
        self.panel=panel
        panel.orderFront(nil)
    }
    func close() {panel?.close()}
}

private struct ScreenshotAppearancePanel:View {
    @Bindable var controller:ScreenshotAppearanceController
    var body:some View {
        VStack(alignment:.leading,spacing:14) {
            Picker("VisaDone 外观",selection:$controller.mode) {
                ForEach(ScreenshotAppearanceController.Mode.allCases) {mode in Text(mode.rawValue).tag(mode)}
            }.pickerStyle(.segmented).labelsHidden()
            Text("即时切换应用外观，关闭小窗后仍保持选择。")
                .font(.caption).foregroundStyle(.secondary)
        }
        .padding(18).frame(width:320,height:126,alignment:.center)
        .environment(\.locale,Locale(identifier:"zh_Hans_CN"))
    }
}
