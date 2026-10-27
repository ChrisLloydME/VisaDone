//
//  PostDetailView.swift
//  VisaDone
//

import SwiftUI

struct PostDetailView: View {
    let post: DiscoveryPost
    @Bindable var model: VisaDoneModel
    @Environment(\.dismiss) private var dismiss

    private var hasCover: Bool {
        post.coverImage != nil
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    if let coverImage = post.coverImage {
                        hero(imageName: coverImage)
                    }

                    VStack(alignment: .leading, spacing: 18) {
                        metadataRow
                        title
                        summary
                        authorBlock

                        Rectangle()
                            .fill(DiscoveryTheme.hairline)
                            .frame(height: 1)

                        bodyText
                        tags
                        disclaimer
                    }
                    .padding(.horizontal, 36)
                    .padding(.top, hasCover ? 26 : 34)
                    .padding(.bottom, 34)
                    .frame(maxWidth: 740, alignment: .leading)
                    .frame(maxWidth: .infinity)
                }
            }
            .scrollIndicators(.automatic)

            actionBar
        }
        .frame(width: 720, height: 640)
        .background(DiscoveryTheme.canvas)
    }

    // MARK: - Hero

    private func hero(imageName: String) -> some View {
        Color.clear
            .frame(height: 246)
            .overlay {
                Image(imageName)
                    .resizable()
                    .interpolation(.high)
                    .scaledToFill()
            }
            .clipped()
            .overlay(alignment: .bottom) {
                LinearGradient(
                    colors: [.clear, Color.black.opacity(0.16)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .frame(height: 90)
                .allowsHitTesting(false)
            }
            .accessibilityHidden(true)
    }

    // MARK: - Content

    private var metadataRow: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(post.region.accent)
                .frame(width: 6, height: 6)

            Text(post.region.title.uppercased())
                .foregroundStyle(post.region.accent)

            Text("·")
                .foregroundStyle(.quaternary)

            Text(post.format.eyebrow.uppercased())
                .foregroundStyle(.secondary)

            Spacer(minLength: 10)

            Text(post.timeLabel)
                .foregroundStyle(.tertiary)
        }
        .font(.system(size: 10, weight: .semibold))
        .tracking(0.85)
        .lineLimit(1)
    }

    private var title: some View {
        Text(post.title)
            .font(.system(size: 31, weight: .semibold, design: .serif))
            .tracking(-0.25)
            .lineSpacing(2)
            .fixedSize(horizontal: false, vertical: true)
            .textSelection(.enabled)
    }

    @ViewBuilder
    private var summary: some View {
        if let summary = post.summary, !summary.isEmpty {
            Text(summary)
                .font(.system(size: 14.5))
                .foregroundStyle(.secondary)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
                .textSelection(.enabled)
        }
    }

    private var authorBlock: some View {
        HStack(alignment: .top, spacing: 10) {
            AuthorAvatarView(author: post.author, size: 36)
                .padding(.top, 1)

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(post.author.name)
                        .font(.system(size: 12.5, weight: .semibold))

                    if post.author.isFollowing {
                        Text("Following")
                            .font(.system(size: 9.5, weight: .medium))
                            .foregroundStyle(.tertiary)
                            .padding(.horizontal, 5)
                            .frame(height: 16)
                            .background {
                                Capsule(style: .continuous)
                                    .fill(DiscoveryTheme.quietFill)
                            }
                    }
                }

                Text(post.author.handle)
                    .font(.system(size: 10.5))
                    .foregroundStyle(.tertiary)

                Text(post.author.bio)
                    .font(.system(size: 11.5))
                    .foregroundStyle(.secondary)
                    .lineSpacing(1.5)
                    .lineLimit(2)
                    .padding(.top, 1)
            }

            Spacer(minLength: 12)

            if let readMinutes = post.readMinutes {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 9.5, weight: .medium))
                    Text("\(readMinutes) min read")
                }
                .font(.system(size: 10.5))
                .foregroundStyle(.tertiary)
                .padding(.top, 2)
            }
        }
    }

    private var bodyText: some View {
        Text(post.body)
            .font(.system(size: 14.5))
            .lineSpacing(5)
            .foregroundStyle(.primary)
            .fixedSize(horizontal: false, vertical: true)
            .textSelection(.enabled)
    }

    @ViewBuilder
    private var tags: some View {
        if !post.tags.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("FILED UNDER")
                    .font(.system(size: 9.5, weight: .semibold))
                    .tracking(0.9)
                    .foregroundStyle(.tertiary)

                HStack(spacing: 6) {
                    ForEach(post.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 9)
                            .frame(height: 23)
                            .background {
                                Capsule(style: .continuous)
                                    .fill(DiscoveryTheme.quietFill)
                            }
                            .overlay {
                                Capsule(style: .continuous)
                                    .strokeBorder(DiscoveryTheme.hairline.opacity(0.65), lineWidth: 0.6)
                            }
                    }
                }
            }
        }
    }

    private var disclaimer: some View {
        HStack(alignment: .top, spacing: 9) {
            Image(systemName: "info.circle")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(DiscoveryTheme.brandStrong)
                .padding(.top, 1)

            VStack(alignment: .leading, spacing: 3) {
                Text("Community story, not official advice")
                    .font(.system(size: 11.5, weight: .semibold))
                    .foregroundStyle(.secondary)

                Text("Experiences vary by nationality, route, and office. Check current requirements with the relevant embassy, consulate, or official visa service.")
                    .font(.system(size: 11))
                    .foregroundStyle(.tertiary)
                    .lineSpacing(1.5)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(DiscoveryTheme.surfaceMuted)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(DiscoveryTheme.hairline.opacity(0.7), lineWidth: 1)
        }
        .padding(.top, 4)
    }

    // MARK: - Action bar

    private var actionBar: some View {
        HStack(spacing: 8) {
            detailLikeButton
            detailSaveButton

            Spacer(minLength: 8)

            if post.commentCount > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "bubble.right")
                    Text("\(post.commentCount) replies")
                }
                .font(.system(size: 10.5))
                .foregroundStyle(.tertiary)
                .padding(.trailing, 6)
            }

            Button("Done") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .keyboardShortcut(.cancelAction)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 11)
        .background(.bar)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(DiscoveryTheme.hairline.opacity(0.7))
                .frame(height: 1)
        }
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

#Preview("Story detail") {
    PostDetailView(post: DiscoveryFixtures.posts[1], model: VisaDoneModel())
}
