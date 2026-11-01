import SwiftUI
import UniformTypeIdentifiers

struct IcelandDocumentsView: View {
    @Bindable var application:IcelandApplicationState
    let posts:[IcelandSourcePost]
    let openPost:(String)->Void
    @State private var importing = false
    @Environment(\.colorScheme) private var scheme
    private var document:IcelandDocument { application.selectedDocument }
    private var visible:[IcelandDocument] {
        application.activeDocuments.filter { application.documentFilter == "全部材料" || $0.status.rawValue == application.documentFilter }
    }
    private var priorities:[IcelandDocument] {
        ["accommodation","insurance","sponsor","student"].compactMap { id in visible.first { $0.id == id } }
    }
    var body: some View {
        Group {
            if application.documentDetailPresented { detail }
            else { checklist }
        }
        .fileImporter(isPresented:$importing,allowedContentTypes:[.pdf]) { result in
            if case .success(let url)=result { importPDF(url) }
        }
        .dropDestination(for:URL.self) { urls,_ in
            guard let url=urls.first,url.pathExtension.lowercased() == "pdf" else { return false }
            importPDF(url);return true
        }
    }
    private var checklist: some View {
        VStack(spacing:0) {
            HStack {
                Picker("显示",selection:$application.documentFilter) {
                    ForEach(["全部材料","待核对","准备中","已就绪"],id:\.self) { Text($0).tag($0) }
                }.labelsHidden().fixedSize()
                Spacer()
                Label("官方原文",systemImage:"building.columns").foregroundStyle(.secondary)
                Label("AI 补充",systemImage:"sparkles").foregroundStyle(.secondary)
            }.font(.callout).padding(.horizontal,20).padding(.vertical,12)
            Divider()
            Form {
                if !priorities.isEmpty {
                    ForEach(Array(priorities.enumerated()),id:\.element.id) { index,doc in
                        materialSection(doc,group:index == 0 ? "本次优先整理" : nil)
                    }
                }
                ForEach(IcelandDocumentGroup.allCases) { group in
                    let entries=visible.filter { $0.group == group && !priorities.map(\.id).contains($0.id) }
                    ForEach(Array(entries.enumerated()),id:\.element.id) { index,doc in
                        materialSection(doc,group:index == 0 ? group.rawValue : nil)
                    }
                }
            }
            .formStyle(.grouped).scrollContentBackground(.hidden)
            .frame(maxWidth:1040).frame(maxWidth:.infinity)
        }
    }
    private func materialSection(_ doc:IcelandDocument,group:String?) -> some View {
        Section {
            if let reference=IcelandOfficialReference.forDocument(doc.id) {
                IcelandOfficialExcerpt(reference:reference).padding(.vertical,12)
            }
            if let insight=IcelandCommunityInsight.forDocument(doc.id) {
                IcelandInsightButton(insight:insight,posts:posts,application:application,openPost:openPost)
                    .padding(.vertical,8)
            }
            if IcelandOfficialReference.forDocument(doc.id) == nil && IcelandCommunityInsight.forDocument(doc.id) == nil {
                Text(doc.summary).font(.body).lineSpacing(5).padding(.vertical,12)
            }
        } header: {
            VStack(alignment:.leading,spacing:12) {
                if let group {
                    Text(group).font(.callout).foregroundStyle(.secondary).padding(.top,8)
                    if group == IcelandDocumentGroup.extra.rawValue {
                        Text("按个人家庭、工作与居住情况选择准备").font(.caption).foregroundStyle(.secondary)
                    }
                }
                HStack(alignment:.firstTextBaseline) {
                    Button {application.openDocument(doc.id)} label: {
                        HStack(spacing:8) {
                            Text(doc.title).font(.system(size:15,weight:.semibold))
                            Image(systemName:"chevron.right").font(.caption.weight(.medium)).foregroundStyle(.secondary)
                        }
                    }.buttonStyle(.plain)
                    Spacer(minLength:16)
                    Label(doc.status.rawValue,systemImage:doc.status.symbol)
                        .font(.callout).foregroundStyle(.secondary)
                }.foregroundStyle(.primary).textCase(nil).padding(.bottom,3)
            }
        }
    }

