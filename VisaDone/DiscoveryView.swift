//
//  DiscoveryView.swift
//  VisaDone
//

import SwiftUI
import SwiftUIMasonry

struct DiscoveryView: View {
    @Bindable var model: VisaDoneModel
    @State private var selectedPost: DiscoveryPost?

    private var posts: [DiscoveryPost] {
        model.filteredPosts
    }

    private var trimmedQuery: String {
        model.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            Rectangle()
                .fill(DiscoveryTheme.hairline.opacity(0.65))
                .frame(height: 1)
            feed
        }
        .background(pageBackground)
        .sheet(item: $selectedPost) { post in
            PostDetailView(post: post, model: model)
        }
    }

    // MARK: - Page header

    private var header: some View {
        VStack(spacing: 17) {
            HStack(alignment: .bottom, spacing: 28) {
                VStack(alignment: .leading, spacing: 7) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(DiscoveryTheme.brandStrong)
                            .frame(width: 5, height: 5)

                        Text("VISADONE COMMUNITY")
                            .font(DiscoveryTheme.eyebrow)
                            .tracking(1.25)
                            .foregroundStyle(DiscoveryTheme.brandStrong)
                    }

                    Text("Discover")
                        .font(DiscoveryTheme.pageTitle)
                        .tracking(-0.4)
                        .foregroundStyle(.primary)

                    Text("Field notes and honest questions from people navigating the visa journey.")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 20)

                DiscoverySearchField(text: $model.searchText)
                    .frame(width: 282)
                    .padding(.bottom, 2)
            }

            HStack(spacing: 16) {
                DiscoveryCategoryBar(selection: $model.selectedCategory)

                Spacer(minLength: 12)

                Text(resultSummary)
                    .font(.system(size: 11.5))
                    .foregroundStyle(.tertiary)
                    .contentTransition(.numericText())
                    .lineLimit(1)
                    .padding(.trailing, 1)
            }
        }
        .padding(.horizontal, DiscoveryTheme.pageInset)
        .padding(.top, 22)
        .padding(.bottom, 15)
        .frame(maxWidth: DiscoveryTheme.contentMaxWidth, alignment: .leading)
        .frame(maxWidth: .infinity)
    }

    private var resultSummary: String {
        if !trimmedQuery.isEmpty {
            return posts.isEmpty ? "No results" : DiscoveryNumberFormat.resultCount(posts.count)
        }
        return DiscoveryNumberFormat.storyCount(posts.count)
    }

    // MARK: - Feed

    private var feed: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: 0)
                        .id("feedTop")

                    if posts.isEmpty {
                        emptyState
                    } else {
                        VMasonry(
                            columns: .adaptive(minWidth: DiscoveryTheme.masonryMinColumnWidth),
                            horizontalSpacing: DiscoveryTheme.cardSpacing,
                            verticalSpacing: DiscoveryTheme.cardSpacing,
                            placementMode: .fill
                        ) {
                            ForEach(posts) { post in
                                DiscoveryPostCard(
                                    post: post,
                                    likeCount: model.likeCount(for: post),
                                    isLiked: model.isLiked(post),
                                    isSaved: model.isSaved(post),
                                    onOpen: { selectedPost = post },
                                    onToggleLike: { model.toggleLike(post) },
                                    onToggleSave: { model.toggleSaved(post) }
                                )
                                .id(post.id)
                            }
                        }
                        .padding(.horizontal, DiscoveryTheme.pageInset)
                        .padding(.top, 20)
                        .padding(.bottom, 4)
                        .frame(maxWidth: DiscoveryTheme.contentMaxWidth, alignment: .leading)
                        .frame(maxWidth: .infinity)

                        feedFooter
                    }
                }
            }
            .scrollIndicators(.automatic)
            .onChange(of: model.selectedCategory) { _, _ in
                scrollToTop(proxy: proxy, animated: true)
            }
            .onChange(of: model.searchText) { _, _ in
                scrollToTop(proxy: proxy, animated: false)
            }
            .onChange(of: posts.first?.id) { oldValue, newValue in
                guard oldValue != newValue else { return }
                scrollToTop(proxy: proxy, animated: true)
            }
        }
    }

    private func scrollToTop(proxy: ScrollViewProxy, animated: Bool) {
        if animated {
            withAnimation(.easeOut(duration: 0.2)) {
                proxy.scrollTo("feedTop", anchor: .top)
            }
        } else {
            proxy.scrollTo("feedTop", anchor: .top)
        }
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 13) {
            ZStack {
                Circle()
                    .fill(DiscoveryTheme.surface)
                    .frame(width: 58, height: 58)
                    .overlay {
                        Circle()
                            .strokeBorder(DiscoveryTheme.hairline, lineWidth: 1)
                    }

                Image(systemName: trimmedQuery.isEmpty ? "rectangle.stack" : "magnifyingglass")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(DiscoveryTheme.brandStrong)
            }

            Text(trimmedQuery.isEmpty ? "Nothing here yet" : "No stories found")
                .font(.system(size: 22, weight: .semibold, design: .serif))

            Text(emptyStateMessage)
                .font(.system(size: 12.5))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .frame(maxWidth: 360)

            HStack(spacing: 8) {
                Button(trimmedQuery.isEmpty ? "Explore For You" : "Clear search") {
                    withAnimation(.easeOut(duration: 0.16)) {
                        if trimmedQuery.isEmpty {
                            model.selectedCategory = .forYou
                        } else {
                            model.searchText = ""
                        }
                    }
                }
                .buttonStyle(.bordered)
                .controlSize(.regular)

                if !trimmedQuery.isEmpty && model.selectedCategory != .forYou {
                    Button("Search all topics") {
                        withAnimation(.easeOut(duration: 0.16)) {
                            model.selectedCategory = .forYou
                        }
                    }
                    .buttonStyle(.borderless)
                    .foregroundStyle(DiscoveryTheme.brandStrong)
                }
            }
            .padding(.top, 3)
        }
        .padding(.vertical, 110)
        .frame(maxWidth: .infinity)
    }

    private var emptyStateMessage: String {
        if trimmedQuery.isEmpty {
            return "This corner of the community is quiet for now. Try another filter or browse everything."
        }
        return "Nothing in \(model.selectedCategory.title) matched “\(trimmedQuery)”. Try a broader phrase, or search across every topic."
    }

    // MARK: - Footer

    private var feedFooter: some View {
        VStack(spacing: 9) {
            Capsule(style: .continuous)
                .fill(DiscoveryTheme.hairline)
                .frame(width: 40, height: 2)

            Text("You're all caught up")
                .font(.system(size: 11.5, weight: .semibold))
                .foregroundStyle(.secondary)

            Text("VisaDone is a local community prototype. Stories are personal experiences, not official immigration advice — always confirm current requirements with the relevant official source.")
                .font(.system(size: 11))
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
                .lineSpacing(1.5)
                .frame(maxWidth: 470)

            Text("Photography from Unsplash. Edinburgh by Mike McBey (CC BY 2.0); Castle Combe by Michael Garlick (CC BY-SA 2.0), via Wikimedia Commons.")
                .font(.system(size: 10))
                .foregroundStyle(.quaternary)
                .multilineTextAlignment(.center)
                .lineSpacing(1)
                .frame(maxWidth: 470)
                .padding(.top, 2)
        }
        .padding(.top, 36)
        .padding(.horizontal, DiscoveryTheme.pageInset)
        .padding(.bottom, 38)
        .frame(maxWidth: DiscoveryTheme.contentMaxWidth)
    }

    // MARK: - Background

    private var pageBackground: some View {
        ZStack(alignment: .top) {
            DiscoveryTheme.canvas

            LinearGradient(
                colors: [
                    DiscoveryTheme.brand.opacity(0.045),
                    DiscoveryTheme.brand.opacity(0.012),
                    .clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 280)
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

#Preview("Discovery") {
    DiscoveryView(model: VisaDoneModel())
        .frame(width: 1280, height: 840)
}
