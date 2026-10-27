//
//  ProfileSheets.swift
//  VisaDone
//

import SwiftUI

struct EditProfileSheet: View {
    let model: VisaDoneModel
    @Environment(\.dismiss) private var dismiss
    @State private var draft: ProfileIdentity

    init(model: VisaDoneModel) {
        self.model = model
        _draft = State(initialValue: model.profileIdentity)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("编辑资料").font(.title2.weight(.semibold))
            HStack(spacing: 14) {
                ProfileAvatarView(identity: draft, size: 56)
                VStack(alignment: .leading, spacing: 4) {
                    Text(draft.displayName).font(.headline)
                    Text(draft.handle).foregroundStyle(.secondary)
                }
            }
            Form {
                TextField("昵称", text: $draft.displayName)
                    .onChange(of: draft.displayName) { _, value in
                        draft.displayName = String(value.prefix(48))
                    }
                TextField("称谓", text: $draft.pronouns)
                    .onChange(of: draft.pronouns) { _, value in
                        draft.pronouns = String(value.prefix(24))
                    }
                TextField("所在地", text: $draft.location)
                    .onChange(of: draft.location) { _, value in
                        draft.location = String(value.prefix(40))
                    }
                LabeledContent("个人简介") {
                    TextEditor(text: $draft.bio)
                        .font(.body)
                        .frame(height: 90)
                        .border(.separator, width: 0.5)
                        .onChange(of: draft.bio) { _, value in
                            draft.bio = String(value.prefix(180))
                        }
                }
            }
            Text("修改仅保存在本次使用中。")
                .font(.callout)
                .foregroundStyle(.secondary)
            Divider()
            HStack {
                Spacer()
                Button("取消") { dismiss() }.keyboardShortcut(.cancelAction)
                Button("保存") {
                    draft.displayName = draft.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
                    draft.pronouns = draft.pronouns.trimmingCharacters(in: .whitespacesAndNewlines)
                    draft.location = draft.location.trimmingCharacters(in: .whitespacesAndNewlines)
                    draft.bio = draft.bio.trimmingCharacters(in: .whitespacesAndNewlines)
                    model.profileIdentity = draft
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(draft.displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(24)
        .frame(width: 510)
    }
}

struct ProfileSettingsSheet: View {
    let setting: ProfileSetting
    let identity: ProfileIdentity
    @Environment(\.dismiss) private var dismiss
    @State private var publicProfile = true
    @State private var showSaved = false
    @State private var discoverable = true
    @State private var replies = true
    @State private var newFollowers = false
    @State private var weeklyNotes = true
    @State private var personalizedFeed = true
    @State private var anonymousUsage = false

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(setting.title).font(.title2.weight(.semibold))
            Text(setting.sheetSubtitle).foregroundStyle(.secondary)
            Divider()
            Form {
                switch setting {
                case .account:
                    LabeledContent("昵称", value: identity.displayName)
                    LabeledContent("用户名", value: identity.handle)
                    LabeledContent("邮箱", value: "linwan@example.com")
                    LabeledContent("加入时间", value: identity.joinLabel)
                case .privacy:
                    Toggle("公开个人主页", isOn: $publicProfile)
                    Toggle("展示收藏", isOn: $showSaved)
                    Toggle("允许在社区中被发现", isOn: $discoverable)
                case .notifications:
                    Toggle("帖子回复", isOn: $replies)
                    Toggle("新增关注", isOn: $newFollowers)
                    Toggle("每周精选", isOn: $weeklyNotes)
                case .data:
                    Toggle("个性化推荐", isOn: $personalizedFeed)
                    Toggle("匿名使用数据", isOn: $anonymousUsage)
                case .help:
                    VStack(alignment: .leading, spacing: 18) {
                        answer("如何收藏帖子？", "打开帖子，点击收藏按钮，即可在个人主页查看。")
                        answer("资料会同步到哪里？", "当前资料与收藏仅保存在本机，本次退出后不会保留。")
                        answer("可以修改个人资料吗？", "在个人主页选择“编辑资料”，即可修改昵称、所在地和简介。")
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text("偏好仅在当前面板中生效。")
                .font(.callout)
                .foregroundStyle(.secondary)
            Divider()
            HStack {
                Spacer()
                Button("完成") { dismiss() }.keyboardShortcut(.defaultAction)
            }
        }
        .padding(24)
        .frame(width: 480)
    }

    private func answer(_ question: String, _ text: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(question).fontWeight(.medium)
            Text(text).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct ProfileCollectionSheet: View {
    let kind: ProfileCollectionKind
    @Bindable var model: VisaDoneModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPost: DiscoveryPost?

    private var posts: [DiscoveryPost] {
        let candidates = model.posts + ProfileFixtures.authoredPosts
        switch kind {
        case .posts:
            return candidates.filter { $0.author.id == DiscoveryAuthor.you.id }
        case .favorites:
            return candidates.filter { model.savedPostIDs.contains($0.id) }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(kind.title).font(.title2.weight(.semibold))
            Text(kind.subtitle).foregroundStyle(.secondary)
            Divider()
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(posts) { post in
                        ProfilePostRow(post: post, likeCount: model.likeCount(for: post)) {
                            selectedPost = post
                        }
                    }
                    if posts.isEmpty {
                        ContentUnavailableView("这里暂时没有内容", systemImage: kind.systemImage)
                    }
                }
                .padding(1)
            }
            Divider()
            HStack {
                Text("共 \(posts.count) 篇帖子").foregroundStyle(.secondary)
                Spacer()
                Button("完成") { dismiss() }.keyboardShortcut(.cancelAction)
            }
        }
        .padding(24)
        .frame(width: 680, height: 620)
        .sheet(item: $selectedPost) { post in
            PostDetailView(post: post, model: model)
        }
    }
}
