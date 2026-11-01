import SwiftUI

struct IcelandItineraryConversation:View {
    @Bindable var application:IcelandApplicationState
    let posts:[IcelandSourcePost]
    let openPost:(String)->Void
    @Bindable var assistant:IcelandItineraryAssistant
    @State private var sourceProposal:UUID?
    @State private var expandedDays:Set<Int>=[4]
    var body:some View {
        VStack(spacing:0) {
            VStack(alignment:.leading,spacing:10) {
                HStack {
                    Label("与 AI 一起规划",systemImage:"sparkles").font(.headline)
                    Spacer()
                    Text("\(assistant.messages.filter { $0.proposal?.applied == true }.count) 次修改已采纳").font(.caption).foregroundStyle(.secondary)
                }
                Picker("讨论范围",selection:$assistant.scope) {
                    Text("当前日期").tag("当前日期");Text("一段日期").tag("一段日期");Text("全程").tag("全程")
                }.pickerStyle(.segmented)
                if assistant.scope == "一段日期" {
                    HStack {
                        DatePicker("从",selection:$assistant.firstDay,in:application.startDate...application.endDate,displayedComponents:.date).labelsHidden()
                        Text("至").foregroundStyle(.secondary)
                        DatePicker("至",selection:$assistant.lastDay,in:assistant.firstDay...max(assistant.firstDay,application.endDate),displayedComponents:.date).labelsHidden()
                    }.controlSize(.small)
                } else {
                    Text(assistant.scope == "全程" ? application.dateSummary : IcelandApplicationState.shortDate(IcelandItineraryDocument.date(application.days.first { $0.id == application.selectedDay } ?? application.days[0],application)))
                        .font(.caption).foregroundStyle(.secondary)
                }
            }.padding(16)
            Divider()
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment:.leading,spacing:24) {
                        ForEach(assistant.messages) { message in
                            messageView(message).id(message.id)
                        }
                        if assistant.working { ProgressView("正在整理调整方案…").controlSize(.small) }
                        Color.clear.frame(height:1).id("latest")
                    }.padding(18)
                }.onChange(of:assistant.messages.count) {_,_ in withAnimation {proxy.scrollTo("latest",anchor:.bottom)} }
            }
            Divider()
            VStack(alignment:.leading,spacing:10) {
                Menu("从这些问题开始",systemImage:"text.bubble") {
                    Button("和父母同行，安排轻松一点") {assistant.send(application,prompt:"和父母同行，把这段安排改得轻松一点，保留原来的酒店。")}
                    Button("下雨或冰洞取消时怎么办？") {assistant.send(application,prompt:"如果天气不好或冰洞取消，给我一个不自驾的备选安排。")}
                    Button("核对住宿与交通衔接") {assistant.send(application,prompt:"帮我核对这段的住宿与交通衔接。")}
                    Button("整理成适合签证的英文说明") {assistant.send(application,prompt:"帮我整理成适合签证行程单的双语说明。")}
                }.menuStyle(.borderlessButton).fixedSize().disabled(assistant.working)
                HStack(alignment:.bottom,spacing:8) {
                    TextField("想怎么改？例如：保留酒店，减少当天的停留点",text:$assistant.draft,axis:.vertical)
                        .textFieldStyle(.roundedBorder).lineLimit(2...5)
                    Button {assistant.send(application)} label: {Image(systemName:"arrow.up").frame(width:20,height:22)}
                        .buttonStyle(.borderedProminent).disabled(assistant.draft.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty || assistant.working)
                        .keyboardShortcut(.return,modifiers:.command)
                        .help("发送修改要求（⌘Return）")
                }
                Text("修改会先供你核对，采纳后同步到完整行程单。").font(.caption).foregroundStyle(.secondary)
            }.padding(14)
        }.onAppear {assistant.prepare(application)}
        .onChange(of:assistant.firstDay) {_,date in if assistant.lastDay<date {assistant.lastDay=date} }
    }
    private func messageView(_ message:IcelandItineraryMessage) -> some View {
        VStack(alignment:.leading,spacing:12) {
            Text(message.fromUser ? "你" : "VisaDone AI").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
            Text(message.text).font(.body).lineSpacing(4).textSelection(.enabled).fixedSize(horizontal:false,vertical:true)
            if let proposal=message.proposal {
                VStack(alignment:.leading,spacing:12) {
                    Divider()
                    Text(proposal.title).font(.headline)
                    ForEach(Array(zip(proposal.before,proposal.after)),id:\.0.id) { before,after in
                        DisclosureGroup(isExpanded:Binding(get:{expandedDays.contains(after.id)},set:{value in if value {expandedDays.insert(after.id)} else {expandedDays.remove(after.id)} })) {
                            VStack(alignment:.leading,spacing:10) {
                                Text("修改前").font(.caption).foregroundStyle(.secondary)
                                Text(before.activities.map(\.title).joined(separator:" · ")+"\n"+before.note).font(.callout).foregroundStyle(.secondary).textSelection(.enabled)
                                Text("修改后").font(.caption.weight(.semibold))
                                Text(after.activities.map(\.title).joined(separator:" · ")+"\n"+after.note).font(.callout).lineSpacing(3).textSelection(.enabled)
                                Text(after.noteEnglish ?? "").font(.callout).foregroundStyle(.secondary).textSelection(.enabled)
                            }.padding(.vertical,8)
                        } label: {
                            Text(IcelandApplicationState.shortDate(IcelandItineraryDocument.date(after,application))+" · "+after.title).font(.callout)
                        }
                    }
                    HStack {
                        if proposal.dismissed {Text("已保留原稿").font(.callout).foregroundStyle(.secondary)}
                        else if proposal.applied {
                            Label("已写入行程",systemImage:"checkmark").font(.callout)
                            Spacer()
                            Button("撤销") {assistant.undo(proposal.id,in:application)}.disabled(!proposal.canUndo)
                        } else {
                            Button("采纳修改") {assistant.apply(proposal.id,to:application)}.buttonStyle(.borderedProminent)
                            Button("保留原稿") {assistant.dismiss(proposal.id)}
                        }
                    }.controlSize(.small)
                    Button("社区参考 · \(proposal.sourceIDs.count) 篇帖子",systemImage:"text.bubble") {sourceProposal=proposal.id}
                        .buttonStyle(.link).font(.caption)
                        .popover(isPresented:Binding(get:{sourceProposal == proposal.id},set:{if !$0 {sourceProposal=nil}})) {
                            if let insight=IcelandCommunityInsight.forDocument("itinerary") {
                                IcelandInsightPopover(insight:insight,posts:posts.filter {proposal.sourceIDs.contains($0.id)},application:application) { id in sourceProposal=nil;openPost(id) }
                            }
                        }
                }
            }
        }.frame(maxWidth:.infinity,alignment:.leading)
    }
}
