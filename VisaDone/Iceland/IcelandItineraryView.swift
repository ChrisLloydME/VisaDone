import SwiftUI

struct IcelandItineraryView: View {
    @Bindable var application:IcelandApplicationState
    let posts:[IcelandSourcePost]
    let openPost:(String)->Void
    @State private var preview = false
    private var index:Int { application.days.firstIndex { $0.id == application.selectedDay } ?? 0 }
    private var date:Date { Calendar.current.date(byAdding:.day,value:application.days[index].id,to:application.startDate)! }
    var body: some View {
        Group {
            if preview { IcelandPDFView(document:IcelandPDF.itinerary(application)) }
            else { editor }
        }
        .toolbar {
            ToolbarItemGroup {
                Button { application.sheet = .generateItinerary } label: { Label("整理行程",systemImage:"sparkles") }
                Button { application.sheet = application.itineraryPublic ? .communityReview : .share } label: { Label("社区审阅",systemImage:"person.2") }
                Menu {
                    Toggle("文档预览",isOn:$preview)
                    Button("导出 PDF…") { IcelandPDF.exportItinerary(application) }
                } label: { Label("导出",systemImage:"square.and.arrow.up") }
            }
        }
    }
    private var editor: some View {
        Form {
            Section("行程日期") {
                Picker("日期",selection:$application.selectedDay) {
                    ForEach(application.days) { day in
                        let dayDate=Calendar.current.date(byAdding:.day,value:day.id,to:application.startDate)!
                        Text(IcelandApplicationState.shortDate(dayDate) + " · " + day.title).tag(Int?.some(day.id))
                    }
                }
                TextField("当天计划",text:$application.days[index].title)
                TextField("路线",text:$application.days[index].route)
                Picker("预订状态",selection:$application.days[index].confirmed) {
                    Text("计划中").tag(false)
                    Text("已确认预订").tag(true)
                }
            }
            if [4,5,6,7,8].contains(application.days[index].id) {
                Section {
                    GeometryReader { geometry in
                        Image(application.days[index].id == 4 ? "coverIcelandKirkjufell" : "coverIcelandGlacier")
                            .resizable().scaledToFill().frame(width:geometry.size.width,height:155).clipped()
                    }.frame(height:155)
                }
            }
            Section("行程安排") {
                ForEach($application.days[index].activities) { $activity in
                    TextField("活动",text:$activity.title,axis:.vertical)
                        .lineLimit(1...3)
                        .draggable(activity.id)
                        .dropDestination(for:String.self) { ids,_ in
                            guard let source=ids.first,
                                  let from=application.days[index].activities.firstIndex(where:{$0.id == source}),
                                  let to=application.days[index].activities.firstIndex(where:{$0.id == activity.id}) else { return false }
                            application.days[index].activities.move(fromOffsets:IndexSet(integer:from),toOffset:from < to ? to+1 : to)
                            return true
                        }
                        .contextMenu {
                            Button("移除活动",role:.destructive) { application.days[index].activities.removeAll { $0.id == activity.id } }
                        }
                }
                .onMove { from,to in application.days[index].activities.move(fromOffsets:from,toOffset:to) }
                Button("添加活动",systemImage:"plus") {
                    application.days[index].activities.append(.init(id:UUID().uuidString,time:"待定",title:"新增活动"))
                }
            }
            Section("交通与住宿") {
                TextField("交通",text:$application.days[index].transport,axis:.vertical).lineLimit(1...3)
                TextField("住宿",text:$application.days[index].stay,axis:.vertical).lineLimit(1...3)
            }
            Section("备注") {
                TextField("行程说明",text:$application.days[index].note,axis:.vertical).lineLimit(2...5).labelsHidden()
            }
            assistanceSections
        }.formStyle(.grouped).scrollContentBackground(.hidden).frame(maxWidth:980).frame(maxWidth:.infinity)
    }
    @ViewBuilder private var assistanceSections: some View {
            Section("行程建议") {
                if let insight=IcelandCommunityInsight.forDocument("itinerary") {
                    IcelandInsightButton(insight:insight,posts:posts,application:application,openPost:openPost)
                }
                Button(application.appliedWinterAdvice ? "已应用调整" : "应用调整") { application.acceptAdvice(0) }
                    .disabled(application.appliedWinterAdvice)
            }
            Section("预订核对") {
                LabeledContent("主要目的地") { Text("冰岛") }
                LabeledContent("首次申根入境") { Text("德国") }
                if application.checkingFlight { ProgressView("正在比对…").controlSize(.small) }
                else {
                    Button("核对航班记录") {
                        application.checkingFlight=true
                        Task { @MainActor in
                            try? await Task.sleep(for:.milliseconds(650))
                            application.checkingFlight=false;application.flightChangeDetected=true
                        }
                    }
                }
                if application.flightChangeDetected {
                    LabeledContent("航班号更新") { Text("LH2440") }
                    Button(application.flightSynced ? "已同步到行程" : "更新行程与说明") { application.syncFlight() }.disabled(application.flightSynced)
                }
            }
            Section("社区审阅") {
                Button(application.itineraryPublic ? "查看 3 条建议…" : "分享公开版本…") {
                    application.sheet=application.itineraryPublic ? .communityReview : .share
                }
            }
    }
}
