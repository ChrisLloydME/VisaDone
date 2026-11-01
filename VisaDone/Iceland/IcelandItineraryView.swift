import SwiftUI

struct IcelandItineraryView: View {
    @Bindable var application:IcelandApplicationState
    let posts:[IcelandSourcePost]
    let openPost:(String)->Void
    @State private var mode = "协作规划"
    @State private var settings = false
    private var index:Int { application.days.firstIndex { $0.id == application.selectedDay } ?? 0 }
    private var date:Date { Calendar.current.date(byAdding:.day,value:application.days[index].id,to:application.startDate)! }
    var body: some View {
        VStack(spacing:0) {
            HStack(spacing:16) {
                Picker("工作区",selection:$mode) {
                    Text("协作规划").tag("协作规划")
                    Text("完整行程单").tag("完整行程单")
                }.pickerStyle(.segmented).frame(width:230)
                Spacer()
                Button(application.dateSummary,systemImage:"calendar") {settings=true}
                    .popover(isPresented:$settings) {
                        Form {
                            DatePicker("出发日期",selection:$application.startDate,displayedComponents:.date)
                            LabeledContent("总天数") {Text("\(application.days.count) 天")}
                            Text("整体平移现有行程，活动、航班号和住宿安排保留。").font(.caption).foregroundStyle(.secondary)
                        }.formStyle(.grouped).frame(width:350,height:170)
                    }
                Button("社区审阅",systemImage:"person.2") {application.sheet=application.itineraryPublic ? .communityReview : .share}
            }.padding(14)
            Divider()
            if mode == "完整行程单" {IcelandFullItineraryView(application:application)}
            else {
                HSplitView {
                    editor.frame(minWidth:350,idealWidth:520,maxWidth:.infinity)
                    IcelandItineraryConversation(application:application,posts:posts,openPost:openPost,assistant:application.itineraryAssistant)
                        .frame(minWidth:310,idealWidth:365,maxWidth:460)
                }
            }
        }
        .onChange(of:application.startDate) {previous,value in
            application.shiftItineraryReferences(from:previous,to:value)
            application.endDate=Calendar.current.date(byAdding:.day,value:max(0,application.days.count-1),to:value)!
            application.itineraryAssistant.firstDay=value
            application.itineraryAssistant.lastDay=application.endDate
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
            Section("行程安排") {
                ForEach($application.days[index].activities) { $activity in
                    VStack(alignment:.leading,spacing:5) {
                        TextField("活动",text:$activity.title,axis:.vertical).labelsHidden()
                        TextField("English activity",text:Binding(get:{activity.english ?? ""},set:{activity.english=$0}),axis:.vertical)
                            .font(.callout).foregroundStyle(.secondary).labelsHidden()
                    }.frame(maxWidth:.infinity,alignment:.leading)
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
                TextField("住宿",text:Binding(get:{application.days[index].stay},set:{application.days[index].stay=$0;application.days[index].stayDetails=nil}),axis:.vertical).lineLimit(1...3)
            }
            Section("备注") {
                TextField("行程说明",text:$application.days[index].note,axis:.vertical).lineLimit(2...5).labelsHidden()
            }
            Section("英文行程说明") {
                TextField("English title",text:Binding(get:{application.days[index].titleEnglish ?? ""},set:{application.days[index].titleEnglish=$0}))
                TextField("Route",text:Binding(get:{application.days[index].routeEnglish ?? ""},set:{application.days[index].routeEnglish=$0}),axis:.vertical)
                TextField("Transport",text:Binding(get:{application.days[index].transportEnglish ?? ""},set:{application.days[index].transportEnglish=$0;application.days[index].transportDetails=nil}),axis:.vertical)
                TextField("Notes",text:Binding(get:{application.days[index].noteEnglish ?? ""},set:{application.days[index].noteEnglish=$0}),axis:.vertical).lineLimit(2...6)
            }
        }.formStyle(.grouped).scrollContentBackground(.hidden).frame(maxWidth:980).frame(maxWidth:.infinity)
    }
}
