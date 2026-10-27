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
                .accessibilityLabel("\(post.title)，第 \(imageIndex + 1) 张，共 \(images.count) 张")
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
                    galleryArrow("chevron.left", label: "上一张", disabled: imageIndex == 0) {
                        imageIndex -= 1
                    }
                    Spacer()
                    galleryArrow("chevron.right", label: "下一张", disabled: imageIndex == images.count - 1) {
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
                        .accessibilityLabel("查看第 \(index + 1) 张图片")
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
                        Text("已关注").font(.system(size: 11)).foregroundStyle(.secondary)
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
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
            .controlSize(.large)
            .keyboardShortcut(.cancelAction)
            .help("关闭帖子")
            .accessibilityLabel("关闭帖子")
        }
        .padding(.horizontal, 26)
        .padding(.vertical, 20)
    }

    private var title: some View {
        Text(post.title)
            .font(.custom("STSongti-SC-Bold", size: 26))
            .lineSpacing(3)
            .fixedSize(horizontal: false, vertical: true)
            .textSelection(.enabled)
    }

    private var bodyText: some View {
        Text(post.body)
            .font(.system(size: 15))
            .lineSpacing(7)
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
                Text("\(minutes) 分钟阅读")
            }
        }
        .font(.system(size: 12))
        .foregroundStyle(.secondary)
    }

    private var disclaimer: some View {
        Text("仅为个人经历，具体要求请以使领馆或官方签证中心为准。")
            .font(.system(size: 11))
            .foregroundStyle(.secondary)
            .lineSpacing(2)
            .fixedSize(horizontal: false, vertical: true)
    }

    // MARK: - Recent conversation

    private var replies: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("评论 · \(post.commentCount)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.secondary)
            if post.commentCount == 0 {
                Text("还没有评论，期待第一条分享。")
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
                .help("\(post.commentCount) 条评论")
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

                Text(liked ? "已赞" : "点赞")

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
        .help(liked ? "取消点赞" : "点赞")
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

                Text(saved ? "已收藏" : "收藏")
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
        .help(saved ? "取消收藏" : "收藏")
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
        let attachments: [String: [String]] = [
            "iceland-nine-days": ["visaAccommodationCheck", "visaDocumentChecklist"],
            "kirkjufell-morning": ["visaIcelandItinerary", "visaItineraryReview"],
            "new-york-finally": ["visaProcessingTimeline"],
            "uk-folder-worked": ["visaDocumentChecklist"],
            "document-organisation": ["visaDocumentChecklist"],
            "us-road-trip": ["visaItineraryReview"],
            "honeymoon-timeline": ["visaProcessingComparison"],
            "edinburgh-weather": ["visaProcessingTimeline"],
            "first-flight-after-approval": ["visaProcessingComparison"]
        ]
        if let pages = attachments[post.id] { return [cover] + pages }
        if cover == "visaAccommodationCheck" { return [cover, "visaDocumentChecklist"] }
        if cover == "visaIcelandItinerary" { return [cover, "visaItineraryReview"] }
        if cover.hasPrefix("visa") { return [cover] }
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
        let texts: [String]
        if post.id == "iceland-nine-days" {
            texts = [
                "我在另一个城市递交时没有被要求补这一项。建议把地点、递交时间和同行条件一起记下来，才方便判断是否适用。",
                "已收藏。官方说明和个人补件经历分开写，更容易知道哪些是需要自己再核对的。"
            ]
        } else if post.tags.contains(where: { $0.contains("进度") || $0.contains("状态") || $0.contains("结果") }) {
            texts = [
                "谢谢补充完整节点。我会先对照签证类别和递交地点，不把单个案例的天数当成自己的预计结果。",
                "把收到通知和签收护照分开记录很有帮助。也希望之前没更新的朋友有空补一下后续，不用贴任何申请编号。"
            ]
        } else if post.tags.contains(where: { $0.contains("行程") || $0.contains("改稿") || $0.contains("交通") || $0.contains("审阅") }) {
            texts = [
                "可以先把交通和过夜地点列在一起，再看活动要不要删。转城当天少放一项，会更容易检查衔接。",
                "建议把已经核实的安排和待确认的部分标开。AI 给出的时间先当检查线索，再去核对对应来源。"
            ]
        } else if post.format == .question {
            texts = [
                "先把国籍、申请类别和递交地点说明白，大家更容易判断经验能否参考。不需要公开证件或订单原件。",
                "我会先看当前官方说明，再把看不懂的具体段落单独拿出来讨论。不同个人条件，准备方式也可能不一样。"
            ]
        } else {
            texts = [
                "这个核对思路很实用。我也把官方要求、社区提醒和自己的准备状态分开记录，避免混成一份清单。",
                "可以把暂时无法判断的字段留在待确认项里，回到原件核对后再标记完成，不必为了全勾上而跳过问题。"
            ]
        }
        let authors = [DiscoveryAuthor.daniel, DiscoveryAuthor.mira]
        return Array(texts.prefix(min(post.commentCount, 2))).enumerated().map { index, text in
            PostDetailReply(id: index, author: authors[index], time: index == 0 ? "2 小时前" : "5 小时前", text: text)
        }
    }
}

#Preview("Story detail") {
    PostDetailView(post: DiscoveryFixtures.posts[0], model: VisaDoneModel())
}
