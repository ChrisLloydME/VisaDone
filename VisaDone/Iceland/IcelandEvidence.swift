import AppKit
import SwiftUI

struct IcelandSourcePost: Identifiable {
    let id:String
    let title:String
    let author:String
    let excerpt:String
    let image:String?
    let time:String
    var fullText:String = ""
}

struct IcelandCommunityInsight: Identifiable {
    enum Action { case annotation, material }
    let id:String
    let documentID:String
    let summary:String
    let reasoning:String
    let sourceIDs:[String]
    let action:Action
    let materialTitle:String

    static let fixtures:[Self] = [
        .init(id:"guest-names",documentID:"accommodation",
              summary:"核对订单能否显示全部同行人；必要时向住宿方补充住客确认。",
              reasoning:"将补充住客信息的个案与不同申请中的处理差异合并，再关联本次三人同行的情况。这里是社区经验的归纳，不是官方新增要求。",
              sourceIDs:["iceland-nine-days","three-applications","slow-paris"],action:.annotation,materialTitle:"同行人住宿信息"),
        .init(id:"insurance-dates",documentID:"insurance",
              summary:"按德国入境到最后离开申根区的日期核对保险，不只核对冰岛段。",
              reasoning:"把社区帖子提到的日期、保障区域和行程衔接核对方法，应用到本次德国入境、丹麦中转的路线。",
              sourceIDs:["insurance-question","itinerary-template"],action:.annotation,materialTitle:"保险与中转日期核对"),
        .init(id:"student-context",documentID:"student",
              summary:"把在读证明、学籍报告与假期安排放在一起，说明成年学生的出行背景。",
              reasoning:"从成年学生的整理经验中提取在读与出行日期的关联，形成这次申请的辅助材料建议；没有把未成年人条款套用到此处。",
              sourceIDs:["adult-student-materials","parent-sponsored-trip"],action:.material,materialTitle:"在读与旅行日期说明"),
        .init(id:"funding-context",documentID:"sponsor",
              summary:"用一页资助说明串起母亲的收入、流水、亲属关系与费用承担。",
              reasoning:"将资助关系的社区案例与资金材料的一致性检查方法合并，整理成此申请可自行选择的补充说明。",
              sourceIDs:["parent-sponsored-trip","schengen-costs","cover-letter-detail"],action:.material,materialTitle:"家庭资助关系说明"),
        .init(id:"bank-explanation",documentID:"bank",
              summary:"分别说明本人储蓄转回和家庭赠与，不将所有入账当成固定收入。",
              reasoning:"结合社区对资金前后一致性的讨论和本次示例流水，归纳需要确认来源的记录。",
              sourceIDs:["schengen-costs","cover-letter-detail"],action:.annotation,materialTitle:"资金来源注释"),
        .init(id:"winter-route",documentID:"itinerary",
              summary:"小团活动与住宿待确认的部分单独标明，给长路段和天气变化留出余量。",
              reasoning:"从冰岛行程复盘、冰河湖路线讨论与行程单整理帖中，提取共同的日期、交通、住宿核对方法。",
              sourceIDs:["kirkjufell-morning","glacier-meets-sea","itinerary-template"],action:.annotation,materialTitle:"行程衔接注释"),
        .init(id:"relationship-context",documentID:"relationship",
              summary:"亲属关系资料用于解释本次资助关系，作为个案辅助材料整理。",
              reasoning:"从成年学生和父母资助的帖子中归纳资料之间的对应关系，不将其改写为所有成年申请人的统一必交项。",
              sourceIDs:["parent-sponsored-trip","adult-student-materials"],action:.annotation,materialTitle:"亲属关系注释"),
        .init(id:"explanation-context",documentID:"explanation",
              summary:"只补充现有文件不易读出的事实，并让说明紧邻相应材料。",
              reasoning:"从解释信与材料索引的讨论中，提取按事实和文件组织说明的方法。",
              sourceIDs:["cover-letter-detail","document-organisation"],action:.annotation,materialTitle:"补充说明注释")
    ]
    static func forDocument(_ id:String) -> Self? {
        fixtures.first { $0.documentID == id } ?? fixtures.first { "community-" + $0.id == id }
    }
    var details:[String] {
        switch documentID {
        case "accommodation": [
            "本次行程从德国进入申根区，经丹麦前往冰岛，最后从丹麦经德国返回。核对时把中转停留与冰岛住宿放在同一条日期线上，逐晚对应入住、退房和城市；多晚连住保留完整订单即可。",
            "当前关联订单显示一位预订人，而旅行计划中有三位同行人。可以先向酒店询问是否能把三位住客列在确认单上；若平台不支持修改，则把酒店邮件确认与原订单放在一起。帖子中的补件经历有差异，具体做法需结合这次预订情况选择。"
        ]
        case "insurance": [
            "这次在 3 月 2 日抵达慕尼黑，3 月 12 日从慕尼黑离开申根区。检查保单时对照完整的入境、转机和返程安排，不能只使用 3 月 3 日至 11 日的冰岛停留日期。",
            "把保障地区、起止时刻、被保险人和医疗保障额度分别核对。遇到以北京时间起算的保单，可在保险文件旁留下时区说明，避免只看日期相同就认为覆盖完整。"
        ]
        case "student": [
            "本人的申请背景是成年在读大学生，没有固定工资，由母亲承担主要旅行费用。在读证明用来说明目前身份，学籍报告作为对应资料，校历则帮助说明出行日期与学校安排的关系。",
            "建议将三份资料按“身份—学籍—日期”顺序整理，再附一段简短说明。这里归纳的是成年学生的个案整理方式；官方原文中面向未成年人的监护、学校和亲属关系条款保留其原有适用范围。"
        ]
        case "sponsor": [
            "母亲既是同行人，也是本次主要资助人。资助说明可以写清关系、共同出行的日期、承担哪些费用，并对应到收入证明、银行流水与签署的资助声明，便于理解材料之间的联系。",
            "本人账户中的生活费与储蓄仍单独整理；三人的旅行预订可以共用，个人的申请表、身份文件与资金说明分别归档。社区帖子提供的是组织材料的思路，加入清单后仍保留黄色来源标识。"
        ]
        case "bank": [
            "示例流水中有一笔本人储蓄转回、一笔生日礼金与日常生活费结余。先确认每笔交易的来源，再决定哪些需要补充说明；转回本人账户的储蓄不重复计算成收入，家庭赠与也不写成工资。",
            "说明按交易日期与金额对应原始记录，必要时关联转出记录或资助说明。生成草稿后可以逐句修改，再与母亲承担主要旅行费用的安排保持一致。"
        ]
        case "itinerary": [
            "以航班和已订住宿作为日期骨架，再填写每天的交通、活动与过夜地点。斯奈山一日团和南岸多日团保留运营方名称，尚未确认的活动使用“计划参加”，避免与已预订项目混在一起。",
            "冬季的长距离移动应留出天气与道路余量。社区对冰河湖路段的意见可以附在对应日期上；采纳建议后仍保留修改依据，导出的行程单则使用整理后的交通与住宿信息。"
        ]
        case "relationship": [
            "这组资料与母亲的资助安排关联，帮助理解申请人与资助人的关系。整理时将关系资料、资助声明和资助人的身份文件相互对应，避免同一事实在不同文件中出现不同写法。",
            "成年学生与未成年申请人的情形分开处理。这里保留社区案例的适用背景，作为本次申请的辅助信息，不改变官方条款原有的范围。"
        ]
        default: [
            "补充说明围绕现有材料中不容易直接看出的事实展开，例如本人在读、费用由家人承担、跨国转机以及个别资金来源。每段说明对应一个具体文件或日期，方便读者顺着材料核对。",
            "不需要把所有经历写进一封长信。可以先列出需要解释的事项，引用已整理的文件，删除重复描述，再将确认后的说明附在相关材料旁。"
        ]
        }
    }

}

