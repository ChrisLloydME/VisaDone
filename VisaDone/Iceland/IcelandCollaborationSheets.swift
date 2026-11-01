import SwiftUI

struct IcelandFinanceSheet: View {
    @Bindable var application:IcelandApplicationState
    @State private var draft = ""
    private var generated:String {
        var paragraphs = ["To the Visa Officer,","I plan to visit Iceland from \(IcelandItineraryDocument.dateText(application.startDate)) to \(IcelandItineraryDocument.dateText(application.endDate)). The itinerary, transport arrangements and accommodation details are provided separately."]
        switch application.funding {
        case "自行承担":paragraphs.append("I will cover the expenses of this trip using my personal funds. My financial records are provided with the application.")
        case "家人资助":paragraphs.append("A family member will sponsor this trip. The sponsorship statement and supporting financial records are provided separately.")
        case "单位承担":paragraphs.append("My employer will cover the travel expenses. The supporting company documents are provided separately.")
        default:paragraphs.append("The expenses will be shared by the travellers. The arrangement is described in the accompanying financial documents.")
        }
        if application.confirmedTransactions.contains("savings") { paragraphs.append("The transfer of CNY 12,800 is a withdrawal of my own savings from a personal money-market account into my bank account.") }
        if application.confirmedTransactions.contains("gift") { paragraphs.append("The CNY 5,000 credit is a one-time birthday gift from my family.") }
        if application.confirmedTransactions.contains("allowance") { paragraphs.append("The remaining CNY 3,200 represents accumulated savings from my regular living allowance.") }
        if application.flightSynced { paragraphs.append("The Munich–Copenhagen flight reference has been updated to LH2440. The revised itinerary reflects this change.") }
        paragraphs.append("These descriptions reflect the sources I have personally confirmed. Please refer to the accompanying records for the relevant details.")
        return paragraphs.joined(separator:"\n\n")
    }
    var body: some View {
        VStack(alignment:.leading,spacing:18) {
            IcelandSheetHeader(title:"资金与资助说明草稿",subtitle:"基于已确认的资金来源 · 可直接修改")
            HStack { Label(application.funding,systemImage:"person.2");Spacer();Text("英文文件").foregroundStyle(.secondary) }.font(.system(size:12))
            TextEditor(text:$draft).font(.system(size:13)).lineSpacing(5).padding(8)
            Text("仅保留你能解释并提供依据的内容。金额与关系为本案例的示例信息。")
                .font(.system(size:11)).foregroundStyle(.secondary)
            HStack {
                Button("取消") { application.sheet = nil }.keyboardShortcut(.cancelAction)
                Button("重新生成") { draft = generated }
                Spacer()
                Button("保存到补充说明") {
                    application.financialDraft = draft
                    application.setStatus("explanation",.progress)
                    application.sheet = nil
                }.buttonStyle(.borderedProminent)
            }
        }.padding(26).frame(width:760,height:600)
        .onAppear { draft = application.financialDraft.isEmpty ? generated : application.financialDraft }
    }
}

struct IcelandGenerateSheet: View {
    @Bindable var application:IcelandApplicationState
    @State private var style = "小团与慢旅行"
    @State private var constraints = "不自驾；保留已写入的航班、酒店和城市衔接；安排以冬末天气和运营方实际情况为准。"
    @State private var generating = false
    var body: some View {
        VStack(alignment:.leading,spacing:22) {
            IcelandSheetHeader(title:"基于现有计划整理行程",subtitle:"读取旅行草稿与共享预订，生成可编辑的本地示例")
            Form {
                Section("已带入") {
                    LabeledContent("日期") { Text(application.dateSummary) }
                    LabeledContent("同行") { Text("父母与本人，共 3 人") }
                    LabeledContent("目的地") { Text("德国中转 · 丹麦 · 冰岛") }
                    LabeledContent("旅行方式") { Text("当地小团，不自驾") }
                }
                Section("偏好") {
                    Picker("节奏",selection:$style) { Text("小团与慢旅行").tag("小团与慢旅行");Text("少排景点，多留机动").tag("少排景点，多留机动") }
                    TextField("需要保留的安排",text:$constraints,axis:.vertical).lineLimit(3...5)
                }
            }.formStyle(.grouped).scrollContentBackground(.hidden)
            if generating { ProgressView("正在整理示例草稿…").controlSize(.small) }
            HStack {
                Button("取消") { application.sheet = nil }.keyboardShortcut(.cancelAction)
                Spacer()
                Button("生成并回到编辑器") {
                    generating = true
                    Task { @MainActor in
                        try? await Task.sleep(for:.milliseconds(850))
                        application.itineraryGenerated = true
                        if let index = application.days.firstIndex(where:{$0.id == 4}) {
                            application.days[index].note = "\(constraints) \(style == "少排景点，多留机动" ? "当天只保留主要停留点，其余视时间安排。" : "尚未预订的小团继续保留为计划中。")"
                        }
                        application.section = .itinerary;application.sheet = nil
                    }
                }.buttonStyle(.borderedProminent).disabled(generating)
            }
        }.padding(26).frame(width:690,height:590)
    }
}

