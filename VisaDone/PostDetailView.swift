//
//  PostDetailView.swift
//  VisaDone
//

import SwiftUI

struct PostDetailView: View {
    let post: DiscoveryPost
    @Bindable var model: VisaDoneModel
    @Environment(\.dismiss) private var dismiss
    @State private var imageIndex = 0

    private var images: [String] { PostDetailFixtures.images(for: post) }

    var body: some View {
        HStack(spacing: 0) {
            if !images.isEmpty {
                gallery
                Divider()
            }

            VStack(spacing: 0) {
                authorHeader
                Divider()
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 18) {
                        title
                        bodyText
                        tags
                        metadata
                        disclaimer
                        Divider().padding(.vertical, 4)
                        replies
                    }
                    .padding(28)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .scrollIndicators(.automatic)
                .scrollEdgeEffectStyle(.soft, for: [.top, .bottom])
                actionBar
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: images.isEmpty ? 720 : 1120, height: 760)
        .background(.regularMaterial)
    }

    // MARK: - Fixed image stage

    private var gallery: some View {
        ZStack {
            Color(nsColor: .underPageBackgroundColor)
            Image(images[imageIndex])
                .resizable()
                .interpolation(.high)
                .scaledToFit()
                .frame(width: 570, height: 760)
                .id(imageIndex)
                .accessibilityLabel("Photo \(imageIndex + 1) of \(images.count) for \(post.title)")
        }
        .frame(width: 570, height: 760)
        .clipped()
        .overlay(alignment: .topTrailing) {
            if images.count > 1 {
                Text("\(imageIndex + 1) / \(images.count)")
                    .font(.system(size: 12, weight: .medium))
                    .monospacedDigit()
                    .padding(.horizontal, 11)
                    .padding(.vertical, 7)
                    .background(.regularMaterial, in: Capsule())
                    .padding(18)
            }
        }
        .overlay {
            if images.count > 1 {
                HStack {
                    galleryArrow("chevron.left", label: "Previous photo", disabled: imageIndex == 0) {
                        imageIndex -= 1
                    }
                    Spacer()
                    galleryArrow("chevron.right", label: "Next photo", disabled: imageIndex == images.count - 1) {
                        imageIndex += 1
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .overlay(alignment: .bottom) {
            if images.count > 1 {
                HStack(spacing: 8) {
                    ForEach(images.indices, id: \.self) { index in
                        Button {
                            imageIndex = index
                        } label: {
                            Circle()
                                .fill(index == imageIndex ? Color.primary : Color.secondary.opacity(0.4))
                                .frame(width: 6, height: 6)
                                .padding(3)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Show photo \(index + 1)")
                        .accessibilityAddTraits(index == imageIndex ? .isSelected : [])
                    }
                }
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .background(.regularMaterial, in: Capsule())
                .padding(.bottom, 18)
            }
        }
    }

    private func galleryArrow(_ symbol: String, label: String, disabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 28, height: 28)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        .controlSize(.large)
        .disabled(disabled)
        .opacity(disabled ? 0.35 : 1)
        .help(label)
        .accessibilityLabel(label)
    }

    // MARK: - Author and reading column

    private var authorHeader: some View {
        HStack(spacing: 11) {
            AuthorAvatarView(author: post.author, size: 38)
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(post.author.name)
                        .font(.system(size: 14, weight: .semibold))
                    if post.author.isFollowing {
                        Text("Following").font(.system(size: 11)).foregroundStyle(.secondary)
                    }
                }
                Text(post.author.handle)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .medium))
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
            .controlSize(.large)
            .keyboardShortcut(.cancelAction)
            .help("Close post")
            .accessibilityLabel("Close post")
        }
        .padding(.horizontal, 26)
        .padding(.vertical, 20)
    }

    private var title: some View {
        Text(post.title)
            .font(.system(size: 25, weight: .semibold, design: .serif))
            .lineSpacing(3)
            .fixedSize(horizontal: false, vertical: true)
            .textSelection(.enabled)
    }

    private var bodyText: some View {
        Text(post.body)
            .font(.system(size: 14))
            .lineSpacing(6)
            .fixedSize(horizontal: false, vertical: true)
            .textSelection(.enabled)
    }

    @ViewBuilder
    private var tags: some View {
        if !post.tags.isEmpty {
            Text(post.tags.map { "#" + $0.replacingOccurrences(of: " ", with: "") }.joined(separator: "  "))
                .font(.system(size: 13))
                .foregroundStyle(Color.accentColor)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var metadata: some View {
        HStack(spacing: 6) {
            Text(post.timeLabel)
            Text("·")
            Text(post.region.title)
            if let minutes = post.readMinutes {
                Text("·")
                Text("\(minutes) min read")
            }
        }
        .font(.system(size: 12))
        .foregroundStyle(.secondary)
    }

    private var disclaimer: some View {
        Text("Personal experience, not official guidance. Check current requirements with the relevant embassy or visa service.")
            .font(.system(size: 11))
            .foregroundStyle(.secondary)
            .lineSpacing(2)
            .fixedSize(horizontal: false, vertical: true)
    }

    // MARK: - Recent conversation

    private var replies: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("Replies · \(post.commentCount)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.secondary)
            if post.commentCount == 0 {
                Text("No replies yet.")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            } else {
                ForEach(PostDetailFixtures.replies(for: post)) { reply in
                    HStack(alignment: .top, spacing: 10) {
                        AuthorAvatarView(author: reply.author, size: 29)
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(reply.author.name).fontWeight(.medium)
                                Spacer()
                                Text(reply.time).foregroundStyle(.secondary)
                            }
                            .font(.system(size: 11.5))
                            Text(reply.text)
                                .font(.system(size: 13))
                                .lineSpacing(3)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Existing post actions

    private var actionBar: some View {
        HStack(spacing: 8) {
            detailLikeButton
            detailSaveButton
            Spacer(minLength: 4)
            Label("\(post.commentCount)", systemImage: "bubble.right")
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .help("\(post.commentCount) replies")
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 18)
        .background(.bar)
        .overlay(alignment: .top) { Divider() }
    }

    private var detailLikeButton: some View {
        let liked = model.isLiked(post)
        let count = model.likeCount(for: post)

        return Button {
            withAnimation(.snappy(duration: 0.22)) {
                model.toggleLike(post)
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: liked ? "heart.fill" : "heart")
                    .contentTransition(.symbolEffect(.replace))
                    .symbolEffect(.bounce, value: liked)

                Text(liked ? "Liked" : "Like")

                Text(DiscoveryNumberFormat.compact(count))
                    .font(.system(size: 11.5, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
                    .contentTransition(.numericText())
            }
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(liked ? DiscoveryTheme.liked : .primary)
            .padding(.horizontal, 11)
            .frame(height: 28)
            .background {
                Capsule(style: .continuous)
                    .fill(liked ? DiscoveryTheme.liked.opacity(0.10) : DiscoveryTheme.surface)
            }
            .overlay {
                Capsule(style: .continuous)
                    .strokeBorder(
                        liked ? DiscoveryTheme.liked.opacity(0.26) : DiscoveryTheme.hairline,
                        lineWidth: 1
                    )
            }
            .contentShape(Capsule(style: .continuous))
        }
        .buttonStyle(SoftPressButtonStyle())
        .help(liked ? "Unlike this story" : "Like this story")
    }

    private var detailSaveButton: some View {
        let saved = model.isSaved(post)

        return Button {
            withAnimation(.snappy(duration: 0.22)) {
                model.toggleSaved(post)
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: saved ? "bookmark.fill" : "bookmark")
                    .contentTransition(.symbolEffect(.replace))
                    .symbolEffect(.bounce, value: saved)

                Text(saved ? "Saved" : "Save")
            }
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(saved ? DiscoveryTheme.brandStrong : .primary)
            .padding(.horizontal, 11)
            .frame(height: 28)
            .background {
                Capsule(style: .continuous)
                    .fill(saved ? DiscoveryTheme.brand.opacity(0.10) : DiscoveryTheme.surface)
            }
            .overlay {
                Capsule(style: .continuous)
                    .strokeBorder(
                        saved ? DiscoveryTheme.brand.opacity(0.26) : DiscoveryTheme.hairline,
                        lineWidth: 1
                    )
            }
            .contentShape(Capsule(style: .continuous))
        }
        .buttonStyle(SoftPressButtonStyle())
        .help(saved ? "Remove from saved" : "Save this story")
    }
}

private struct PostDetailReply: Identifiable {
    let id: Int
    let author: DiscoveryAuthor
    let time: String
    let text: String
}

private enum PostDetailFixtures {
    static func images(for post: DiscoveryPost) -> [String] {
        guard let cover = post.coverImage else { return [] }
        let groups = [
            ["coverIcelandSkogafoss", "coverIcelandVestrahorn", "coverIcelandGlacier", "coverIcelandKirkjufell"],
            ["coverLondonPiccadilly", "coverLondonWestminster", "coverLondonAerial"],
            ["coverNYCEmpire", "coverNYCBrooklyn", "coverNYCStreet"],
            ["coverTravelDesk", "coverNotes", "coverSigning", "coverLaptopNotes"],
            ["coverParisEiffel", "coverParisPont"],
            ["coverSantorini", "coverAirplaneWing"],
            ["coverCotswolds", "coverEdinburgh"]
        ]
        guard let group = groups.first(where: { $0.contains(cover) }) else { return [cover] }
        return [cover] + group.filter { $0 != cover }.prefix(2)
    }

    static func replies(for post: DiscoveryPost) -> [PostDetailReply] {
        let documentImages = ["coverTravelDesk", "coverNotes", "coverSigning", "coverLaptopNotes"]
        let texts: [String]
        if post.format == .question {
            texts = [
                "I had a similar question before my appointment. The checklist from the application centre was the most useful place to start.",
                "Which office are you applying through? My experience was a little different, so it may help to compare the same location."
            ]
        } else if documentImages.contains(post.coverImage ?? "") {
            texts = [
                "The one-page index is such a good idea. I kept a printed copy at the front and the same order in my PDF folder.",
                "I did something similar with booking confirmations. Having the dates visible together made the final check much easier."
            ]
        } else {
            texts = [
                "Saved this for our next trip. Leaving a little room in the itinerary for weather changes sounds very sensible.",
                "I like seeing the practical details alongside the photos. The slower days are usually the ones I remember best."
            ]
        }
        let authors = [DiscoveryAuthor.daniel, DiscoveryAuthor.mira]
        return Array(texts.prefix(min(post.commentCount, 2))).enumerated().map { index, text in
            PostDetailReply(id: index, author: authors[index], time: index == 0 ? "2h ago" : "5h ago", text: text)
        }
    }
}

#Preview("Story detail") {
    PostDetailView(post: DiscoveryFixtures.posts[0], model: VisaDoneModel())
}