enum IcelandSourceColor {
    static func official(_ scheme:ColorScheme) -> Color {
        Color(nsColor:scheme == .dark ? .systemGreen : NSColor.systemGreen.blended(withFraction:0.20,of:.black)!)
    }
    static func algorithm(_ scheme:ColorScheme) -> Color {
        // Yellow stays legible against a light system surface.
        Color(nsColor:scheme == .dark ? .systemYellow : NSColor.systemYellow.blended(withFraction:0.43,of:.black)!)
    }
}

struct IcelandInsightButton: View {
    let insight:IcelandCommunityInsight
    let posts:[IcelandSourcePost]
    @Bindable var application:IcelandApplicationState
    let openPost:(String)->Void
    @State private var showingSources = false
    @Environment(\.colorScheme) private var scheme
    private var sources:[IcelandSourcePost] { insight.sourceIDs.compactMap { id in posts.first { $0.id == id } } }
    var body: some View {
        Button { showingSources = true } label: {
            VStack(alignment:.leading,spacing:5) {
                HStack(spacing:6) {
                    Label("AI 整理 · 社区补充",systemImage:"sparkles").font(.caption)
                    Text("· \(sources.count) 篇相关帖子").font(.caption)
                    if application.acceptedInsightIDs.contains(insight.id) { Image(systemName:"checkmark").font(.caption) }
                }
                Text(insight.summary).font(.body.weight(.medium)).multilineTextAlignment(.leading).fixedSize(horizontal:false,vertical:true)
                ForEach(insight.details,id:\.self) { paragraph in
                    Text(paragraph).font(.body).lineSpacing(4).multilineTextAlignment(.leading)
                        .fixedSize(horizontal:false,vertical:true)
                }
                Label("查看帖子与整理依据",systemImage:"arrow.up.right").font(.caption).padding(.top,3)
            }
            .foregroundStyle(IcelandSourceColor.algorithm(scheme))
            .frame(maxWidth:.infinity,alignment:.leading).contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .help("查看相关社区帖子和整理依据")
        .popover(isPresented:$showingSources,arrowEdge:.bottom) {
            IcelandInsightPopover(insight:insight,posts:sources,application:application) { id in
                showingSources=false
                DispatchQueue.main.async { openPost(id) }
            }
        }
    }
}

struct IcelandInsightPopover: View {
    let insight:IcelandCommunityInsight
    let posts:[IcelandSourcePost]
    @Bindable var application:IcelandApplicationState
    let openPost:(String)->Void
    @Environment(\.colorScheme) private var scheme
    private var accepted:Bool { application.acceptedInsightIDs.contains(insight.id) }
    var body: some View {
        VStack(alignment:.leading,spacing:0) {
            VStack(alignment:.leading,spacing:10) {
                Label("AI 整理 · 社区补充",systemImage:"sparkles").font(.headline).foregroundStyle(IcelandSourceColor.algorithm(scheme))
                Text(insight.summary).font(.body)
                Text(insight.reasoning).font(.callout).foregroundStyle(.secondary)
                Text("相关帖子（\(posts.count)）").font(.headline).padding(.top,3)
            }.padding(18)
            Divider()
            ScrollView {
                VStack(alignment:.leading,spacing:20) {
                    ForEach(posts) { post in
                        VStack(alignment:.leading,spacing:10) {
                            HStack(alignment:.top,spacing:12) {
                                if let image=post.image {
                                    Image(image).resizable().scaledToFill().frame(width:72,height:54)
                                        .clipped().clipShape(.rect(cornerRadius:5))
                                }
                                VStack(alignment:.leading,spacing:5) {
                                    Button(post.title) { openPost(post.id) }.buttonStyle(.link).font(.headline)
                                    Text(post.author + " · " + post.time).font(.caption).foregroundStyle(.secondary)
                                }
                            }
                            Text(post.fullText.isEmpty ? post.excerpt : post.fullText)
                                .font(.body).lineSpacing(4).textSelection(.enabled)
                                .fixedSize(horizontal:false,vertical:true)
                            Button("查看原帖与评论",systemImage:"arrow.up.right") { openPost(post.id) }
                                .buttonStyle(.link).font(.callout)
                        }
                        if post.id != posts.last?.id { Divider() }
                    }
                }.padding(18)
            }.frame(height:390)
            Divider()
            HStack {
                Text(accepted ? "保留 AI 来源标识" : "不会改动官方要求").font(.caption).foregroundStyle(.secondary)
                Spacer()
                Button(accepted ? "移除补充" : (insight.action == .annotation ? "附到材料要求" : "加入我的材料")) {
                    application.toggleInsight(insight)
                }.buttonStyle(.bordered)
            }.padding(14)
        }.frame(width:540)
    }
}
