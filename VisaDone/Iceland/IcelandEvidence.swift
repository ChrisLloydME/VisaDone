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
        .init(id:"marriage-context",documentID:"marriage",summary:"家庭关系资料按婚姻状况与资助安排选择，不把结婚证当成每位申请人的通用材料。",reasoning:"从社区整理经验中提取适用情形与文件组织方式，作为个人补充准备，不改变官方材料清单。",sourceIDs:["supporting-home-ties", "parent-sponsored-trip"],action:.annotation,materialTitle:"家庭关系补充说明"),
        .init(id:"property-context",documentID:"property",summary:"房产与长期居住资料可补充说明国内生活联系，与个人情况相符时再准备。",reasoning:"从社区整理经验中提取适用情形与文件组织方式，作为个人补充准备，不改变官方材料清单。",sourceIDs:["supporting-home-ties"],action:.annotation,materialTitle:"资产与居住情况注释"),
        .init(id:"social-insurance-context",documentID:"social-insurance",summary:"将社保记录与在职、收入资料对应，补充说明持续的工作联系。",reasoning:"从社区整理经验中提取适用情形与文件组织方式，作为个人补充准备，不改变官方材料清单。",sourceIDs:["supporting-home-ties"],action:.annotation,materialTitle:"社保与职业情况注释"),
        .init(id:"return-work-context",documentID:"return-work",summary:"把旅行日期、批准休假与预计返岗时间放在一起，便于理解出行和工作的衔接。",reasoning:"从社区整理经验中提取适用情形与文件组织方式，作为个人补充准备，不改变官方材料清单。",sourceIDs:["supporting-home-ties", "document-organisation"],action:.annotation,materialTitle:"准假与返岗安排注释"),
        .init(id:"passport-spares-context",documentID:"passport-spares",summary:"护照信息页可以额外准备几份；领取时的具体凭证仍按签证中心通知核对。",reasoning:"从社区整理经验中提取适用情形与文件组织方式，作为个人补充准备，不改变官方材料清单。",sourceIDs:["passport-collection-notes", "document-copy-folder"],action:.annotation,materialTitle:"护照复印件与领取注释"),
        .init(id:"identity-spares-context",documentID:"identity-spares",summary:"身份证与户口簿留一套备用复印件，正式递交文件和个人留存分开整理。",reasoning:"从社区整理经验中提取适用情形与文件组织方式，作为个人补充准备，不改变官方材料清单。",sourceIDs:["document-copy-folder", "document-organisation"],action:.annotation,materialTitle:"证件备用复印件注释"),
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
        case "marriage": [
            "已婚申请人可以按个人情况整理结婚证复印件，与本人及配偶的身份信息对应。它可用于说明家庭关系；如由配偶承担旅行费用，也可以和资助说明、收入及流水材料放在同一组。",
            "这是一项按情况选择的补充准备，不要求未婚申请人提供。若自己的适用官方条款另行要求婚姻关系公证、认证或翻译，应按该条款处理，普通复印件不替代那些文件。"
        ]
        case "property": [
            "本人名下有房产时，可整理房产证或不动产权证的相关复印件，让持有人、地址与产权信息清楚可读。需要说明长期居住情况时，也可以关联与自己情况相符的居住资料。",
            "这组资料补充展示国内资产与生活联系，不替代银行流水或收入证明。没有房产的申请人无需为此补造材料，可用自己的工作、学习、家庭或居住情况说明旅行后的安排。"
        ]
        case "social-insurance": [
            "可整理近期社保缴纳记录，关注姓名、缴纳单位与记录期间是否清晰，并与在职证明、收入资料中的单位名称对应。电子记录可以保留清晰的打印版本，便于与其他材料一起核对。",
            "社保记录在这里用于补充职业联系，不作为统一强制材料。有换工作、缴纳间断等情况时，按实际经历说明即可，不把整理后的记录包装成连续就业的证明。"
        ]
        case "return-work": [
            "可在单位出具的准假说明中列明申请人、休假日期和预计返岗时间，并让它与旅行日期相互对应。已有在职证明可以放在旁边，避免为相同事实重复准备多份内容不同的说明。",
            "自由职业、退休或暂未就业的申请人不必套用单位准假模板。可结合自己的日常工作、家庭事务或其他实际安排补充说明，清楚表达旅行结束后的计划。"
        ]
        case "passport-spares": [
            "可以额外准备几份护照信息页复印件，一份放在递交资料中，其他作为个人备用，与电子扫描件一起留存。原件递交之后，也方便核对姓名、护照号码和有效期。",
            "社区有申请者提到，护照复印件可能会用于领取护照时的身份或资料核对。这是领取环节的个案经验，不把它当成唯一领取凭证；保留签证中心出具的收据、领取通知，并按通知准备本人或代领所需证件。"
        ]
        case "identity-spares": [
            "身份证正反面可以保留清晰的备用复印件，户口簿也可准备户主页、本人页及与本次申请相关的页面。备用文件放在单独文件袋中，正式递交的整本复印范围仍按官方清单整理。",
            "将“交给中心的一套”和“自己留存的一套”分开，复印件上检查姓名、号码和页面边缘是否完整。备用件是为现场核对、补充或领取时方便使用，不表示每个中心都统一要求额外份数。"
        ]
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
    @State private var hovered = false
    @Environment(\.colorScheme) private var scheme
    private var sources:[IcelandSourcePost] { insight.sourceIDs.compactMap { id in posts.first { $0.id == id } } }
    var body: some View {
        Button { showingSources = true } label: {
            HStack(alignment:.top,spacing:20) {
                VStack(alignment:.leading,spacing:8) {
                    Label {
                        Text("AI 补充").foregroundStyle(.secondary)
                    } icon: {
                        Image(systemName:"sparkles")
                            .foregroundStyle(LinearGradient(colors:IcelandIntelligenceStyle.colors,startPoint:.topLeading,endPoint:.bottomTrailing))
                    }.font(.callout.weight(.medium))
                    Text("\(sources.count) 篇相关帖子").font(.caption).foregroundStyle(.secondary)
                    if application.acceptedInsightIDs.contains(insight.id) {
                        Label("已添加",systemImage:"checkmark").font(.caption).foregroundStyle(.secondary)
                    }
                }.frame(width:112,alignment:.leading)
                VStack(alignment:.leading,spacing:14) {
                    Text(insight.summary).font(.system(size:13,weight:.medium)).lineSpacing(4)
                        .fixedSize(horizontal:false,vertical:true)
                    VStack(alignment:.leading,spacing:12) {
                        ForEach(Array(insight.details.enumerated()),id:\.offset) { index,paragraph in
                            HStack(alignment:.top,spacing:10) {
                                Text("\(index+1).").font(.system(size:12).monospacedDigit()).foregroundStyle(.secondary)
                                    .frame(width:14,alignment:.leading).padding(.top,2)
                                Text(paragraph).font(.system(size:13,weight:.regular)).lineSpacing(5)
                                    .fixedSize(horizontal:false,vertical:true)
                            }
                        }
                    }
                    Label("查看帖子与整理依据",systemImage:"arrow.up.right")
                        .font(.caption).foregroundStyle(.secondary).padding(.top,2)
                }.frame(maxWidth:.infinity,alignment:.leading)
            }
            .foregroundStyle(.primary).multilineTextAlignment(.leading)
            .padding(.horizontal,8).padding(.vertical,12)
            .frame(maxWidth:.infinity,alignment:.leading).contentShape(Rectangle())
            .background {
                if hovered || showingSources {
                    Color.clear.icelandIntelligenceSweep(in:RoundedRectangle(cornerRadius:12),borderColor:.blue,blurRadius:12,lineWidth:0.8)
                        .allowsHitTesting(false)
                }
            }
        }
        .buttonStyle(.plain)
        .onHover {hovered=$0}
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
                Label("AI 整理 · 社区补充",systemImage:"sparkles").font(.headline).foregroundStyle(.primary)
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