    private var detail: some View {
        Form {
            Section {
                Button("材料列表",systemImage:"chevron.backward") { application.documentDetailPresented=false }
            }
            Section(document.title) {
                Picker("准备状态",selection:Binding(get:{document.status},set:{application.setStatus(document.id,$0)})) {
                    ForEach(IcelandPreparation.allCases) { Text($0.rawValue).tag($0) }
                }
                if let reference=IcelandOfficialReference.forDocument(document.id) { IcelandOfficialExcerpt(reference:reference) }
                if let insight=IcelandCommunityInsight.forDocument(document.id) {
                    IcelandInsightButton(insight:insight,posts:posts,application:application,openPost:openPost)
                }
            }
            if document.id == "accommodation" { accommodation }
            else if document.id == "sponsor" { sponsorship }
            else if document.id == "bank" { bank }
            else if document.id == "insurance" { insurance }
            else if document.id == "student" {
                Section("个人资料") {
                    LabeledContent("学校在读证明") { Text("已整理") }
                    LabeledContent("学信网学籍报告") { Text("已关联") }
                    LabeledContent("校历与假期安排") { Text("已关联") }
                }
            } else if document.id == "itinerary" {
                Section { Button("打开行程编辑器") { application.section = .itinerary } }
            } else if document.id == "flight" {
                Section("交通预订") {
                    LabeledContent("慕尼黑 → 哥本哈根") { Text(application.flightNumber) }
                    Button("查看行程与航班记录") { application.section = .itinerary }
                }
            } else if document.id == "explanation" || document.id.hasPrefix("community-") {
                Section("个人整理") {
                    if !application.financialDraft.isEmpty { Text(application.financialDraft).textSelection(.enabled) }
                    Button("编辑说明…") { application.sheet = .finance }
                }
            }
            if document.id != "accommodation" && !document.files.isEmpty {
                Section("关联文件") { ForEach(document.files,id:\.self) { Label($0,systemImage:"doc") } }
            }
            Section { Toggle("已核对并准备完成",isOn:Binding(get:{document.status == .ready},set:{application.setStatus(document.id,$0 ? .ready : .progress)})) }
        }.formStyle(.grouped).scrollContentBackground(.hidden).frame(maxWidth:920).frame(maxWidth:.infinity)
    }
    private func importPDF(_ url:URL) {
        let access=url.startAccessingSecurityScopedResource()
        defer { if access { url.stopAccessingSecurityScopedResource() } }
        application.importedBooking=try? Data(contentsOf:url)
        application.importedBookingName=url.lastPathComponent
        application.bookingChecked=false;application.sheet = .documentCheck
    }
    @ViewBuilder private var accommodation: some View {
        Section("住宿文件") {
            ForEach(Array(document.files.enumerated()),id:\.offset) { index,name in
                LabeledContent {
                    if index == 0 { Button("检查…") { application.sheet = .documentCheck } }
                    else { Text("待整理").foregroundStyle(.secondary) }
                } label: { Label(name,systemImage:"doc.richtext") }
            }
            Button("导入 PDF…",systemImage:"square.and.arrow.down") { importing=true }
        }
        Section("与本次旅行对照") {
            LabeledContent("同行") { Text("本人、母亲与父亲 · 3 人") }
            LabeledContent("示例订单") { Text("显示 1 位住客") }
            Button("检查示例订单…") {
                application.importedBooking=nil;application.importedBookingName="hotel-booking-sample.pdf";application.sheet = .documentCheck
            }
        }
    }
    private var sponsorship: some View {
        Section("我的资助资料") {
            LabeledContent("费用承担") { Text(application.funding) }
            ForEach([("employment","工作与收入证明"),("bank","银行流水"),("letter","签署的资助声明"),("identity","资助人身份证明")],id:\.0) { id,title in
                Toggle(title,isOn:Binding(get:{application.sponsorReady.contains(id)},set:{ value in
                    if value { application.sponsorReady.insert(id) } else { application.sponsorReady.remove(id) }
                    application.setStatus("sponsor",application.sponsorReady.count == 4 ? .ready : .progress)
                }))
            }
            Button("起草资助说明…") { application.sheet = .finance }
        }
    }
    private var bank: some View {
        Section("我的资金记录") {
            ForEach([("savings","余额宝转回","¥12,800"),("gift","生日礼金","¥5,000"),("allowance","生活费结余","¥3,200")],id:\.0) { id,title,amount in
                Toggle(isOn:Binding(get:{application.confirmedTransactions.contains(id)},set:{value in
                    if value { application.confirmedTransactions.insert(id) } else { application.confirmedTransactions.remove(id) }
                })) { LabeledContent(title) { Text(amount).foregroundStyle(.secondary) } }
            }
            Button("生成英文说明…") { application.sheet = .finance }
        }
    }
    private var insurance: some View {
        Section("我的保单") {
            LabeledContent("申根入境") { Text(IcelandApplicationState.shortDate(application.schengenEntryDate)) }
            LabeledContent("申根离境") { Text(IcelandApplicationState.shortDate(application.schengenExitDate)) }
            LabeledContent("示例保额") { Text("€50,000") }
            LabeledContent("保障区域") { Text("申根地区") }
        }
    }
}
