import SwiftUI

struct IcelandApplicationSheet: View {
    @Bindable var model:VisaDoneModel
    @Bindable var application:IcelandApplicationState
    let sheet:IcelandSheet
    var body: some View {
        Group {
            switch sheet {
            case .create: IcelandCreateSheet(application:application)
            case .documentCheck: IcelandBookingCheckSheet(application:application)
            case .note: IcelandCommunityNoteSheet(application:application)
            case .finance: IcelandFinanceSheet(application:application)
            case .generateItinerary: IcelandGenerateSheet(application:application)
            case .share: IcelandShareSheet(model:model,application:application)
            case .communityReview: IcelandCommunityReviewSheet(application:application)
            case .report: IcelandReportSheet(application:application)
            case .experience: IcelandExperienceSheet(model:model,application:application)
            }
        }
    }
}

struct IcelandCreateSheet: View {
    @Bindable var application:IcelandApplicationState
    @State private var step = 0
    private let titles = ["申请人与旅行","同行与费用","确认这次申请"]
    var body: some View {
        VStack(alignment:.leading,spacing:20) {
            IcelandSheetHeader(title:titles[step],subtitle:"冰岛短期旅游签证 · 第 \(step+1) 步，共 3 步")
            ProgressView(value:Double(step+1),total:3).controlSize(.small)
            Form {
                if step == 0 {
                    Section("申请人") {
                        LabeledContent("护照") { Text("中国大陆普通护照") }
                        LabeledContent("年龄") { Text("成年人 · 18 岁及以上") }
                        LabeledContent("居住地") { Text("中国大陆") }
                        TextField("申请城市",text:$application.applicationCity)
                        LabeledContent("申请类别") { Text("短期旅游 · Type C") }
                    }
                    Section("预计旅行日期") {
                        DatePicker("出发",selection:$application.startDate,displayedComponents:[.date])
                        DatePicker("返回",selection:$application.endDate,in:application.startDate...,displayedComponents:[.date])
                    }
                } else if step == 1 {
                    Section("个人情况") {
                        LabeledContent("身份") { Text("成年在读大学生") }
                        LabeledContent("同行人") { Text("母亲、父亲 · 共 3 人") }
                        Picker("费用承担",selection:$application.funding) {
                            Text("母亲资助").tag("母亲资助")
                            Text("自行承担").tag("自行承担")
                        }
                        LabeledContent("出行方式") { Text("国际航班 + 当地小团，不自驾") }
                    }
                    Section {
                        Text("个人申请表与资金材料分别管理，三人共享航班、住宿与旅行行程。未成年人监护材料不会加入这份成年学生清单。")
                            .font(.system(size:12)).foregroundStyle(.secondary)
                    }
                } else {
                    Section("这次申请") {
                        LabeledContent("目的地") { Text("冰岛 · 申根短期旅游") }
                        LabeledContent("递交地") { Text(application.applicationCity) }
                        LabeledContent("个人情况") { Text("成年学生 · \(application.funding)") }
                        LabeledContent("日期") { Text(application.dateSummary) }
                        LabeledContent("同行") { Text("父母与本人，3 人") }
                    }
                    Section("创建后") {
                        Text("根据此案例整理材料，保留官方要求、适用条件和社区建议之间的区别。行程将载入提供的旅行草稿。")
                            .font(.system(size:12)).foregroundStyle(.secondary)
                    }
                }
            }.formStyle(.grouped).scrollContentBackground(.hidden)
            HStack {
                Button("取消") { application.sheet = nil }.keyboardShortcut(.cancelAction)
                Spacer()
                if step > 0 { Button("上一步") { step -= 1 } }
                Button(step == 2 ? "创建申请" : "继续") {
                    if step == 2 { application.create() } else { step += 1 }
                }.buttonStyle(.borderedProminent).keyboardShortcut(.defaultAction)
                .disabled(application.applicationCity.trimmingCharacters(in:.whitespaces).isEmpty)
            }
        }.padding(26).frame(width:650,height:580)
    }
}

