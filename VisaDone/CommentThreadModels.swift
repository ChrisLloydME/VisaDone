import Foundation

// Local community discussions. IDs preserve the root and each reply's actual parent.
struct InboxComment: Identifiable {
    var id = UUID().uuidString
    var parentID: String?
    var author: DiscoveryAuthor
    var text: String
    var time: String
    var likes: Int = 0
}

struct InboxCommentThread: Identifiable {
    let id: String
    let postID: String
    var comments: [InboxComment]
    var root: InboxComment { comments[0] }
    func parent(of comment: InboxComment) -> InboxComment? {
        comments.first { $0.id == comment.parentID }
    }
    func depth(of comment: InboxComment) -> Int {
        guard let parent = parent(of: comment) else { return 0 }
        return min(2, depth(of: parent) + 1)
    }
}

enum CommentThreadSamples {
    static func make(from conversations: [InboxConversation]) -> [String: InboxCommentThread] {
        Dictionary(uniqueKeysWithValues: conversations.filter { $0.kind == .comment }.map { conversation in
            let rootID = conversation.id + "-root"
            let author = conversation.author ?? .sofia
            var comments = conversation.messages.enumerated().map { index, message in
                InboxComment(id: index == 0 ? rootID : conversation.id + "-\(index)",
                             parentID: index == 0 ? nil : (index == 1 ? rootID : conversation.id + "-\(index-1)"),
                             author: message.outgoing ? .you : author,
                             text: message.text, time: message.time, likes: max(0, 8-index*2))
            }
            if conversation.id == "comment-sofia" {
                comments = [
                    .init(id: rootID, author: .you, text: "第四天计划从维克开到冰河湖，途中去黑沙滩和斯卡夫塔山，再回维克住宿。两个人轮流开车，这样安排会不会太赶？公开版里已经删掉了预订信息，想听听去过的朋友怎么取舍。", time: "今天 12:46", likes: 12),
                    .init(id: "south-coast", parentID: rootID, author: .sofia, text: "建议拆成两天。我们走过这一段，导航时间没算上停车和游览，最后比预计晚了不少。冰河湖可以单独留一天。", time: "13:10", likes: 8),
                    .init(id: "stay-east", parentID: "south-coast", author: .you, text: "有道理，我把冰河湖单独留一天，前一天只走南岸。第二晚也往东挪，就不用折返了。", time: "13:31", likes: 3),
                    .init(id: "weather", parentID: "stay-east", author: .sofia, text: "这样舒服多了！其他停留点放进备注，天气和时间合适再决定。", time: "13:48", likes: 5),
                    .init(id: "driving", parentID: rootID, author: .kenji, text: "补充一个实际感受：南岸很容易一路停车拍照。我们只保留了两个主要停留点，把路上时间也当成行程的一部分，轻松很多。", time: "14:02", likes: 6),
                    .init(id: "public-version", parentID: "driving", author: .you, text: "这个办法好，我再改一下公开版，把必去和可选分开写。谢谢你们帮忙看。", time: "14:30", likes: 1)
                ]
            }
            // Single incoming notifications still open the complete discussion, including context.
            if comments.count == 1 {
                let opening: String
                switch conversation.postID {
                case "profile-schengen-folder": opening = "这次按递交顺序重新整理了文件夹，每组前面放一张核对页。原件和复印件怎么分，大家有没有更顺手的办法？"
                default: opening = "我把这次住宿证明的准备经过整理在原帖里了。订单上的入住人、日期和地址都重新核对了一遍，大家遇到过哪些容易漏掉的地方？"
                }
                comments[0].parentID = rootID
                comments[0].id = conversation.id + "-reply"
                comments.insert(.init(id: rootID, author: .you, text: opening, time: "昨天 10:12", likes: 9), at: 0)
            }
            return (conversation.id, InboxCommentThread(id: conversation.id, postID: conversation.postID ?? "", comments: comments))
        })
    }
}
