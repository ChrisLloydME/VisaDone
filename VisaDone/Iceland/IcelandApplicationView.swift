import SwiftUI

struct IcelandApplicationView: View {
    @Bindable var model:VisaDoneModel
    @Bindable var application:IcelandApplicationState
    @State private var sourcePost:DiscoveryPost?
    private var sourcePosts:[IcelandSourcePost] {
        model.posts.map { .init(id:$0.id,title:$0.title,author:$0.author.name,
            excerpt:$0.summary ?? String($0.body.prefix(110)),image:$0.coverImage,time:$0.timeLabel,fullText:$0.body) }
    }
    private func openSourcePost(_ id:String) { sourcePost=model.posts.first { $0.id == id } }
    var body: some View {
        HStack(alignment:.top,spacing:14) {
            persistentDrawer.frame(width:290)
            Group {
                if application.isCreated {
                    switch application.section {
                    case .overview:IcelandOverviewView(application:application)
                    case .documents:IcelandDocumentsView(application:application,posts:sourcePosts,openPost:openSourcePost)
                    case .itinerary:IcelandItineraryView(application:application,posts:sourcePosts,openPost:openSourcePost)
                    case .submission:IcelandSubmissionView(application:application)
                    case .tracking:IcelandTrackingView(application:application)
                    case .result:IcelandResultView(model:model,application:application)
                    }
                } else { hub }
            }.frame(maxWidth:.infinity,maxHeight:.infinity)
        }
        .padding(14)
        .sheet(item:$application.sheet) { sheet in IcelandApplicationSheet(model:model,application:application,sheet:sheet) }
        .sheet(item:$sourcePost) { post in PostDetailView(post:post,model:model) }
    }
    // Same native glass surface as the destination drawer, permanently expanded.
    // There is deliberately no grabber, toggle button, drag gesture or resize handle.
    private var persistentDrawer: some View {
        VStack(alignment:.leading,spacing:0) {
            HStack(spacing:11) {
                Image("visaFlagIS").resizable().scaledToFill().frame(width:34,height:34).clipShape(Circle())
                VStack(alignment:.leading,spacing:4) {
                    Text(application.isCreated ? application.applicationTitle : "冰岛 Iceland").font(.system(size:21,weight:.semibold))
                    Text(application.isCreated ? application.dateSummary : "北欧 · 申根区").font(.caption).foregroundStyle(.secondary)
                }
            }.padding(22)
            Divider().padding(.horizontal,18)
            if application.isCreated {
                List(selection:Binding<IcelandSection?>(get:{application.section},set:{if let value=$0 { application.section=value }})) {
                    ForEach(IcelandSection.allCases) { section in
                        Label(section.rawValue,systemImage:section.symbol).padding(.vertical,7).tag(section)
                    }
                }.listStyle(.inset).scrollContentBackground(.hidden).padding(.horizontal,8).padding(.top,8)
            } else {
                IcelandDestinationIntroduction()
            }
            VStack(alignment:.leading,spacing:12) {
                if application.isCreated {
                    ProgressView(value:application.overallProgress)
                    Text("\(application.readyCount) / \(application.activeDocuments.count) 项个人材料就绪").font(.caption).foregroundStyle(.secondary)
                }
                Divider()
                Button { application.isPresented=false } label: { Label("国家与地区",systemImage:"chevron.backward") }
                    .buttonStyle(.borderless)
            }.padding(22)
        }
        .frame(maxHeight:.infinity,alignment:.top)
        .glassEffect(.regular,in:.rect(cornerRadius:26))
        .accessibilityLabel("常驻申请导航")
    }
    private var hub: some View {
        Form {
            Section {
                GeometryReader { geometry in
                    Image("coverIcelandVestrahorn").resizable().scaledToFill()
                        .frame(width:geometry.size.width,height:165).clipped()
                }.frame(height:165)
            }
            Section("冰岛 Iceland") {
                IcelandVisaSelectionFields(application:application)
                LabeledContent("递交渠道") { Text("VFS Global") }
                LabeledContent("处理机构") { Text("冰岛驻北京大使馆") }
            }
            Section("新申请") {
                LabeledContent("申请对象") { Text("成年申请人") }
                TextField("姓名",text:$application.applicantName,prompt:Text("填写姓名"))
                IcelandApplicantPreferences(application:application)
                Button("填写申请信息…") { application.sheet = .create }.buttonStyle(.borderedProminent)
            }
            Section("官方资料") {
                IcelandResource("冰岛政府 · 签证申请",url:IcelandApplicationState.governmentURL)
                IcelandResource("VFS Global · 申请入口",url:IcelandApplicationState.vfsURL)
                IcelandResource("个人旅游签证材料清单",url:IcelandApplicationState.checklistURL)
            }
            Section { Button("返回欧洲目的地") { application.isPresented = false } }
        }
        .formStyle(.grouped).scrollContentBackground(.hidden)
        .frame(maxWidth:780).frame(maxWidth:.infinity)
    }
}

