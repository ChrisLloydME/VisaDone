//
//  ProfileView.swift
//  VisaDone
//

import SwiftUI

struct ProfileView: View {
    @Bindable var model: VisaDoneModel

    @State private var isEditingProfile = false
    @State private var selectedPost: DiscoveryPost?
    @State private var selectedSetting: ProfileSetting?
    @State private var collection: ProfileCollectionKind?

    private var identity: ProfileIdentity { model.profileIdentity }

    private var myPosts: [DiscoveryPost] {
        model.posts.filter { $0.author.id == DiscoveryAuthor.you.id } + ProfileFixtures.authoredPosts
    }

    private var savedPosts: [DiscoveryPost] {
        (model.posts + ProfileFixtures.authoredPosts).filter { model.savedPostIDs.contains($0.id) }
    }

    var body: some View {
        GeometryReader { proxy in
            let width = min(proxy.size.width - 56, 1380)
            let availableHeight = proxy.size.height - 56
            let postCount = max(1, min(myPosts.count, Int((availableHeight - 96) / 102)))
            let favoriteCount = max(1, min(savedPosts.count, Int((availableHeight - 398) / 78)))

            HStack(alignment: .top, spacing: 28) {
                identityColumn(width: min(width * 0.21, 240), height: availableHeight)

                postsColumn(previewCount: postCount)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                VStack(alignment: .leading, spacing: 24) {
                    favoritesSection(previewCount: favoriteCount)
                        .frame(maxHeight: .infinity)
                    settingsSection
                }
                .frame(width: min(width * 0.29, 330), height: availableHeight)
            }
            .frame(width: width, height: availableHeight, alignment: .topLeading)
            .padding(.vertical, 28)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .sheet(item: $selectedPost) { post in
            PostDetailView(post: post, model: model)
        }
        .sheet(isPresented: $isEditingProfile) {
            EditProfileSheet(model: model)
        }
        .sheet(item: $selectedSetting) { setting in
            ProfileSettingsSheet(setting: setting, identity: identity)
        }
        .sheet(item: $collection) { kind in
            ProfileCollectionSheet(kind: kind, model: model)
        }
    }

    private func identityColumn(width: CGFloat, height: CGFloat) -> some View {
        ViewThatFits(in: .vertical) {
            identityContent(width: width, showsExperiences: true)
                .fixedSize(horizontal: false, vertical: true)
            identityContent(width: width, showsExperiences: false)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(width: width, height: height, alignment: .topLeading)
    }

    private func identityContent(width: CGFloat, showsExperiences: Bool) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ProfileAvatarView(identity: identity, size: width)
                .padding(.bottom, 16)

            Text(identity.displayName)
                .font(.system(size: 30, weight: .semibold))
                .fixedSize(horizontal: false, vertical: true)

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(identity.handle)
                if !identity.pronouns.isEmpty {
                    Text("·")
                    Text(identity.pronouns).font(.system(size: 13))
                }
            }
            .font(.system(size: 16))
            .foregroundStyle(.secondary)
            .padding(.top, 4)

            Button {
                isEditingProfile = true
            } label: {
                Text("编辑资料")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .padding(.top, 16)

            Text(identity.bio)
                .font(.system(size: 13))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 16)

            HStack(spacing: 4) {
                Image(systemName: "person.2")
                    .foregroundStyle(.secondary)
                Text("\(Text(identity.followers.formatted()).fontWeight(.semibold)) 粉丝")
                Text("·").foregroundStyle(.secondary)
                Text("\(Text(identity.following.formatted()).fontWeight(.semibold)) 关注")
            }
            .font(.system(size: 12))
            .fixedSize()
            .padding(.top, 14)

            if !identity.location.isEmpty {
                Label(identity.location, systemImage: "mappin.and.ellipse")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .padding(.top, 14)
            }
            if showsExperiences {
                Divider().padding(.top, 20).padding(.bottom, 14)
                ProfileVisaExperiences(width: width)
            }
        }
        .frame(width: width, alignment: .leading)
    }

    private func postsColumn(previewCount: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ProfileSectionHeader(title: "我的收藏", count: myPosts.count)
                .padding(.horizontal, 4)
                .padding(.bottom, 4)
            if myPosts.isEmpty {
                emptyState("还没有发布帖子", detail: "分享一段经历，让准备出发的人少些迷茫。")
            } else {
                ForEach(myPosts.prefix(previewCount)) { post in
                    ProfilePostRow(post: post, likeCount: model.likeCount(for: post), rowHeight: 92) {
                        selectedPost = post
                    }
                }
                if let nextPost = myPosts.dropFirst(previewCount).first {
                    ProfileContinuationPreview(rowHeight: 92) {
                        ProfilePostRow(post: nextPost, likeCount: model.likeCount(for: nextPost), rowHeight: 92) {}
                    }
                } else {
                    Spacer(minLength: 0)
                }
                ProfileMoreButton(help: "查看全部帖子") { collection = .posts }
            }
        }
        .padding(10)
        .profileSectionCard()
    }

    private func favoritesSection(previewCount: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ProfileSectionHeader(title: "我的帖子", count: savedPosts.count)
                .padding(.horizontal, 4)
                .padding(.bottom, 4)
            if savedPosts.isEmpty {
                emptyState("还没有收藏", detail: "在发现页收藏感兴趣的帖子，就能在这里找到。")
            } else {
                ForEach(savedPosts.prefix(previewCount)) { post in
                    ProfileFavoriteRow(post: post) { selectedPost = post }
                }
                if let nextPost = savedPosts.dropFirst(previewCount).first {
                    ProfileContinuationPreview(rowHeight: 68) {
                        ProfileFavoriteRow(post: nextPost) {}
                    }
                } else {
                    Spacer(minLength: 0)
                }
                ProfileMoreButton(help: "查看全部收藏") { collection = .favorites }
            }
        }
        .padding(10)
        .profileSectionCard()
    }

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ProfileSectionHeader(title: "偏好设置")
            VStack(spacing: 0) {
                ForEach(ProfileSetting.allCases) { setting in
                    ProfileSettingRow(setting: setting) { selectedSetting = setting }
                    if setting != ProfileSetting.allCases.last {
                        Divider().padding(.leading, 54)
                    }
                }
            }
            .profileSectionCard(cornerRadius: 14)
        }
    }

    private func emptyState(_ title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).fontWeight(.medium)
            Text(detail).foregroundStyle(.secondary)
        }
        .font(.system(size: 13))
        .padding(.vertical, 18)
    }
}