struct IcelandShareSheet: View {
    @Bindable var model:VisaDoneModel
    @Bindable var application:IcelandApplicationState
    @State private var consent = false
    private var publicText:String {
        IcelandItineraryDocument.text(application,language:application.itineraryLanguage)
    }
    var body: some View {
        VStack(alignment:.leading,spacing:20) {
            IcelandSheetHeader(title:"先看一遍公开版本",subtitle:"请社区帮忙审阅路线，个人文件继续留在申请中")
            HSplitView {
                VStack(alignment:.leading,spacing:20) {
                    Text("允许公开的内容").font(.headline)
                    Picker("行程语言",selection:$application.itineraryLanguage) {
                        ForEach(IcelandItineraryLanguage.allCases) {Text($0.rawValue).tag($0)}
                    }
                    LabeledContent("具体日期") {Text(application.dateSummary)}
                    Divider()
                    Text("保留每天的日期、航班号、交通、活动与酒店名称。").font(.body).lineSpacing(4)
                    Label("仅隐藏 PNR",systemImage:"checkmark").font(.callout)
                    Label("仅隐藏 confirmation code",systemImage:"checkmark").font(.callout)
                    Spacer()
                    Toggle("我已核对公开内容，同意社区评论",isOn:$consent).toggleStyle(.checkbox).font(.system(size:12))
                }.padding(16).frame(minWidth:260,maxWidth:300)
                ScrollView { Text(publicText).font(.system(size:12)).lineSpacing(5).textSelection(.enabled).frame(maxWidth:.infinity,alignment:.leading).padding(18) }
            }
            HStack {
                Button("取消") { application.sheet = nil }.keyboardShortcut(.cancelAction)
                Spacer()
                Button("发布公开版") {
                    model.addPost(title:"三月冰岛，不自驾的行程请大家帮忙看看",body:publicText,region:.schengen)
                    application.itineraryPublic = true
                    application.sheet = .communityReview
                }.buttonStyle(.borderedProminent).disabled(!consent)
            }
        }.padding(26).frame(width:920,height:650)
    }
}

struct IcelandCommunityReviewSheet: View {
    @Bindable var application:IcelandApplicationState
    @State private var dayID:Int? = 5
    @State private var replyTo:Int?
    @State private var reply = ""
    private let comments:[(Int,Int,String,String)] = [
        (0,5,"许知遥","黄金圈后还要走南岸，建议将塞里雅兰瀑布移到回程，减少当天的停留点。"),
        (1,6,"陈屿","冰川和冰洞活动受天气影响，建议写明取消后的机动安排。"),
        (2,-1,"周可","保险需要覆盖德国入境、丹麦中转和最后离境，不只是冰岛段。")
    ]
    private var day:IcelandDay { application.days.first(where:{$0.id == dayID}) ?? application.days[0] }
    var body: some View {
        VStack(spacing:0) {
            HStack { Text("社区行程审阅").font(.title2).fontWeight(.semibold);Spacer() }.padding(20)
            Divider()
            HSplitView {
                List(selection:$dayID) {
                    ForEach(application.days) { day in
                        VStack(alignment:.leading) {
                            Text("第 \(day.id+1) 天")
                            Text(day.title).font(.caption).foregroundStyle(.secondary)
                        }.tag(day.id)
                    }
                }.listStyle(.sidebar).frame(minWidth:180,idealWidth:210,maxWidth:240)
                Form {
                    Section(day.title) {
                        LabeledContent("路线") { Text(day.route) }
                        LabeledContent("交通") { Text(day.transport) }
                        Text(day.note)
                    }
                    ForEach(comments.filter { $0.1 == day.id || $0.1 == -1 },id:\.0) { id,_,name,text in
                        Section("\(name) · \(id == 2 ? "全程" : "修改建议")") {
                            Text(text)
                            if let decision=application.reviewDecisions[id] {
                                LabeledContent("处理") { Text(decision) }
                            } else {
                                HStack {
                                    Button("采纳") { application.acceptAdvice(id) }
                                    Button("暂不采纳") { application.reviewDecisions[id]="暂不采纳" }
                                    Button("回复…") { replyTo=id }
                                }
                            }
                            if let sent=application.reviewReplies[id] { LabeledContent("我的回复") { Text(sent) } }
                            if replyTo == id {
                                TextField("回复",text:$reply)
                                Button("发送") { application.reviewReplies[id]=reply;reply="";replyTo=nil }.disabled(reply.isEmpty)
                            }
                        }
                    }
                }.formStyle(.grouped).scrollContentBackground(.hidden)
            }
            Divider()
            HStack { Spacer();Button("完成") { application.sheet=nil }.keyboardShortcut(.cancelAction) }.padding(16)
        }.frame(width:920,height:650)
    }
}

