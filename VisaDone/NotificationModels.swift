import SwiftUI

// All conversations and interactions are local fixtures. No messaging service is used.
enum InboxKind: String, CaseIterable, Identifiable {
    case all = "全部", direct = "消息", comment = "评论", system = "系统"
    var id: String { rawValue }
}

struct InboxMessage: Identifiable {
    var id = UUID().uuidString
    var text: String
    var time: String
    var outgoing = false
    var image: String? = nil
    var document: String? = nil
}

struct InboxConversation: Identifiable {
    var id: String
    var kind: InboxKind
    var author: DiscoveryAuthor?
    var name: String
    var subtitle: String
    var time: String
    var unread: Int
    var muted = false
    var postID: String? = nil
    var messages: [InboxMessage]
    var preview: String { messages.last?.text ?? "" }
}

@Observable final class NotificationInbox {
    var selectedID = "mira"
    var filter: InboxKind = .direct
    var query = ""
    var drafts: [String: String] = [:]
    var conversations = NotificationSamples.conversations
    var commentThreads = CommentThreadSamples.make(from: NotificationSamples.conversations)
    init() {
        for index in conversations.indices where conversations[index].kind == .comment {
            guard let thread = commentThreads[conversations[index].id] else { continue }
            conversations[index].messages = thread.comments.map {
                InboxMessage(text: $0.text, time: $0.time, outgoing: $0.author.id == DiscoveryAuthor.you.id)
            }
        }
    }
    var unreadCount: Int { conversations.reduce(0) { $0 + $1.unread } }
    var visibleConversations: [InboxConversation] {
        conversations.filter {
            (filter == .all || (filter == .direct ? $0.kind != .comment : $0.kind == filter)) &&
            (query.isEmpty || ($0.name + $0.preview + (commentThreads[$0.id]?.comments.map(\.text).joined() ?? "") + postTitle(for: $0)).localizedStandardContains(query))
        }
    }
    func postTitle(for conversation: InboxConversation) -> String {
        ProfileFixtures.authoredPosts.first { $0.id == conversation.postID }?.title ?? "社区讨论"
    }
    func reply(to parentID: String, text: String) {
        guard var thread = commentThreads[selectedID], thread.comments.contains(where: { $0.id == parentID }),
              let index = conversations.firstIndex(where: { $0.id == selectedID }) else { return }
        let body = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !body.isEmpty else { return }
        thread.comments.append(InboxComment(parentID: parentID, author: .you, text: body, time: "刚刚"))
        commentThreads[selectedID] = thread
        conversations[index].messages.append(InboxMessage(text: body, time: "刚刚", outgoing: true))
        conversations[index].time = "刚刚"
        drafts[selectedID] = ""
    }
    var selected: InboxConversation? { conversations.first { $0.id == selectedID } }
    func select(_ id: String) {
        selectedID = id
        if let index = conversations.firstIndex(where: { $0.id == id }) { conversations[index].unread = 0 }
    }
    func markAllRead() {
        for index in conversations.indices { conversations[index].unread = 0 }
    }
    func toggleMuted(_ id: String) {
        guard let index = conversations.firstIndex(where: { $0.id == id }) else { return }
        conversations[index].muted.toggle()
    }
    func markUnread(_ id: String) {
        guard let index = conversations.firstIndex(where: { $0.id == id }) else { return }
        conversations[index].unread = 1
    }
    func send() {
        let text = (drafts[selectedID] ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, let index = conversations.firstIndex(where: { $0.id == selectedID }), conversations[index].kind != .system else { return }
        conversations[index].messages.append(InboxMessage(text: text, time: "刚刚", outgoing: true))
        conversations[index].time = "刚刚"
        drafts[selectedID] = ""
        let updated = conversations.remove(at: index)
        conversations.insert(updated, at: 0)
    }
}

private enum NotificationSamples {
    static let conversations: [InboxConversation] = [
        .init(id: "mira", kind: .direct, author: .mira, name: DiscoveryAuthor.mira.name,
              subtitle: "互相关注", time: "14:32", unread: 0, messages: [
                .init(text: "我在重排冰岛的路线，越改越觉得原来每天安排得太满。", time: "13:52"),
                .init(text: "可以先确定每晚住哪里，剩下的停留点再慢慢取舍。", time: "13:56", outgoing: true),
                .init(text: "我试了一下，南岸这段最纠结。", time: "14:03"),
                .init(text: "把最拿不准的那天发我看看。", time: "14:07", outgoing: true),
                .init(text: "看了你发的冰岛行程，想问问维克到冰河湖那天，最后是怎么调整的？", time: "14:18"),
                .init(text: "我们把冰河湖单独留了一天，前一晚住在附近，就不用当天来回赶路了。", time: "14:20", outgoing: true),
                .init(text: "这是回来之后整理的路线，实际开下来，南岸值得多留一点时间。", time: "14:21", outgoing: true, image: "coverIcelandSkogafoss"),
                .init(text: "这张照片好美！我也在纠结要不要少安排一个停留点。", time: "14:25"),
                .init(text: "可以看看这份公开版，住宿和交通分开写了，预订信息已经删掉。", time: "14:28", outgoing: true, document: "冰岛九日行程 · 公开版.pdf"),
                .init(text: "收到，我先按这个节奏改一版。改好了再来找你讨论，谢谢！", time: "14:32")
              ]),
        .init(id: "comment-sofia", kind: .comment, author: .sofia, name: DiscoveryAuthor.sofia.name,
              subtitle: "回复了你的行程讨论", time: "14:30", unread: 2, postID: "profile-iceland-itinerary", messages: [
                .init(text: "我看了你更新的公开版，南岸比之前留的时间多了。", time: "13:10"),
                .init(text: "是的，不过第四天的路程我还是有点拿不准。", time: "13:14", outgoing: true),
                .init(text: "你们是两个人轮流开车吗？", time: "13:22"),
                .init(text: "两个人，但希望别把每天都排成赶路。", time: "13:31", outgoing: true),
                .init(text: "第四天是不是可以拆成两天？维克到冰河湖一路有很多可以停的地方，原来的安排有点赶。", time: "13:48"),
                .init(text: "有道理，我把冰河湖单独留了一天，前一天只走南岸。", time: "14:02", outgoing: true),
                .init(text: "这样舒服多了！记得把第二晚的住宿也往东挪一点，就不用折返。", time: "14:16"),
                .init(text: "已经调整了，也把那天的活动减少到两个。", time: "14:21", outgoing: true),
                .init(text: "可以把其他停留点留在备注里，天气和时间合适再决定。", time: "14:24"),
                .init(text: "这个办法好，我再改一下公开版，谢谢你帮忙看。", time: "14:30", outgoing: true)
              ]),
        .init(id: "system", kind: .system, author: nil, name: "VisaDone", subtitle: "系统通知", time: "13:50", unread: 2, messages: [
                .init(text: "你的行程已保存\n\n冰岛九日行程的最新版本已保存到「签证申请」，下次可以继续编辑。", time: "09:41"),
                .init(text: "公开版本已发布\n\n你分享的行程已发布到社区。其他用户可以查看公开版本并提出建议，私人申请文件不会随帖公开。", time: "10:12"),
                .init(text: "递交前，再核对一次\n\n你设置了明天的递交提醒。可以打开申请清单，检查尚未确认的材料和预约记录。", time: "13:50")
              ]),
        .init(id: "daniel", kind: .direct, author: .daniel, name: DiscoveryAuthor.daniel.name,
              subtitle: "互相关注", time: "12:08", unread: 1, messages: [
                .init(text: "你好，看到了你关于住宿订单的分享。我们的订单也只有预订人的名字，想问你后来怎么补的？", time: "11:42"),
                .init(text: "我联系住宿方补了同行人的信息。只是我这次的经历，你也可以先和自己的申请中心确认一下。", time: "11:56", outgoing: true),
                .init(text: "明白，我先给酒店写封邮件。谢谢你讲得这么详细。", time: "12:08")
              ]),
        .init(id: "comment-amara", kind: .comment, author: .amara, name: DiscoveryAuthor.amara.name,
              subtitle: "评论了你的帖子", time: "11:36", unread: 1, postID: "profile-schengen-folder", messages: [
                .init(text: "这个文件夹顺序太实用了！请问原件和复印件是放在一起，还是单独分两组？", time: "11:36")
              ]),
        .init(id: "theo", kind: .direct, author: .theo, name: DiscoveryAuthor.theo.name,
              subtitle: "互相关注", time: "11:18", unread: 1, messages: [
                .init(text: "下个月去英国，想把伦敦和爱丁堡都放进行程里。七天是不是有点赶？", time: "10:42"),
                .init(text: "我那次留了八天，两个城市之间坐火车，没再加别的地方。", time: "10:48", outgoing: true),
                .init(text: "那我也删掉中间的小镇吧，先把住宿和交通对应上。", time: "11:02"),
                .init(text: "可以先列每晚住哪里，再反过来排当天的活动。", time: "11:10", outgoing: true),
                .init(text: "刚重新排完，终于不用每天换酒店了。", time: "11:18")
              ]),
        .init(id: "comment-theo", kind: .comment, author: .theo, name: DiscoveryAuthor.theo.name,
              subtitle: "评论了你的帖子", time: "10:52", unread: 1, postID: "profile-vfs-appointment", messages: [
                .init(text: "我也是提前去的，外面排队那一段比实际递交花的时间还长。", time: "10:21"),
                .init(text: "那天确实人比较多，幸好材料都提前排好了。", time: "10:37", outgoing: true),
                .init(text: "你的现场复盘挺有帮助，下次我也带个小文件袋。", time: "10:52")
              ]),
        .init(id: "elena", kind: .direct, author: .elena, name: DiscoveryAuthor.elena.name,
              subtitle: "社区用户", time: "10:46", unread: 0, messages: [
                .init(text: "你那篇解释信的分享我收藏了。最近在整理换工作的这段经历，不知道写到什么程度。", time: "10:15"),
                .init(text: "我只写了材料本身看不出来、又和这次出行有关的部分。具体情况还是按你自己的经历说清楚。", time: "10:24", outgoing: true),
                .init(text: "嗯，我先按时间顺序整理一下，不硬套模板。", time: "10:32"),
                .init(text: "对，写完可以再读一遍，看日期和材料有没有对不上。", time: "10:39", outgoing: true),
                .init(text: "收到，这就去改。", time: "10:46")
              ]),
        .init(id: "noor", kind: .direct, author: .noor, name: DiscoveryAuthor.noor.name,
              subtitle: "互相关注", time: "10:12", unread: 2, messages: [
                .init(text: "酒店给我回邮件了，已经把两个人的名字都加上了。", time: "09:48"),
                .init(text: "太好了，导出的版本也检查一下，有时候网页和 PDF 显示的不一样。", time: "09:54", outgoing: true),
                .init(text: "确实！旧文件还在下载文件夹里，差点拿错。", time: "10:03"),
                .init(text: "我给最终版单独建了文件夹，就不会和草稿混起来。", time: "10:08", outgoing: true),
                .init(text: "这个习惯我也要学，文件名已经改好了。", time: "10:12")
              ]),
        .init(id: "jonah", kind: .direct, author: .jonah, name: DiscoveryAuthor.jonah.name,
              subtitle: "社区用户", time: "09:35", unread: 0, messages: [
                .init(text: "方便问一下，你的时间线里寄出和收到护照是分开记录的吗？", time: "09:12"),
                .init(text: "是的，通知上显示寄出那天单独记，实际拿到护照再补一条。", time: "09:18", outgoing: true),
                .init(text: "明白了，我之前把这两个日期写成同一天了。", time: "09:22"),
                .init(text: "我已经改过来，也注明了递交城市。", time: "09:35")
              ]),
        .init(id: "priya", kind: .direct, author: .priya, name: DiscoveryAuthor.priya.name,
              subtitle: "社区用户", time: "昨天", unread: 0, messages: [
                .init(text: "我把行程单的公开版本发出来了，方便的时候帮我看看交通衔接吗？", time: "昨天 18:10"),
                .init(text: "可以，晚点我看一下。你先把最拿不准的那一天标出来。", time: "昨天 18:26", outgoing: true),
                .init(text: "标好了，是雷克雅未克到维克那天，不确定要不要再加一个瀑布。", time: "昨天 18:30")
              ]),
        .init(id: "comment-lucas", kind: .comment, author: .lucas, name: DiscoveryAuthor.lucas.name,
              subtitle: "回复了你的评论", time: "昨天", unread: 0, postID: "profile-accommodation-proof", messages: [
                .init(text: "我这次没有被要求补交，但还是提前让酒店加上了全部入住人的名字，心里比较踏实。", time: "昨天 16:24")
              ]),
        .init(id: "clara", kind: .direct, author: .clara, name: DiscoveryAuthor.clara.name,
              subtitle: "互相关注", time: "昨天", unread: 0, messages: [
                .init(text: "你们冰岛那段是自己开车吗？我不自驾，正在把行程改成跟团加市内交通。", time: "昨天 20:03"),
                .init(text: "我们是自驾，所以我的时间安排不能直接套。你可以先确认能订到的团期。", time: "昨天 20:12", outgoing: true),
                .init(text: "是的，我把出发和返回的集合地点也写进去了。", time: "昨天 20:25"),
                .init(text: "这样看交通衔接就清楚多了。公开版记得把预订编号删掉。", time: "昨天 20:31", outgoing: true)
              ]),
        .init(id: "mateo", kind: .direct, author: .mateo, name: DiscoveryAuthor.mateo.name,
              subtitle: "社区用户", time: "昨天", unread: 0, messages: [
                .init(text: "我把蜜月那次的时间线补全了，获签之后才发现之前漏记了寄出日期。", time: "昨天 17:10"),
                .init(text: "现在补上也很有帮助，可以备注是哪一条通知里的时间。", time: "昨天 17:18", outgoing: true),
                .init(text: "已经备注，顺便把快递时间也单独写了。", time: "昨天 17:22")
              ]),
        .init(id: "aisha", kind: .direct, author: .aisha, name: DiscoveryAuthor.aisha.name,
              subtitle: "互相关注", time: "昨天", unread: 0, messages: [
                .init(text: "整理完了！材料从一摞纸变成有顺序的文件夹，感觉终于能安心一点。", time: "昨天 16:04"),
                .init(text: "递交前再对一遍自己的清单，别把还没确认的也勾成完成了。", time: "昨天 16:11", outgoing: true),
                .init(text: "还差保险那一项，我留了个待确认。", time: "昨天 16:16"),
                .init(text: "准备好了再更新，慢慢来。", time: "昨天 16:20", outgoing: true)
              ]),
        .init(id: "comment-elena", kind: .comment, author: .elena, name: DiscoveryAuthor.elena.name,
              subtitle: "回复了你的评论", time: "昨天", unread: 0, postID: "profile-cover-letter", messages: [
                .init(text: "我把解释信缩成一页了，删掉了和这次出行无关的内容。", time: "昨天 19:41"),
                .init(text: "如果能把事情说清楚，读起来会轻松很多。", time: "昨天 20:06", outgoing: true),
                .init(text: "是的，现在按日期读下来就明白了。", time: "昨天 20:14")
              ]),
        .init(id: "comment-noor", kind: .comment, author: .noor, name: DiscoveryAuthor.noor.name,
              subtitle: "评论了你的帖子", time: "昨天", unread: 1, postID: "profile-accommodation-proof", messages: [
                .init(text: "谢谢提醒，我导出的 PDF 里确实少了一位同行人的名字，已经联系住宿方。", time: "昨天 17:18"),
                .init(text: "可以再核对一下入住日期和地址，最好把更新后的版本也保存好。", time: "昨天 17:36", outgoing: true),
                .init(text: "刚拿到新版，已经和行程对过一遍了。", time: "昨天 18:05")
              ]),
        .init(id: "kenji", kind: .direct, author: .kenji, name: DiscoveryAuthor.kenji.name,
              subtitle: "社区用户", time: "周二", unread: 0, messages: [
                .init(text: "看完你的复盘，决定给冰岛的天气留一天机动时间。", time: "周二 19:02"),
                .init(text: "我们那次临时调整了一段路，有余量会轻松一些。", time: "周二 19:10", outgoing: true),
                .init(text: "我把必须预订的活动和可调整的停留点分开列了。", time: "周二 19:21"),
                .init(text: "这个很清楚，后面改路线也不用全部重排。", time: "周二 19:26", outgoing: true)
              ]),
        .init(id: "fiona", kind: .direct, author: .fiona, name: DiscoveryAuthor.fiona.name,
              subtitle: "互相关注", time: "周二", unread: 0, messages: [
                .init(text: "护照今天拿到啦，之前一起等消息的那几位我也回了一下。", time: "周二 14:07"),
                .init(text: "恭喜！出发前终于可以放松一点了。", time: "周二 14:13", outgoing: true),
                .init(text: "准备写一篇复盘，重点记一下补材料的那几天。", time: "周二 14:19"),
                .init(text: "记得区分自己的经历和材料清单里的原文，会更方便别人参考。", time: "周二 14:25", outgoing: true),
                .init(text: "好，我会把申请地和递交日期也写上。", time: "周二 14:31")
              ]),
        .init(id: "comment-kenji", kind: .comment, author: .kenji, name: DiscoveryAuthor.kenji.name,
              subtitle: "回复了你的行程讨论", time: "周二", unread: 0, postID: "profile-iceland-itinerary", messages: [
                .init(text: "南岸那段我建议别只看导航时间，我们一路停车的次数比预想的多。", time: "周二 12:34"),
                .init(text: "我们回来之后也有这个感觉，所以公开版里把停留时间单独列了。", time: "周二 13:02", outgoing: true),
                .init(text: "这样就直观多了，留给第一次去的人参考很合适。", time: "周二 13:28")
              ]),
        .init(id: "hana", kind: .direct, author: .hana, name: DiscoveryAuthor.hana.name,
              subtitle: "互相关注", time: "周一", unread: 0, messages: [
                .init(text: "护照今天收到了，终于可以安心准备出发了。", time: "周一 10:16"),
                .init(text: "太好了！也记得把时间线更新一下，大家最近都在等消息。", time: "周一 10:22", outgoing: true),
                .init(text: "已经补上啦，递交和签收日期都写了。", time: "周一 10:25")
              ]),
        .init(id: "ravi", kind: .direct, author: .ravi, name: DiscoveryAuthor.ravi.name,
              subtitle: "社区用户", time: "周一", unread: 0, messages: [
                .init(text: "你那个文件夹的分组方法很适合我。想问行程草稿和最终版怎么区分？", time: "周一 18:06"),
                .init(text: "草稿我留在工作目录，确认后的版本才放进递交文件夹，文件名加上日期。", time: "周一 18:12", outgoing: true),
                .init(text: "这样就不容易打印错了，我之前差点拿了上周的版本。", time: "周一 18:20")
              ]),
        .init(id: "comment-fiona", kind: .comment, author: .fiona, name: DiscoveryAuthor.fiona.name,
              subtitle: "评论了你的帖子", time: "周一", unread: 0, postID: "profile-schengen-folder", messages: [
                .init(text: "照着这个结构整理了一遍，原来散在各处的材料终于放到一起了。", time: "周一 09:22"),
                .init(text: "也记得按自己申请对应的官方清单再核对，不用完全照我的顺序。", time: "周一 09:46", outgoing: true),
                .init(text: "嗯，我在每组前面加了自己的核对页。", time: "周一 10:08")
              ]),
        .init(id: "leila", kind: .direct, author: .leila, name: DiscoveryAuthor.leila.name,
              subtitle: "互相关注", time: "周日", unread: 0, messages: [
                .init(text: "周末终于把公开版行程整理出来了，你有空帮我看看节奏吗？", time: "周日 15:30"),
                .init(text: "可以，先发到社区吧，大家也能对具体那一天提建议。", time: "周日 15:38", outgoing: true),
                .init(text: "发好了，酒店预订号和姓名都删掉了。", time: "周日 16:02"),
                .init(text: "我晚点去看，先收藏了。", time: "周日 16:10", outgoing: true)
              ])
    ]
}
