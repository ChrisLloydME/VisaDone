import AppKit
import SwiftUI

// SwiftUI only hosts the native AppKit page and the app's existing detail sheets.
struct NotificationsView: View {
    @Bindable var model: VisaDoneModel
    @State private var presentedPost: DiscoveryPost?
    @State private var documentPreview = false
    private var inbox: NotificationInbox { model.inbox }

    var body: some View {
        NativeNotificationCenter(
            inbox: inbox,
            revision: inbox.conversations.map { "\($0.id):\($0.unread):\($0.muted):\($0.messages.count)" }.joined() + inbox.selectedID + inbox.filter.rawValue + inbox.query,
            onOpenPost: { id in
                presentedPost = ProfileFixtures.authoredPosts.first { $0.id == id } ?? model.posts.first { $0.id == id }
            },
            onOpenAttachment: { documentPreview = true }
        )
        .sheet(item: $presentedPost) { PostDetailView(post: $0, model: model) }
        .sheet(isPresented: $documentPreview) {
            VStack(spacing: 16) {
                HStack {
                    Text("冰岛九日行程 · 公开版").font(.headline)
                    Spacer()
                    Button("完成") { documentPreview = false }.keyboardShortcut(.cancelAction)
                }
                Image("visaIcelandItinerary").resizable().scaledToFit()
                Text("已隐藏姓名、预订编号与具体出行日期").font(.caption).foregroundStyle(.secondary)
            }.padding(24).frame(width: 570, height: 730)
        }
    }
}

private struct NativeNotificationCenter: NSViewControllerRepresentable {
    let inbox: NotificationInbox
    let revision: String
    let onOpenPost: (String) -> Void
    let onOpenAttachment: () -> Void
    func makeNSViewController(context: Context) -> NativeNotificationController {
        let controller = NativeNotificationController(inbox: inbox)
        controller.onOpenPost = onOpenPost
        controller.onOpenAttachment = onOpenAttachment
        return controller
    }
    func updateNSViewController(_ controller: NativeNotificationController, context: Context) {
        controller.onOpenPost = onOpenPost
        controller.onOpenAttachment = onOpenAttachment
        controller.refresh()
    }
}
