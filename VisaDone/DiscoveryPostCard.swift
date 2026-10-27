//
//  DiscoveryPostCard.swift
//  VisaDone
//

import SwiftUI

struct DiscoveryPostCard: View {
    let post: DiscoveryPost
    let likeCount: Int
    let isLiked: Bool
    let isSaved: Bool
    let onOpen: () -> Void
    let onToggleLike: () -> Void
    let onToggleSave: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovering = false

    var body: some View {
        VStack(spacing: 0) {
            Button(action: onOpen) {
                mainContent
            }
            .buttonStyle(DiscoveryCardButtonStyle())
            .accessibilityLabel(accessibilitySummary)
            .accessibilityHint("Opens the full story")

            Rectangle()
                .fill(DiscoveryTheme.hairline.opacity(0.55))
                .frame(height: 1)

            footer
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: DiscoveryTheme.cardRadius, style: .continuous)
                .fill(.regularMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: DiscoveryTheme.cardRadius, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: DiscoveryTheme.cardRadius, style: .continuous)
                .strokeBorder(
                    isHovering ? DiscoveryTheme.brand.opacity(0.30) : DiscoveryTheme.hairline,
                    lineWidth: 1
                )
        }
        .shadow(
            color: .black.opacity(isHovering ? (colorScheme == .dark ? 0.34 : 0.11) : (colorScheme == .dark ? 0.14 : 0.035)),
            radius: isHovering ? 16 : 2,
            x: 0,
            y: isHovering ? 7 : 1
        )
        .offset(y: isHovering && !reduceMotion ? -2 : 0)
        .onHover { hovering in
            isHovering = hovering
        }
        .animation(reduceMotion ? nil : .easeOut(duration: 0.16), value: isHovering)
    }

    // MARK: - Main content

    private var mainContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let coverImage = post.coverImage, let aspect = post.coverAspectRatio {
                cover(imageName: coverImage, aspect: aspect)
            }

            VStack(alignment: .leading, spacing: 9) {
                metadataRow
                title
                summary

                if !post.tags.isEmpty {
                    HStack(spacing: 5) {
                        ForEach(post.tags.prefix(2), id: \.self) { tag in
                            PostTagView(text: tag)
                        }
                    }
                    .padding(.top, 1)
                }

                authorRow
                    .padding(.top, 2)
            }
            .padding(.horizontal, hasCover ? 15 : 17)
            .padding(.top, hasCover ? 13 : 16)
            .padding(.bottom, hasCover ? 14 : 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(alignment: .topTrailing) {
                if !hasCover {
                    LinearGradient(
                        colors: [
                            post.region.accent.opacity(post.format == .guide ? 0.10 : 0.075),
                            .clear
                        ],
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }

    private var hasCover: Bool {
        post.coverImage != nil && post.coverAspectRatio != nil
    }

    private func cover(imageName: String, aspect: CGFloat) -> some View {
        Color.clear
            .aspectRatio(aspect, contentMode: .fit)
            .overlay {
                Image(imageName)
                    .resizable()
                    .interpolation(.high)
                    .scaledToFill()
            }
            .clipped()
            .overlay(alignment: .topTrailing) {
                if isHovering {
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 9.5, weight: .semibold))
                        .foregroundStyle(.primary)
                        .frame(width: 25, height: 25)
                        .background(.ultraThinMaterial, in: Circle())
                        .overlay {
                            Circle()
                                .strokeBorder(.white.opacity(0.28), lineWidth: 0.7)
                        }
                        .shadow(color: .black.opacity(0.12), radius: 4, y: 1)
                        .padding(10)
                        .transition(.opacity.combined(with: .scale(scale: 0.86)))
                }
            }
            .accessibilityHidden(true)
    }

    private var metadataRow: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(post.region.accent)
                .frame(width: 5, height: 5)

            Text(post.region.shortTitle.uppercased())
                .foregroundStyle(post.region.accent)

            Text("·")
                .foregroundStyle(.quaternary)

            Text(post.format.cardLabel.uppercased())
                .foregroundStyle(.secondary)

            Spacer(minLength: 8)

            Text(post.timeLabel)
                .foregroundStyle(.secondary)
        }
        .font(.system(size: 9.5, weight: .semibold))
        .tracking(0.65)
        .lineLimit(1)
        .minimumScaleFactor(0.9)
    }

    private var title: some View {
        Text(post.title)
            .font(titleFont)
            .foregroundStyle(.primary)
            .lineSpacing(post.format == .photo ? 1.5 : 2)
            .lineLimit(post.format == .question ? 5 : 4)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
    }

    private var titleFont: Font {
        switch post.format {
        case .photo:
            .system(size: 16, weight: .semibold, design: .serif)
        case .guide:
            .system(size: 19.5, weight: .semibold, design: .serif)
        case .question:
            .system(size: 19, weight: .medium, design: .serif)
        }
    }

    @ViewBuilder
    private var summary: some View {
        if let summary = post.summary, !summary.isEmpty {
            Text(summary)
                .font(.system(size: 12.5))
                .foregroundStyle(.secondary)
                .lineSpacing(2.5)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var authorRow: some View {
        HStack(spacing: 7) {
            AuthorAvatarView(author: post.author, size: 21)

            Text(post.author.name)
                .font(.system(size: 11.5, weight: .medium))
                .foregroundStyle(.primary)
                .lineLimit(1)

            Spacer(minLength: 6)

            if let readMinutes = post.readMinutes {
                HStack(spacing: 3) {
                    Image(systemName: "clock")
                        .font(.system(size: 9.5, weight: .medium))
                    Text("\(readMinutes) min read")
                }
                .font(.system(size: 10.5))
                .foregroundStyle(.secondary)
                .lineLimit(1)
            }
        }
    }

    // MARK: - Footer

    private var footer: some View {
        HStack(spacing: 4) {
            PostActionButton(
                symbol: "heart",
                activeSymbol: "heart.fill",
                isActive: isLiked,
                count: likeCount,
                activeColor: DiscoveryTheme.liked,
                label: isLiked ? "Unlike this story" : "Like this story",
                action: {
                    withAnimation(.snappy(duration: 0.22)) {
                        onToggleLike()
                    }
                }
            )

            PostActionButton(
                symbol: "bookmark",
                activeSymbol: "bookmark.fill",
                isActive: isSaved,
                count: nil,
                activeColor: DiscoveryTheme.brandStrong,
                label: isSaved ? "Remove from saved" : "Save this story",
                action: {
                    withAnimation(.snappy(duration: 0.22)) {
                        onToggleSave()
                    }
                }
            )

            Spacer(minLength: 4)

            if post.commentCount > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "bubble.right")
                        .font(.system(size: 10, weight: .medium))
                    Text(DiscoveryNumberFormat.compact(post.commentCount))
                        .font(.system(size: 10.5, weight: .medium, design: .rounded))
                        .monospacedDigit()
                }
                .foregroundStyle(.secondary)
                .padding(.trailing, 4)
                .help("\(post.commentCount) replies in this discussion")
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(post.commentCount) replies")
            }
        }
        .padding(.horizontal, 8)
        .frame(height: 38)
        .background(DiscoveryTheme.surfaceMuted)
    }

    private var accessibilitySummary: String {
        "\(post.format.eyebrow): \(post.title). By \(post.author.name). \(likeCount) likes, \(post.commentCount) replies."
    }
}

// MARK: - Preview

#Preview("Discovery cards") {

    return HStack(alignment: .top, spacing: 18) {
        DiscoveryPostCard(
            post: DiscoveryFixtures.posts[0],
            likeCount: DiscoveryFixtures.posts[0].likeCount,
            isLiked: false,
            isSaved: true,
            onOpen: {},
            onToggleLike: {},
            onToggleSave: {}
        )

        DiscoveryPostCard(
            post: DiscoveryFixtures.posts[2],
            likeCount: DiscoveryFixtures.posts[2].likeCount,
            isLiked: true,
            isSaved: false,
            onOpen: {},
            onToggleLike: {},
            onToggleSave: {}
        )

        DiscoveryPostCard(
            post: DiscoveryFixtures.posts[1],
            likeCount: DiscoveryFixtures.posts[1].likeCount,
            isLiked: false,
            isSaved: false,
            onOpen: {},
            onToggleLike: {},
            onToggleSave: {}
        )
    }
    .padding(28)
    .frame(width: 1000)
    .background(DiscoveryTheme.canvas)
}
