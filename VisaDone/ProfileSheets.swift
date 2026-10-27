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
            Text("Edit Profile").font(.title2.weight(.semibold))
            HStack(spacing: 14) {
                ProfileAvatarView(identity: draft, size: 56)
                VStack(alignment: .leading, spacing: 4) {
                    Text(draft.displayName).font(.headline)
                    Text(draft.handle).foregroundStyle(.secondary)
                }
            }
            Form {
                TextField("Display name", text: $draft.displayName)
                    .onChange(of: draft.displayName) { _, value in
                        draft.displayName = String(value.prefix(48))
                    }
                TextField("Pronouns", text: $draft.pronouns)
                    .onChange(of: draft.pronouns) { _, value in
                        draft.pronouns = String(value.prefix(24))
                    }
                TextField("Location", text: $draft.location)
                    .onChange(of: draft.location) { _, value in
                        draft.location = String(value.prefix(40))
                    }
                LabeledContent("Bio") {
                    TextEditor(text: $draft.bio)
                        .font(.body)
                        .frame(height: 90)
                        .border(.separator, width: 0.5)
                        .onChange(of: draft.bio) { _, value in
                            draft.bio = String(value.prefix(180))
                        }
                }
            }
            Text("Changes stay in this app session.")
                .font(.callout)
                .foregroundStyle(.secondary)
            Divider()
            HStack {
                Spacer()
                Button("Cancel") { dismiss() }.keyboardShortcut(.cancelAction)
                Button("Save Changes") {
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
                    LabeledContent("Display name", value: identity.displayName)
                    LabeledContent("Username", value: identity.handle)
                    LabeledContent("Email", value: "nora.hale@visadone.demo")
                    LabeledContent("Member since", value: identity.joinLabel)
                case .privacy:
                    Toggle("Public profile", isOn: $publicProfile)
                    Toggle("Show saved stories", isOn: $showSaved)
                    Toggle("Discoverable in community", isOn: $discoverable)
                case .notifications:
                    Toggle("Replies to my posts", isOn: $replies)
                    Toggle("New followers", isOn: $newFollowers)
                    Toggle("Weekly field notes", isOn: $weeklyNotes)
                case .data:
                    Toggle("Personalize Discovery", isOn: $personalizedFeed)
                    Toggle("Anonymous usage", isOn: $anonymousUsage)
                case .help:
                    VStack(alignment: .leading, spacing: 18) {
                        answer("How do I save something?", "Open a post and choose the bookmark button. Saved posts appear in Favorites.")
                        answer("Where does my data go?", "VisaDone is a local prototype. Profile details and saved posts stay in this app session.")
                        answer("Can I change my profile?", "Choose Edit Profile on your profile page to update your name, pronouns, location, and bio.")
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text("Demo settings · Changes preview locally in this panel.")
                .font(.callout)
                .foregroundStyle(.secondary)
            Divider()
            HStack {
                Spacer()
                Button("Done") { dismiss() }.keyboardShortcut(.defaultAction)
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
                        ContentUnavailableView("Nothing here yet", systemImage: kind.systemImage)
                    }
                }
                .padding(1)
            }
            Divider()
            HStack {
                Text("\(posts.count) posts").foregroundStyle(.secondary)
                Spacer()
                Button("Done") { dismiss() }.keyboardShortcut(.cancelAction)
            }
        }
        .padding(24)
        .frame(width: 680, height: 620)
        .sheet(item: $selectedPost) { post in
            PostDetailView(post: post, model: model)
        }
    }
}
