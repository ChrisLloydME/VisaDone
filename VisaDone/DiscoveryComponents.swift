//
//  DiscoveryComponents.swift
//  VisaDone
//

import SwiftUI

// MARK: - Author avatar

struct AuthorAvatarView: View {
    let author: DiscoveryAuthor
    var size: CGFloat = 24

    var body: some View {
        ZStack {
            if author.id == DiscoveryAuthor.you.id {
                Image("profileAvatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .saturation(0.92)
            } else {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: author.palette.colors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Text(author.initials)
                    .font(.system(size: size * 0.35, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.14), radius: 0.5, y: 0.5)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay {
            Circle()
                .strokeBorder(.white.opacity(0.28), lineWidth: 0.7)
        }
        .accessibilityHidden(true)
    }
}

// MARK: - Category filters

struct DiscoveryCategoryBar: View {
    @Binding var selection: DiscoveryCategory

    var body: some View {
        HStack(spacing: 6) {
            ForEach(DiscoveryCategory.allCases) { category in
                DiscoveryCategoryChip(
                    category: category,
                    isSelected: category == selection
                ) {
                    selection = category
                }
            }
        }
    }
}

private struct DiscoveryCategoryChip: View {
    let category: DiscoveryCategory
    let isSelected: Bool
    let action: () -> Void

    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            Text(category.title)
                .font(.system(size: 12, weight: isSelected ? .semibold : .medium))
                .foregroundStyle(isSelected ? DiscoveryTheme.onBrand : (isHovering ? .primary : .secondary))
                .padding(.horizontal, 11.5)
                .frame(height: 28)
                .background {
                    Capsule(style: .continuous)
                        .fill(
                            isSelected
                                ? DiscoveryTheme.brandStrong
                                : (isHovering ? DiscoveryTheme.hoverFill : .clear)
                        )
                }
                .overlay {
                    Capsule(style: .continuous)
                        .strokeBorder(
                            isSelected ? .clear : (isHovering ? DiscoveryTheme.brand.opacity(0.18) : DiscoveryTheme.hairline),
                            lineWidth: 1
                        )
                }
                .contentShape(Capsule(style: .continuous))
        }
        .buttonStyle(SoftPressButtonStyle())
        .onHover { isHovering = $0 }
        .animation(.easeOut(duration: 0.14), value: isHovering)
        .animation(.easeOut(duration: 0.16), value: isSelected)
        .help(category.helpText)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Card actions

struct PostActionButton: View {
    let symbol: String
    let activeSymbol: String
    let isActive: Bool
    let count: Int?
    let activeColor: Color
    let label: String
    let action: () -> Void

    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: isActive ? activeSymbol : symbol)
                    .font(.system(size: 11.5, weight: .medium))
                    .contentTransition(.symbolEffect(.replace))

                if let count {
                    Text(DiscoveryNumberFormat.compact(count))
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .monospacedDigit()
                        .contentTransition(.numericText())
                }
            }
            .foregroundStyle(isActive ? activeColor : Color.secondary)
            .padding(.horizontal, 7)
            .frame(height: 24)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(isHovering ? DiscoveryTheme.hoverFill : .clear)
            }
            .contentShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
        }
        .buttonStyle(SoftPressButtonStyle())
        .onHover { isHovering = $0 }
        .animation(.easeOut(duration: 0.14), value: isHovering)
        .help(label)
        .accessibilityLabel(label)
    }
}

struct PostTagView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 11))
            .foregroundStyle(.secondary)
            .lineLimit(1)
    }
}

// MARK: - Formatting

enum DiscoveryNumberFormat {
    static func compact(_ value: Int) -> String {
        guard value >= 1_000 else { return "\(value)" }

        let thousands = Double(value) / 1_000
        if thousands >= 10 {
            return "\(Int(thousands.rounded()))k"
        }

        let formatted = String(format: "%.1f", thousands)
        return formatted.hasSuffix(".0")
            ? "\(formatted.dropLast(2))k"
            : "\(formatted)k"
    }

    static func storyCount(_ count: Int) -> String {
        count == 1 ? "1 story" : "\(count) stories"
    }

    static func resultCount(_ count: Int) -> String {
        count == 1 ? "1 result" : "\(count) results"
    }
}

// MARK: - Button feedback

/// A light pressed treatment for controls that already have their own hover state.
struct SoftPressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.68 : 1)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.09), value: configuration.isPressed)
    }
}

struct DiscoveryCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.92 : 1)
            .scaleEffect(configuration.isPressed ? 0.996 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}