struct IcelandOverviewView: View {
    @Bindable var application:IcelandApplicationState
    var body: some View {
        Form {
            Section("申请总览") {
                LabeledContent("目的地") { Text("冰岛 · " + application.visaCategory) }
                LabeledContent("旅行日期") { Text(application.dateSummary) }
                LabeledContent("递交地点") { Text(application.applicationCity) }
                LabeledContent("状态") { Text(application.completed ? "已完成" : (application.submitted ? application.timelineStatus : "材料准备中")) }
            }
            Section("材料准备") {
                LabeledContent("已准备") {
                    HStack { ProgressView(value:application.readiness).frame(width:140);Text("\(application.readyCount) / \(application.activeDocuments.count)").monospacedDigit() }
                }
                LabeledContent("住宿预订证明") { Button("核对住客信息") { application.openDocument("accommodation") } }
                LabeledContent("资金与资助材料") { Button("继续整理") { application.openDocument(application.funding == "自行承担" ? "bank" : "sponsor") } }
                LabeledContent("旅行医疗保险") { Button("核对覆盖区间") { application.openDocument("insurance") } }
            }
            Section("申请人信息") {
                LabeledContent("姓名") {Text(application.applicantName.isEmpty ? "未填写" : application.applicantName)}
                LabeledContent("个人情况") {Text(application.background)}
                LabeledContent("国籍与居住地") {Text(application.nationality + " · " + application.residence)}
                LabeledContent("同行安排") {Text(application.travelParty + " · \(application.travelerCount) 人")}
                LabeledContent("费用承担") {Text(application.funding)}
                Button("编辑申请信息…") {application.sheet = .create}
            }
            Section("旅行与递交") {
                LabeledContent("行程草稿") { Button("查看 \(application.days.count) 天行程") { application.section = .itinerary } }
                LabeledContent("签证预约") { Button(application.appointmentRecorded ? "查看预约记录" : "记录预约…") { application.section = .submission } }
                LabeledContent("申根入境") { Text(IcelandApplicationState.shortDate(application.schengenEntryDate)) }
                LabeledContent("申根离境") { Text(IcelandApplicationState.shortDate(application.schengenExitDate)) }
            }
        }
        .formStyle(.grouped).scrollContentBackground(.hidden)
        .frame(maxWidth:820).frame(maxWidth:.infinity)
    }
}

struct IcelandHeading: View {
    let text:String
    init(_ text:String) { self.text=text }
    var body: some View { Text(text).font(.headline) }
}
struct IcelandFact: View {
    let title:String
    let value:String
    init(_ title:String,_ value:String) { self.title=title;self.value=value }
    var body: some View { LabeledContent(title) { Text(value).textSelection(.enabled) } }
}
struct IcelandResource: View {
    let title:String
    let url:URL
    init(_ title:String,url:URL) { self.title=title;self.url=url }
    var body: some View { Link(title,destination:url) }
}
struct IcelandSheetHeader: View {
    let title:String
    let subtitle:String
    var body: some View {
        VStack(alignment:.leading,spacing:6) {
            Text(title).font(.title2).fontWeight(.semibold)
            Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
        }.frame(maxWidth:.infinity,alignment:.leading)
    }
}
