//
//  ProfileModels.swift
//  VisaDone
//

import SwiftUI

struct ProfileIdentity: Equatable {
    var displayName: String
    var handle: String
    var pronouns: String
    var bio: String
    var location: String
    var joinLabel: String
    var followers: Int
    var following: Int
    var avatarImage: String

    static let fixture = ProfileIdentity(
        displayName: "林晚",
        handle: "@林晚在路上",
        pronouns: "她",
        bio: "设计师，慢旅行爱好者。\n把签证材料理清楚，再慢慢去看世界。",
        location: "杭州",
        joinLabel: "2023 年",
        followers: 2_846,
        following: 212,
        avatarImage: "avatar_you"
    )

    var handleLine: String {
        "\(handle) · \(pronouns)"
    }
}

enum ProfileSetting: String, CaseIterable, Identifiable {
    case account
    case privacy
    case notifications
    case data
    case help

    var id: String { rawValue }

    var title: String {
        switch self {
        case .account: "账号设置"
        case .privacy: "隐私设置"
        case .notifications: "消息通知"
        case .data: "数据共享"
        case .help: "帮助支持"
        }
    }

    var subtitle: String {
        switch self {
        case .account: "昵称、账号与资料"
        case .privacy: "个人主页可见范围"
        case .notifications: "回复与关注动态"
        case .data: "数据与使用偏好"
        case .help: "常见问题与使用说明"
        }
    }

    var systemImage: String {
        switch self {
        case .account: "person.crop.circle"
        case .privacy: "lock.shield"
        case .notifications: "bell.badge"
        case .data: "externaldrive.badge.icloud"
        case .help: "questionmark.circle"
        }
    }

    var sheetSubtitle: String {
        switch self {
        case .account: "管理个人资料与账号信息。"
        case .privacy: "选择希望展示给社区的内容。"
        case .notifications: "只接收你关心的消息。"
        case .data: "管理推荐与数据偏好。"
        case .help: "关于资料、收藏和社区使用的常见问题。"
        }
    }
}

enum ProfileCollectionKind: String, Identifiable {
    case posts
    case favorites

    var id: String { rawValue }

    var title: String {
        switch self {
        case .posts: "全部帖子"
        case .favorites: "全部收藏"
        }
    }

    var subtitle: String {
        switch self {
        case .posts: "记录每一次准备和出发。"
        case .favorites: "把值得再看的攻略与经历留在这里。"
        }
    }

    var systemImage: String {
        switch self {
        case .posts: "square.text.square"
        case .favorites: "bookmark"
        }
    }
}

enum ProfileFixtures {
    static let initialFavoriteIDs: Set<String> = [
        "uk-folder-worked",
        "document-organisation",
        "honeymoon-timeline",
        "us-road-trip",
        "uk-visitor-differently",
        "appointment-prep-guide"
    ]

    static let savedLabels: [String: String] = [
        "uk-folder-worked": "2 天前收藏",
        "document-organisation": "4 天前收藏",
        "honeymoon-timeline": "1 周前收藏",
        "us-road-trip": "2 周前收藏",
        "uk-visitor-differently": "3 周前收藏",
        "appointment-prep-guide": "1 个月前收藏"
    ]

