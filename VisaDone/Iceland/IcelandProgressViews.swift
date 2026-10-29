import SwiftUI
import Charts

struct IcelandSubmissionView: View {
    @Bindable var application:IcelandApplicationState
    var body: some View {
        Form {
            Section("预约") {
                DatePicker("预约日期",selection:$application.appointment,displayedComponents:[.date])
                LabeledContent("办理地点") { Text("上海 · VFS 冰岛签证申请中心") }
                Toggle("已完成官方预约",isOn:$application.appointmentRecorded)
                IcelandResource("打开 VFS Global",url:IcelandApplicationState.vfsURL)
            }
            Section("递交材料") {
                LabeledContent("已准备") { Text("\(application.readyCount) / \(application.activeDocuments.count) 项") }
                Button("查看材料清单") { application.section = .documents }
                Button("导出打印清单…",systemImage:"printer") { IcelandPDF.exportChecklist(application) }
                Button("编辑补充说明…") { application.sheet = .finance }
            }
            Section("递交记录") {
                DatePicker("实际递交日期",selection:$application.submittedDate,displayedComponents:[.date])
                LabeledContent("记录状态") { Text(application.submitted ? "已递交" : "未递交") }
                Button(application.submitted ? "查看申请进度" : "记录已递交") {
                    application.submitted=true;application.timelineStatus="已递交";application.section = .tracking
                }.buttonStyle(.borderedProminent)
            }
        }.formStyle(.grouped).scrollContentBackground(.hidden).frame(maxWidth:820).frame(maxWidth:.infinity)
    }
}

struct IcelandTrackingView: View {
    @Bindable var application:IcelandApplicationState
    @State private var newest = true
    private var cases:[IcelandCase] { application.cases.sorted { newest ? $0.submitted > $1.submitted : $0.submitted < $1.submitted } }
    private var bins:[(String,Int)] {
        [("0–7天",0...7),("8–14天",8...14),("15–21天",15...21),("22–28天",22...28),("29–35天",29...35),("36天以上",36...1000)].map { title,range in
            (title,application.durations.filter { range.contains($0) }.count)
        }
    }
    var body: some View {
        Form {
            Section("冰岛 · 旅游 · 上海") {
                Chart(Array(bins.enumerated()),id:\.offset) { entry in
                    BarMark(x:.value("用时",entry.element.0),y:.value("案例数",entry.element.1))
                        .foregroundStyle(Color.accentColor)
                }.frame(height:165)
                LabeledContent("已上报案例") { Text("\(application.cases.count) 条") }
                LabeledContent("收回护照的中位数") { Text("\(application.median) 天") }
                LabeledContent("80% 已完成案例") { Text("\(application.percentile80) 天内") }
            }
            Section("最近案例") {
                Picker("递交日期",selection:$newest) { Text("由近到远").tag(true);Text("由远到近").tag(false) }
                Table(cases) {
                    TableColumn("递交") { Text(IcelandApplicationState.shortDate($0.submitted)) }
                    TableColumn("申请地",value:\.city)
                    TableColumn("护照收回") { row in Text(row.returned.map { IcelandApplicationState.shortDate($0) } ?? "未上报") }
                    TableColumn("用时") { row in Text(row.duration.map { "\($0) 天" } ?? "—") }
                }.frame(height:220)
            }
            Section { Text("虚构社区样本，仅展示统计方式。未上报收回日期的记录不纳入时长统计。").font(.caption).foregroundStyle(.secondary) }
                Section("我的申请") {
                    LabeledContent("状态") { Text(application.submitted ? application.timelineStatus : "尚未递交") }
                    if application.submitted {
                        LabeledContent("递交日期") { Text(IcelandApplicationState.shortDate(application.submittedDate)) }
                        Picker("更新记录",selection:$application.timelineStatus) {
                            ForEach(["已递交","处理中 · 自行录入","护照已寄回","已收到护照"],id:\.self) { Text($0).tag($0) }
                        }
                    } else { Button("记录递交…") { application.section = .submission } }
                }
                Section("共享进度") {
                    Button(application.contributed ? "补充匿名记录…" : "匿名上报…") { application.sheet = .report }
                    Text("公开申请地和关键日期，不含身份信息。").font(.caption).foregroundStyle(.secondary)
                }
        }
        .formStyle(.grouped).scrollContentBackground(.hidden)
        .onChange(of:application.timelineStatus) { _,value in if value == "已收到护照" { application.passportReturned=true } }
    }
}

struct IcelandResultView: View {
    @Bindable var model:VisaDoneModel
    @Bindable var application:IcelandApplicationState
    var body: some View {
        Form {
            Section("申请结果") {
                Picker("结果",selection:$application.result) { ForEach(["获签","拒签","撤回"],id:\.self) { Text($0).tag($0) } }
                DatePicker("护照收回日期",selection:$application.passportDate,displayedComponents:[.date])
                Toggle("已收回护照",isOn:$application.passportReturned)
                Button(application.completed ? "已完成" : "保存并完成申请") {
                    application.completed=true;application.timelineStatus="已收到护照"
                }.buttonStyle(.borderedProminent).disabled(!application.passportReturned || application.completed)
            }
            Section("社区反馈") {
                Button(application.experiencePublished ? "经验已发布" : "整理经验帖…") {
                    application.makeExperienceDraft();application.sheet = .experience
                }.disabled(!application.completed || application.experiencePublished)
                Button("补充匿名处理时间…") { application.sheet = .report }
                if application.experiencePublished { Button("在社区查看") { model.section = .discovery } }
            }
        }.formStyle(.grouped).scrollContentBackground(.hidden).frame(maxWidth:820).frame(maxWidth:.infinity)
    }
}