struct IcelandReportSheet: View {
    @Bindable var application:IcelandApplicationState
    @State private var hasReturn = false
    @State private var consent = false
    var body: some View {
        VStack(alignment:.leading,spacing:20) {
            IcelandSheetHeader(title:"贡献一条匿名进度",subtitle:"公开关键日期，保留个人身份与申请编号")
            Form {
                Section("这条记录") {
                    LabeledContent("签证") { Text("冰岛 · 短期旅游") }
                    LabeledContent("申请地") { Text(application.applicationCity) }
                    DatePicker("实际递交",selection:$application.submittedDate,displayedComponents:[.date])
                    Toggle("护照已收回",isOn:$hasReturn)
                    if hasReturn { DatePicker("收回日期",selection:$application.passportDate,in:application.submittedDate...,displayedComponents:[.date]) }
                }
                Section("公开预览") {
                    Text("冰岛 · 旅游 · \(application.applicationCity)\n递交：\(IcelandApplicationState.shortDate(application.submittedDate))\n后续：\(hasReturn ? IcelandApplicationState.shortDate(application.passportDate) : "未上报收回日期，不纳入处理时长统计")")
                        .font(.system(size:12)).lineSpacing(5)
                    Text("不公开姓名、护照号、申请编号或原始文件。").font(.system(size:11)).foregroundStyle(.secondary)
                    Toggle("同意将以上匿名字段纳入社区统计",isOn:$consent)
                }
            }.formStyle(.grouped).scrollContentBackground(.hidden)
            HStack {
                Button("取消") { application.sheet = nil }.keyboardShortcut(.cancelAction)
                Spacer()
                Button("确认上报") {
                    application.recordContribution(hasReturn:hasReturn)
                    if hasReturn { application.passportReturned = true }
                    application.sheet = nil;application.section = .tracking
                }.buttonStyle(.borderedProminent).disabled(!consent)
            }
        }.padding(26).frame(width:670,height:610)
        .onAppear { hasReturn = application.passportReturned }
    }
}

struct IcelandExperienceSheet: View {
    @Bindable var model:VisaDoneModel
    @Bindable var application:IcelandApplicationState
    @State private var consent = false
    var body: some View {
        VStack(alignment:.leading,spacing:20) {
            IcelandSheetHeader(title:"发布申请经验",subtitle:"编辑并预览公开草稿")
            TextEditor(text:$application.experienceDraft).font(.system(size:14)).lineSpacing(5).padding(8)
            Toggle("我已确认内容可公开，不包含个人证件和订单信息",isOn:$consent).toggleStyle(.checkbox).font(.system(size:12))
            HStack {
                Button("暂存草稿") { application.sheet = nil }.keyboardShortcut(.cancelAction)
                Spacer()
                Button("发布经验帖") {
                    model.addPost(title:"成年学生申请冰岛：资助和行程我是这样整理的",body:application.experienceDraft,region:.schengen)
                    application.experiencePublished = true;application.sheet = nil
                }.buttonStyle(.borderedProminent).disabled(!consent)
            }
        }.padding(26).frame(width:780,height:620)
    }
}
