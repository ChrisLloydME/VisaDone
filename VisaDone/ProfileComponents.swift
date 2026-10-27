//
//  ProfileComponents.swift
//  VisaDone
//

import AppKit
import SwiftUI

extension PostFormat {
    var profileSymbol: String {
        switch self {
        case .photo: "photo"
        case .question: "questionmark.bubble"
        case .guide: "book.closed"
        }
    }
}

extension DiscoveryPost {
    var profilePreview: String {
        if let summary, !summary.isEmpty { return summary }
        return body.components(separatedBy: "\n\n").first ?? body
    }
}

struct ProfileAvatarView: View {
    let identity: ProfileIdentity
    var size: CGFloat = 112

    var body: some View {
        Image(identity.avatarImage)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())
            .accessibilityLabel("Profile photo of \(identity.displayName)")
    }
}

struct ProfileSectionHeader: View {
    let title: String
    var count: Int?

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .accessibilityAddTraits(.isHeader)
            if let count {
                Text(count.formatted())
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .frame(minHeight: 24)
    }
}

struct ProfileMoreButton: View {
    let help: String
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Text("More")
                Image(systemName: "chevron.right")
                    .font(.system(size: 9, weight: .semibold))
            }
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity)
            .frame(height: 28)
            .modifier(ProfileContentSurface(hovered: isHovering))
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .help(help)
        .accessibilityLabel(help)
    }
}

struct ProfileThumbnail: View {
    let post: DiscoveryPost
    var size = CGSize(width: 88, height: 60)
    var cornerRadius: CGFloat = 5

    var body: some View {
        Group {
            if let image = post.coverImage {
                Image(image).resizable().scaledToFill()
            } else {
                ZStack {
                    Color(nsColor: .quaternaryLabelColor)
                    Image(systemName: post.format.profileSymbol)
                        .font(.system(size: 20))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(width: size.width, height: size.height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .accessibilityHidden(true)
    }
}

// System materials keep the desktop visible while content retains its own layer.
private enum ProfileSurface {
    static let boundary = Color(nsColor: .separatorColor)
    static let secondaryText = Color.primary.opacity(0.80)
}

extension View {
    func profileSectionCard(cornerRadius: CGFloat = 19) -> some View {
        background(.thinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(ProfileSurface.boundary, lineWidth: 0.5)
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

private struct ProfileContentSurface: ViewModifier {
    let hovered: Bool

    func body(content: Content) -> some View {
        content
            .background(hovered ? .thickMaterial : .regularMaterial,
                        in: RoundedRectangle(cornerRadius: 9, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .strokeBorder(ProfileSurface.boundary, lineWidth: 0.5)
            }
            .contentShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
            .animation(.easeOut(duration: 0.12), value: hovered)
    }
}

struct ProfilePostRow: View {
    let post: DiscoveryPost
    let likeCount: Int
    var rowHeight: CGFloat? = nil
    let onOpen: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: onOpen) {
            HStack(alignment: .center, spacing: 12) {
                ProfileThumbnail(post: post)
                VStack(alignment: .leading, spacing: 5) {
                    Text(post.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                    Text(post.profilePreview)
                        .font(.system(size: 12))
                        .foregroundStyle(ProfileSurface.secondaryText)
                        .lineSpacing(1)
                        .lineLimit(1)
                    HStack(spacing: 6) {
                        Text(post.timeLabel)
                        Text("·")
                        if let minutes = post.readMinutes {
                            Text("\(minutes) min read")
                        } else {
                            Text(post.format.cardLabel)
                        }
                        Spacer(minLength: 0)
                        Label(DiscoveryNumberFormat.compact(likeCount), systemImage: "heart")
                    }
                    .font(.system(size: 11))
                    .foregroundStyle(ProfileSurface.secondaryText)
                    .lineLimit(1)
                    .padding(.top, 2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, minHeight: rowHeight, maxHeight: rowHeight, alignment: .leading)
            .modifier(ProfileContentSurface(hovered: isHovering))
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .accessibilityLabel("\(post.title), \(post.timeLabel)")
    }
}

struct ProfileFavoriteRow: View {
    let post: DiscoveryPost
    let onOpen: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: onOpen) {
            HStack(alignment: .center, spacing: 10) {
                ProfileThumbnail(post: post, size: CGSize(width: 64, height: 48), cornerRadius: 4)
                VStack(alignment: .leading, spacing: 5) {
                    Text(post.title)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("\(post.format.cardLabel) · \(post.author.name)")
                        .font(.system(size: 11))
                        .foregroundStyle(ProfileSurface.secondaryText)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "bookmark.fill")
                    .font(.system(size: 10))
                    .foregroundStyle(ProfileSurface.secondaryText)
            }
            .multilineTextAlignment(.leading)
            .padding(10)
            .frame(maxWidth: .infinity, minHeight: 68, maxHeight: 68)
            .modifier(ProfileContentSurface(hovered: isHovering))
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .accessibilityLabel("Saved: \(post.title)")
    }
}

struct ProfileSettingRow: View {
    let setting: ProfileSetting
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: setting.systemImage)
                    .font(.system(size: 14))
                    .foregroundStyle(.primary)
                    .frame(width: 28, height: 28)
                    .background(Color(nsColor: .quaternaryLabelColor),
                                in: RoundedRectangle(cornerRadius: 7))
                Text(setting.title).font(.system(size: 13))
                Spacer(minLength: 4)
                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(ProfileSurface.secondaryText)
            }
            .foregroundStyle(.primary)
            .frame(height: 48)
            .padding(.horizontal, 16)
            .background(isHovering ? Color(nsColor: .quaternaryLabelColor) : .clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
    }
}

// A compact achievement-style record of applications and shared visa stories.
struct ProfileVisaExperiences: View {
    let width: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Visa experiences")
                .font(.system(size: 15, weight: .semibold))
                .accessibilityAddTraits(.isHeader)
            HStack(alignment: .top, spacing: 10) {
                ForEach(ProfileVisaExperience.samples) { experience in
                    VStack(spacing: 7) {
                        Image(experience.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: min(48, (width - 30) / 4), height: min(48, (width - 30) / 4))
                            .clipShape(Circle())
                            .overlay {
                                Circle().strokeBorder(Color(nsColor: .separatorColor), lineWidth: 0.5)
                            }
                        Text(experience.label)
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .help(experience.detail)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(experience.detail)
                }
            }
        }
    }
}

// A static glimpse of the next item, clipped to the remaining space above More.
// The edge softens the content itself; it is not a material or a scroll view.
struct ProfileContinuationPreview<Content: View>: View {
    let rowHeight: CGFloat
    @ViewBuilder let content: () -> Content

    var body: some View {
        GeometryReader { proxy in
            let visibleHeight = min(proxy.size.height, rowHeight - 1)
            ZStack(alignment: .top) {
                content()
                    .frame(width: proxy.size.width, height: rowHeight)
                content()
                    .frame(width: proxy.size.width, height: rowHeight)
                    .blur(radius: 3)
                    .mask(alignment: .top) {
                        LinearGradient(colors: [.clear, .white, .white], startPoint: .top, endPoint: .bottom)
                            .frame(height: visibleHeight)
                    }
            }
            .frame(width: proxy.size.width, height: visibleHeight, alignment: .top)
            .mask {
                LinearGradient(stops: [
                    .init(color: .white, location: 0),
                    .init(color: .white.opacity(0.65), location: 0.35),
                    .init(color: .clear, location: 1)
                ], startPoint: .top, endPoint: .bottom)
            }
            .clipped()
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}
