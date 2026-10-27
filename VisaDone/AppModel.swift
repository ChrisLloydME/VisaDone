//
//  AppModel.swift
//  VisaDone
//

import SwiftUI

enum AppSection: String, CaseIterable, Identifiable {
    case discovery
    case application
    case profile

    var id: String { rawValue }

    var title: String {
        switch self {
        case .discovery: "Discovery"
        case .application: "Application"
        case .profile: "Profile"
        }
    }

    var keyboardShortcut: KeyEquivalent {
        switch self {
        case .discovery: "1"
        case .application: "2"
        case .profile: "3"
        }
    }
}

/// Local-only state for the prototype. Nothing leaves the app.
@Observable
final class VisaDoneModel {
    var section: AppSection = .discovery
    var isComposing = false
    var posts: [DiscoveryPost] = DiscoveryFixtures.posts
    var likedPostIDs: Set<DiscoveryPost.ID> = []
    var savedPostIDs: Set<DiscoveryPost.ID> = []
    var selectedCategory: DiscoveryCategory = .forYou
    var searchText = ""

    var filteredPosts: [DiscoveryPost] {
        let categoryMatches: (DiscoveryPost) -> Bool = { post in
            switch self.selectedCategory {
            case .forYou: true
            case .following: post.author.isFollowing
            case .schengen: post.region == .schengen
            case .unitedStates: post.region == .unitedStates
            case .unitedKingdom: post.region == .unitedKingdom
            case .experiences: post.isExperience
            }
        }

        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        return posts.filter { post in
            guard categoryMatches(post) else { return false }
            guard !query.isEmpty else { return true }

            let searchableText = [
                post.title,
                post.summary ?? "",
                post.body,
                post.author.name,
                post.author.handle,
                post.region.title,
                post.format.title,
                post.tags.joined(separator: " ")
            ].joined(separator: " ")

            return searchableText.localizedStandardContains(query)
        }
    }

    func isLiked(_ post: DiscoveryPost) -> Bool {
        likedPostIDs.contains(post.id)
    }

    func isSaved(_ post: DiscoveryPost) -> Bool {
        savedPostIDs.contains(post.id)
    }

    func likeCount(for post: DiscoveryPost) -> Int {
        post.likeCount + (isLiked(post) ? 1 : 0)
    }

    func toggleLike(_ post: DiscoveryPost) {
        if likedPostIDs.contains(post.id) {
            likedPostIDs.remove(post.id)
        } else {
            likedPostIDs.insert(post.id)
        }
    }

    func toggleSaved(_ post: DiscoveryPost) {
        if savedPostIDs.contains(post.id) {
            savedPostIDs.remove(post.id)
        } else {
            savedPostIDs.insert(post.id)
        }
    }

    func addPost(title: String, body: String, region: PostRegion) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBody = body.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        let post = DiscoveryPost(
            id: "local-\(UUID().uuidString)",
            format: .question,
            region: region,
            title: trimmedTitle,
            summary: nil,
            body: trimmedBody.isEmpty
                ? "A new question shared with the VisaDone community."
                : trimmedBody,
            coverImage: nil,
            coverAspectRatio: nil,
            tags: [],
            author: .you,
            timeLabel: "Just now",
            likeCount: 0,
            commentCount: 0,
            readMinutes: nil,
            isExperience: false
        )

        posts.insert(post, at: 0)
        selectedCategory = .forYou
        searchText = ""
    }
}
