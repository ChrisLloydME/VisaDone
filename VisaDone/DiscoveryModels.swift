//
//  DiscoveryModels.swift
//  VisaDone
//

import SwiftUI

enum DiscoveryCategory: String, CaseIterable, Identifiable {
    case forYou = "为你推荐"
    case following = "关注动态"
    case schengen = "申根专区"
    case unitedStates = "美国专区"
    case unitedKingdom = "英国专区"
    case experiences = "申请经验"

    var id: String { rawValue }
    var title: String { rawValue }

    var helpText: String {
        switch self {
        case .forYou: "浏览推荐帖子"
        case .following: "查看已关注作者的帖子"
        case .schengen: "查看申根相关帖子"
        case .unitedStates: "查看美国相关帖子"
        case .unitedKingdom: "查看英国相关帖子"
        case .experiences: "查看申请经历与准备攻略"
        }
    }
}

enum PostRegion: String, CaseIterable, Hashable {
    case schengen
    case unitedStates
    case unitedKingdom

    var title: String {
        switch self {
        case .schengen: "申根"
        case .unitedStates: "美国"
        case .unitedKingdom: "英国"
        }
    }

    var shortTitle: String {
        switch self {
        case .schengen: "申根"
        case .unitedStates: "美国"
        case .unitedKingdom: "英国"
        }
    }

    var accent: Color {
        switch self {
        case .schengen: DiscoveryTheme.schengen
        case .unitedStates: DiscoveryTheme.unitedStates
        case .unitedKingdom: DiscoveryTheme.unitedKingdom
        }
    }
}

enum PostFormat: String, CaseIterable, Hashable {
    case photo
    case question
    case guide

    var title: String {
        switch self {
        case .photo: "图文分享"
        case .question: "提问"
        case .guide: "攻略"
        }
    }

    var eyebrow: String {
        switch self {
        case .photo: "图文分享"
        case .question: "提问"
        case .guide: "攻略"
        }
    }

    /// A compact label that keeps the card's metadata line comfortable at
    /// every supported column width.
    var cardLabel: String {
        switch self {
        case .photo: "分享"
        case .question: "提问"
        case .guide: "攻略"
        }
    }
}

struct DiscoveryAuthor: Identifiable, Hashable {
    let id: String
    let name: String
    let handle: String
    let initials: String
    let palette: AvatarPalette
    let bio: String
    let isFollowing: Bool

    var avatarImage: String { "avatar_\(id)" }

    static func == (lhs: DiscoveryAuthor, rhs: DiscoveryAuthor) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum AvatarPalette: String, CaseIterable, Hashable {
    case tide
    case clay
    case indigo
    case moss
    case amber
    case plum
    case slate
    case rose

    var colors: [Color] {
        switch self {
        case .tide: [Color(red: 0.13, green: 0.43, blue: 0.42), Color(red: 0.31, green: 0.66, blue: 0.60)]
        case .clay: [Color(red: 0.53, green: 0.28, blue: 0.20), Color(red: 0.79, green: 0.48, blue: 0.34)]
        case .indigo: [Color(red: 0.24, green: 0.29, blue: 0.52), Color(red: 0.47, green: 0.52, blue: 0.77)]
        case .moss: [Color(red: 0.27, green: 0.38, blue: 0.24), Color(red: 0.54, green: 0.66, blue: 0.42)]
        case .amber: [Color(red: 0.57, green: 0.39, blue: 0.16), Color(red: 0.82, green: 0.64, blue: 0.35)]
        case .plum: [Color(red: 0.40, green: 0.24, blue: 0.36), Color(red: 0.67, green: 0.45, blue: 0.59)]
        case .slate: [Color(red: 0.25, green: 0.32, blue: 0.37), Color(red: 0.48, green: 0.57, blue: 0.62)]
        case .rose: [Color(red: 0.56, green: 0.26, blue: 0.32), Color(red: 0.80, green: 0.47, blue: 0.49)]
        }
    }
}

struct DiscoveryPost: Identifiable, Hashable {
    let id: String
    let format: PostFormat
    let region: PostRegion
    let title: String
    let summary: String?
    let body: String
    let coverImage: String?
    let coverAspectRatio: CGFloat?
    let tags: [String]
    let author: DiscoveryAuthor
    let timeLabel: String
    let likeCount: Int
    let commentCount: Int
    let readMinutes: Int?
    let isExperience: Bool

    init(
        id: String,
        format: PostFormat,
        region: PostRegion,
        title: String,
        summary: String? = nil,
        body: String,
        coverImage: String? = nil,
        coverAspectRatio: CGFloat? = nil,
        tags: [String] = [],
        author: DiscoveryAuthor,
        timeLabel: String,
        likeCount: Int,
        commentCount: Int = 0,
        readMinutes: Int? = nil,
        isExperience: Bool = false
    ) {
        self.id = id
        self.format = format
        self.region = region
        self.title = title
        self.summary = summary
        self.body = body
        self.coverImage = coverImage
        self.coverAspectRatio = coverAspectRatio
        self.tags = tags
        self.author = author
        self.timeLabel = timeLabel
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.readMinutes = readMinutes
        self.isExperience = isExperience
    }
}
