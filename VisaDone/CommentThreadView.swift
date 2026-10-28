import SwiftUI

// Community reading surface embedded in the existing AppKit split view.
// Messages keep their Telegram implementation; comments have their own hierarchy.
struct CommentThreadView: View {
    @Bindable var inbox: NotificationInbox
    let threadID: String
    var onOpenPost: (String) -> Void
    @State private var replyID: String?
    @State private var liked: Set<String> = []
    @FocusState private var composing: Bool

    private var thread: InboxCommentThread? { inbox.commentThreads[threadID] }
    private var post: DiscoveryPost? { ProfileFixtures.authoredPosts.first { $0.id == thread?.postID } }
    private var replyTarget: InboxComment? { thread?.comments.first { $0.id == replyID } }
    private var draft: Binding<String> {
        Binding(get: { inbox.drafts[threadID] ?? "" }, set: { inbox.drafts[threadID] = $0 })
    }
    var body: some View {
        if let thread {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        postContext(thread)
                        HStack(alignment: .firstTextBaseline) {
                            Text("评论讨论").font(.system(size: 20, weight: .semibold))
                            Text("\(thread.comments.count - 1) 条回复").font(.system(size: 12)).foregroundStyle(.secondary)
                            Spacer()
                            Text("按时间展开").font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(.top, 28).padding(.bottom, 24)
                        ForEach(thread.comments) { comment in
                            commentRow(comment, thread: thread)
                                .id(comment.id)
                        }
                        Color.clear.frame(height: 12).id("thread-end")
                    }
                    .frame(maxWidth: 720)
                    .padding(.horizontal, 32).padding(.top, 24)
                    .frame(maxWidth: .infinity, alignment: .top)
                }
                .scrollEdgeEffectStyle(.soft, for: .bottom)
                .safeAreaInset(edge: .bottom, spacing: 0) { composer(thread) }
                .onChange(of: thread.comments.count) { old, new in
                    if new > old { withAnimation { proxy.scrollTo("thread-end", anchor: .bottom) } }
                }
                .onChange(of: threadID) { _, _ in replyID = nil; liked = []; proxy.scrollTo(thread.root.id, anchor: .top) }
            }
            .background(.clear)
        }
    }

    private func postContext(_ thread: InboxCommentThread) -> some View {
        Button { onOpenPost(thread.postID) } label: {
            HStack(spacing: 14) {
                if let image = post?.coverImage {
                    Image(image).resizable().scaledToFill().frame(width: 72, height: 54)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("讨论来自你的帖子").font(.system(size: 11)).foregroundStyle(.secondary)
                    Text(post?.title ?? "社区讨论").font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.primary).lineLimit(2).multilineTextAlignment(.leading)
                }
                Spacer(minLength: 8)
                Image(systemName: "arrow.up.right").font(.system(size: 12)).foregroundStyle(.secondary)
            }
            .padding(12)
            .background(.primary.opacity(0.035), in: RoundedRectangle(cornerRadius: 10))
            .overlay { RoundedRectangle(cornerRadius: 10).strokeBorder(.separator.opacity(0.45), lineWidth: 0.5) }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .help("打开原帖")
    }

    private func commentRow(_ comment: InboxComment, thread: InboxCommentThread) -> some View {
        let root = comment.parentID == nil
        let depth = thread.depth(of: comment)
        return HStack(alignment: .top, spacing: 12) {
            AuthorAvatarView(author: comment.author, size: root ? 36 : 28)
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 7) {
                    Text(comment.author.name).font(.system(size: 13, weight: .semibold))
                    if comment.author.id == DiscoveryAuthor.you.id {
                        Text("作者").font(.system(size: 10, weight: .medium)).foregroundStyle(.secondary)
                    }
                    if !root, let parent = thread.parent(of: comment), parent.id != thread.root.id {
                        Image(systemName: "arrow.turn.down.right").font(.system(size: 9)).foregroundStyle(.tertiary)
                        Text(parent.author.name).font(.system(size: 11)).foregroundStyle(.secondary)
                    }
                    Spacer(minLength: 4)
                    Text(comment.time).font(.system(size: 11)).foregroundStyle(.secondary)
                }
                Text(comment.text).font(.system(size: root ? 15 : 14))
                    .lineSpacing(5).fixedSize(horizontal: false, vertical: true).textSelection(.enabled)
                HStack(spacing: 20) {
                    Button {
                        replyID = comment.id; composing = true
                    } label: {
                        Label("回复", systemImage: "arrowshape.turn.up.left")
                    }
                    Button {
                        if liked.contains(comment.id) { liked.remove(comment.id) } else { liked.insert(comment.id) }
                    } label: {
                        Label("\(comment.likes + (liked.contains(comment.id) ? 1 : 0))", systemImage: liked.contains(comment.id) ? "heart.fill" : "heart")
                    }
                    .foregroundStyle(liked.contains(comment.id) ? Color.accentColor : .secondary)
                    Spacer()
                }
                .buttonStyle(.plain).font(.system(size: 11)).foregroundStyle(.secondary)
                .padding(.top, 3)
            }
        }
        .padding(.leading, root ? 0 : CGFloat(depth == 1 ? 24 : 56))
        .padding(.bottom, root ? 24 : 22)
        .overlay(alignment: .leading) {
            if !root {
                Rectangle().fill(.separator.opacity(0.6)).frame(width: 1)
                    .padding(.leading, 17).padding(.bottom, 4)
            }
        }
        .padding(.top, root ? 0 : 4)
    }

    private func composer(_ thread: InboxCommentThread) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text("回复").foregroundStyle(.secondary)
                Text(replyTarget?.author.name ?? thread.root.author.name).fontWeight(.medium)
                if let target = replyTarget {
                    Text("·  \(target.text)").lineLimit(1).foregroundStyle(.secondary)
                    Button { replyID = nil } label: { Image(systemName: "xmark.circle.fill") }
                        .buttonStyle(.plain).foregroundStyle(.secondary).help("取消定向回复")
                }
                Spacer(minLength: 0)
            }
            .font(.system(size: 11)).padding(.horizontal, 4)
            HStack(alignment: .center, spacing: 12) {
                AuthorAvatarView(author: .you, size: 28)
                TextField("写下你的回复…", text: draft, axis: .vertical)
                    .textFieldStyle(.plain).font(.system(size: 13)).lineLimit(1...3)
                    .focused($composing)
                Button {
                    inbox.reply(to: replyID ?? thread.root.id, text: draft.wrappedValue)
                    replyID = nil
                } label: {
                    Image(systemName: "arrow.up").font(.system(size: 13, weight: .semibold)).frame(width: 22, height: 22)
                }
                .buttonStyle(.glassProminent).buttonBorderShape(.circle)
                .disabled(draft.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .help("发布回复")
            }
            .padding(10)
            .glassEffect(.regular, in: .rect(cornerRadius: 22))
        }
        .frame(maxWidth: 720)
        .padding(.horizontal, 32).padding(.top, 10).padding(.bottom, 16)
        .frame(maxWidth: .infinity)
    }
}