struct IcelandBookingCheckSheet: View {
    @Bindable var application:IcelandApplicationState
    private var highlight:String? {
        guard application.bookingChecked else { return nil }
        switch application.selectedCheck { case "hotel":return "Property:";case "dates":return "Check-in:";default:return "Guest name:" }
    }
    var body: some View {
        VStack(spacing:0) {
            HStack {
                VStack(alignment:.leading,spacing:5) {
                    Text("住宿订单核验").font(.title2).fontWeight(.semibold)
                    Text(application.importedBookingName).foregroundStyle(.secondary)
                }
                Spacer()
            }.padding(20)
            Divider()
            HSplitView {
                IcelandPDFView(document:IcelandPDF.booking(application),highlight:highlight).frame(minWidth:450,maxWidth:.infinity)
                Form {
                    Section("关联申请") {
                        LabeledContent("同行人数") { Text("3 人") }
                        LabeledContent("住宿") { Text("雷克雅未克") }
                    }
                    if application.checkingBooking {
                        Section { ProgressView("正在检查…").controlSize(.small) }
                    } else if !application.bookingChecked {
                        Section { Button("检查示例订单") {
                            application.checkingBooking=true
                            Task { @MainActor in
                                try? await Task.sleep(for:.milliseconds(850))
                                application.checkingBooking=false;application.bookingChecked=true
                            }
                        }.buttonStyle(.borderedProminent) }
                    } else {
                        Section("核验项目") {
                            Picker("定位文本",selection:$application.selectedCheck) {
                                Text("住宿名称与地址").tag("hotel")
                                Text("入住与退房日期").tag("dates")
                                Text("住客信息").tag("guests")
                            }.pickerStyle(.radioGroup).labelsHidden()
                        }
                        Section("检查结果") {
                            if application.importedBooking == nil {
                                LabeledContent("住宿信息") { Text("已找到") }
                                LabeledContent("日期") { Text("与该段行程一致") }
                                LabeledContent("住客") { Text("显示 1 人，共 3 人同行") }
                            } else { Text("已导入 PDF，字段需人工核对。") }
                        }
                        Section("社区建议") {
                            Text("可联系住宿方补充同行人姓名。此项为个案经验。")
                            Button("查看相关注释…") { application.sheet = .note }
                        }
                    }
                }
                .formStyle(.grouped).scrollContentBackground(.hidden)
                .frame(minWidth:320,idealWidth:350,maxWidth:400)
            }
            Divider()
            HStack { Spacer();Button("完成") { application.sheet=nil }.keyboardShortcut(.cancelAction) }.padding(16)
        }.frame(width:1000,height:680)
    }
}

struct IcelandCommunityNoteSheet: View {
    @Bindable var application:IcelandApplicationState
    @State private var sameExperience = false
    @State private var feedback = false
    var body: some View {
        VStack(alignment:.leading,spacing:22) {
            IcelandSheetHeader(title:"订单上的同行人姓名",subtitle:"社区注释 · 住宿预订证明")
            Label("个案经验，尚未充分验证",systemImage:"person.2").font(.system(size:12)).foregroundStyle(.secondary)
            Text("有申请者分享：订单仅显示预订人的名字时，曾被要求补充其他住客信息。可以先联系住宿方，确认能否显示这次同行的三位住客。")
                .font(.system(size:15)).lineSpacing(6)
            Divider()
            IcelandFact("适用范围","冰岛短期旅游 · 中国申请地的个案分享")
            IcelandFact("经验来源","虚构社区案例 · 用于展示经验补充机制")
            IcelandFact("与官方要求的关系","官方清单要求住宿覆盖停留期间；本注释不将住客姓名扩展成统一必交条件。")
            IcelandResource("核对官方住宿要求",url:IcelandApplicationState.checklistURL)
            HStack {
                Button(sameExperience ? "已记录类似经历" : "我有类似经历") { sameExperience.toggle() }
                Button(feedback ? "反馈已记录" : "反馈信息") { feedback = true }
            }
            Spacer()
            HStack { Text("修订记录 · 2027年1月 · 补充适用条件").font(.system(size:11)).foregroundStyle(.secondary);Spacer();Button("完成") { application.sheet = nil }.keyboardShortcut(.cancelAction) }
        }.padding(28).frame(width:650,height:570)
    }
}