    static let authoredPosts: [DiscoveryPost] = [
        DiscoveryPost(
            id: "profile-schengen-folder",
            format: .guide,
            region: .schengen,
            title: "申根材料，终于整理顺了",
            summary: "一张目录、六组文件，把临行前的慌乱留在家里。",
            body: """
            第一次准备材料时，我把能找到的文件都堆在一起。后来按身份、行程、资金和工作分类，才发现真正缺的是一张能快速定位的目录。

            现在每份文件都写清日期和用途，纸质版与电子版保持同一顺序。递签前只需按清单核对，不必再把整包材料倒出来。

            这是我的整理办法。每次申请仍会重新确认当前要求，不直接照搬旧清单。
            """,
            coverImage: "coverTravelDesk",
            coverAspectRatio: 0.8,
            tags: ["材料整理", "申根"],
            author: .you,
            timeLabel: "4月8日",
            likeCount: 428,
            commentCount: 36,
            readMinutes: 6,
            isExperience: true
        ),
        DiscoveryPost(
            id: "profile-vfs-appointment",
            format: .guide,
            region: .schengen,
            title: "递签当天，比想象中平静",
            summary: "从出门到离开，把我记得的几个小细节写下来。",
            body: """
            出发前把证件和预约信息单独收好，路上没有再反复翻材料。到了现场，按工作人员的指引一步步办理，节奏比想象中清楚。

            我多带的一份订单复印件刚好派上用场。离开后去吃了一顿迟到的午饭，才发现最紧张的是来之前的那段等待。
            """,
            coverImage: "coverSigning",
            coverAspectRatio: 1.25,
            tags: ["递签", "亲历记录"],
            author: .you,
            timeLabel: "4月2日",
            likeCount: 312,
            commentCount: 29,
            readMinutes: 5,
            isExperience: true
        ),
        DiscoveryPost(
            id: "profile-iceland-itinerary",
            format: .guide,
            region: .schengen,
            title: "冰岛九天，愿意再走一遍的路线",
            summary: "三个落脚点、两天机动，不用每天清晨赶路。",
            body: """
            南岸的路线看起来不长，但天气和路边的风景会让人不断停下来。我们把九天分成三段，每处多住一晚，不把时间全用在收拾行李上。

            机动日留给大风和临时起意的小路。住宿和租车订单放在同一个离线文件夹里，路上少了一件需要操心的事。
            """,
            coverImage: "coverIcelandSkogafoss",
            coverAspectRatio: 1.5,
            tags: ["冰岛", "行程安排"],
            author: .you,
            timeLabel: "3月24日",
            likeCount: 356,
            commentCount: 31,
            readMinutes: 8,
            isExperience: true
        ),
        DiscoveryPost(
            id: "profile-cover-letter",
            format: .guide,
            region: .schengen,
            title: "我的解释信，只写了一页",
            summary: "行程、工作、费用和回程安排，分段讲清楚就好。",
            body: """
            网上的解释信模板都很正式，读起来却不像我。我重新写了一版，只保留自己的行程、工作情况、费用安排和回程计划。

            每段回答一个问题，不重复材料里已经清楚的信息。隔天再读一遍，删掉了不少没有实际内容的形容词。
            """,
            coverImage: "coverLaptopNotes",
            coverAspectRatio: 1.5,
            tags: ["解释信", "材料整理"],
            author: .you,
            timeLabel: "3月18日",
            likeCount: 228,
            commentCount: 18,
            readMinutes: 4,
            isExperience: true
        ),
        DiscoveryPost(
            id: "profile-accommodation-proof",
            format: .guide,
            region: .schengen,
            title: "住宿证明，别只存一堆截图",
            summary: "日期、住客姓名和订单状态，核对时放在一起看。",
            body: """
            行程改了几次，手机里留下很多不同版本的订单。我把已取消的移到单独文件夹，只在目录里保留当前有效的信息。

            最后按入住日期排列，核对是否衔接得上。纸质件和离线文件都用同一份目录，路上找起来也方便。
            """,
            coverImage: "coverNotes",
            coverAspectRatio: 1.25,
            tags: ["住宿", "材料整理"],
            author: .you,
            timeLabel: "3月9日",
            likeCount: 187,
            commentCount: 23,
            readMinutes: 5,
            isExperience: true
        ),
        DiscoveryPost(
            id: "profile-uk-visit",
            format: .guide,
            region: .unitedKingdom,
            title: "第二次英签，我删掉了哪些材料",
            summary: "不追求文件夹更厚，只让每份文件更有用。",
            body: """
            重新申请时，先按这次的情况列一张清单，而不是复制上次的文件夹。重复的说明删掉，变化的地方单独核对。

            准备过程短了一些，心里也更有底。旧经验可以参考，但不能替代每次申请前的重新确认。
            """,
            coverImage: "coverLondonAerial",
            coverAspectRatio: 1.5,
            tags: ["材料整理", "出行准备"],
            author: .you,
            timeLabel: "2月28日",
            likeCount: 261,
            commentCount: 32,
            readMinutes: 7,
            isExperience: true
        ),
        DiscoveryPost(
            id: "profile-kirkjufell",
            format: .photo,
            region: .schengen,
            title: "教会山，天气转坏之前",
            summary: "只有十分钟晴天，也值得把脚步放慢。",
            body: """
            远处的云层很厚，我们没有再往远处开。沿着步道走了一小段，刚好看见光落在山坡上。

            拍完照片回到车里，雨就下起来了。这张照片提醒我，旅行里很多好时候都不需要等太久。
            """,
            coverImage: "coverIcelandKirkjufell",
            coverAspectRatio: 1.5,
            tags: ["冰岛", "摄影"],
            author: .you,
            timeLabel: "2月20日",
            likeCount: 512,
            commentCount: 16,
            readMinutes: nil,
            isExperience: true
        ),
        DiscoveryPost(
            id: "profile-b2-interview",
            format: .guide,
            region: .unitedStates,
            title: "美签面谈，我记住的几句话",
            summary: "提前理清自己的安排，比背答案更让我安心。",
            body: """
            准备时没有写一长串标准答案，只把自己的工作、出行目的和大致行程梳理清楚。材料按问题分组，知道需要时去哪里找。

            现场的问题比我预想得少。这里只是一次个人经历，每个人被问到的内容都会不同。
            """,
            coverImage: "coverNYCEmpire",
            coverAspectRatio: 0.8,
            tags: ["面谈", "行前准备"],
            author: .you,
            timeLabel: "2月12日",
            likeCount: 296,
            commentCount: 27,
            readMinutes: 6,
            isExperience: true
        ),
        DiscoveryPost(
            id: "profile-glacier",
            format: .photo,
            region: .schengen,
            title: "冰河湖的小雨，没有拍进照片",
            summary: "天是灰蓝色的，冰沿着水面缓慢移动。",
            body: """
            湖边有一点风，雨很细，镜头很快就湿了。我们收起相机，沿着岸边慢慢走到没有人的地方。

            照片记住了颜色，身体记住了温度。有时两种记忆不必完全一样。
            """,
            coverImage: "coverIcelandGlacier",
            coverAspectRatio: 1.0,
            tags: ["冰岛", "自然"],
            author: .you,
            timeLabel: "1月28日",
            likeCount: 619,
            commentCount: 23,
            readMinutes: nil,
            isExperience: false
        ),
        DiscoveryPost(
            id: "profile-copenhagen",
            format: .photo,
            region: .schengen,
            title: "哥本哈根，今天不按清单走",
            summary: "从面包店到港边，一张车票就够了。",
            body: """
            这次只预约了一处参观，其余时间都留给散步。早晨吃面包，中午在市场找热饭，下午沿着港边慢慢走。

            最喜欢的一小时是在长椅上看船。什么都没完成，却觉得这才是周末。
            """,
            coverImage: "coverCopenhagen",
            coverAspectRatio: 0.8,
            tags: ["丹麦", "周末"],
            author: .you,
            timeLabel: "1月16日",
            likeCount: 244,
            commentCount: 15,
            readMinutes: nil,
            isExperience: false
        )
    ]
}

struct ProfileVisaExperience: Identifiable {
    let id: String
    let image: String
    let label: String
    let detail: String

    static let samples = [
        ProfileVisaExperience(id: "gb", image: "visaFlagGB", label: "英国", detail: "英国 · 访客签证申请"),
        ProfileVisaExperience(id: "us", image: "visaFlagUS", label: "美国", detail: "美国 · B1/B2 签证申请"),
        ProfileVisaExperience(id: "fr", image: "visaFlagFR", label: "法国", detail: "法国 · 分享过申根申请经历"),
        ProfileVisaExperience(id: "is", image: "visaFlagIS", label: "冰岛", detail: "冰岛 · 分享过旅行与签证经历")
    ]
}
