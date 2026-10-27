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
        feed
        .overlay(alignment: .bottomTrailing) {
            composeButton
                .padding(28)
        }
        .sheet(item: $selectedPost) { post in
            PostDetailView(post: post, model: model)
        }
    }

    private var composeButton: some View {
        Button {
            model.isComposing = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(.primary)
                .frame(width: 44, height: 44)
        }
        .buttonStyle(.glass(.regular.tint(Color.accentColor.opacity(0.55)).interactive()))
        .buttonBorderShape(.circle)
        .controlSize(.large)
        .help("发布帖子（⌘N）")
        .accessibilityLabel("发布帖子")
    }

    // MARK: - Page header

    private var header: some View {
        VStack(spacing: 17) {
            HStack(alignment: .bottom, spacing: 28) {
                VStack(alignment: .leading, spacing: 7) {
                    Text("社区发现")
                        .font(DiscoveryTheme.pageTitle)
                        .foregroundStyle(.primary)
                        .accessibilityAddTraits(.isHeader)

                    Text("从准备签证到出发，看看大家怎么做。")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 20)
            }

            HStack(spacing: 16) {
                DiscoveryCategoryBar(selection: $model.selectedCategory)

                Spacer(minLength: 12)


            }
        }
        .padding(.horizontal, DiscoveryTheme.pageInset)
        .padding(.top, 22)
        .padding(.bottom, 15)
        .frame(maxWidth: DiscoveryTheme.contentMaxWidth, alignment: .leading)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Feed

    private var feed: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: 0)
                        .id("feedTop")

                    header

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
            .scrollEdgeEffectStyle(.soft, for: .top)
            .scrollEdgeEffectHidden(false, for: .top)
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
            Image(systemName: trimmedQuery.isEmpty ? "rectangle.stack" : "magnifyingglass")
                .font(.system(size: 24))
                .foregroundStyle(.secondary)
                .padding(.bottom, 4)

            Text(trimmedQuery.isEmpty ? "这里还没有帖子" : "没有找到相关帖子")
                .font(.system(size: 19, weight: .semibold))

            Text(emptyStateMessage)
                .font(.system(size: 12.5))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .frame(maxWidth: 360)

            HStack(spacing: 8) {
                Button(trimmedQuery.isEmpty ? "看看推荐" : "清除搜索") {
                    if trimmedQuery.isEmpty {
                        model.selectedCategory = .forYou
                    } else {
                        model.searchText = ""
                    }
                }
                .buttonStyle(.bordered)
                .controlSize(.regular)

                if !trimmedQuery.isEmpty && model.selectedCategory != .forYou {
                    Button("搜索全部分类") {
                        model.selectedCategory = .forYou
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
            return "换个分类，看看大家最近的分享。"
        }
        return "“\(trimmedQuery)”在\(model.selectedCategory.title)中暂无结果。换个关键词，或试试其他分类。"
    }

    // MARK: - Footer

    private var feedFooter: some View {
        VStack(spacing: 8) {
            Text("已经看到这里了")
                .font(.system(size: 12, weight: .medium))
            Text("社区内容为个人经历，具体要求请以使领馆或官方签证中心为准。")
                .font(.system(size: 11))
                .frame(maxWidth: 500)
            Text("图片来自 Unsplash。爱丁堡：Mike McBey（CC BY 2.0）；库姆堡：Michael Garlick（CC BY-SA 2.0），来源为维基共享资源。")
                .font(.system(size: 11))
                .frame(maxWidth: 500)
        }
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
        .lineSpacing(2)
        .padding(.horizontal, DiscoveryTheme.pageInset)
        .padding(.vertical, 30)
        .frame(maxWidth: DiscoveryTheme.contentMaxWidth)
    }

}

#Preview("发现") {
    DiscoveryView(model: VisaDoneModel())
        .frame(width: 1280, height: 840)
}
