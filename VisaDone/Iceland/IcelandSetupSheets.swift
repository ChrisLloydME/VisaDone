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
    var body: some View {
        VStack(alignment:.leading,spacing:18) {
            IcelandSheetHeader(title:application.isCreated ? "编辑申请信息" : "新建冰岛申请",subtitle:"填写成年申请人的个人信息与旅行安排")
            Form {
                Section("签证与递交") {IcelandVisaSelectionFields(application:application)}
                Section("个人信息") {
                    TextField("姓名",text:$application.applicantName,prompt:Text("中文姓名"))
                    TextField("护照姓氏",text:$application.familyName,prompt:Text("Surname / Family name"))
                    TextField("护照名字",text:$application.givenName,prompt:Text("Given name(s)"))
                    DatePicker("出生日期",selection:$application.birthDate,in:...Date(),displayedComponents:.date)
                    Picker("国籍",selection:$application.nationality) {
                        ForEach(["中国","英国","美国","其他"],id:\.self) {Text($0).tag($0)}
                    }.pickerStyle(.menu)
                    TextField("护照号码",text:$application.passportNumber,prompt:Text("填写护照号码"))
                }
                Section("居住与联系") {
                    Picker("居住地",selection:$application.residence) {
                        ForEach(["中国大陆","中国香港","中国澳门","其他国家或地区"],id:\.self) {Text($0).tag($0)}
                    }.pickerStyle(.menu)
                    TextField("居住城市",text:$application.residenceCity,prompt:Text("填写城市"))
                    TextField("联系邮箱",text:$application.email,prompt:Text("name@example.com"))
                }
                Section("旅行安排") {
                    DatePicker("出发日期",selection:$application.startDate,displayedComponents:.date)
                    DatePicker("返回日期",selection:$application.endDate,in:application.startDate...,displayedComponents:.date)
                    IcelandApplicantPreferences(application:application)
                }
            }.formStyle(.grouped).scrollContentBackground(.hidden)
            HStack {
                Button("取消") {application.sheet=nil}.keyboardShortcut(.cancelAction)
                Spacer()
                Button(application.isCreated ? "保存" : "创建申请") {
                    if application.isCreated {application.sheet=nil} else {application.create()}
                }.buttonStyle(.borderedProminent).keyboardShortcut(.defaultAction)
            }
        }.padding(24).frame(width:700,height:740)
        .onChange(of:application.startDate) {_,value in if application.endDate<value {application.endDate=value} }
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
                        LabeledContent("出行人数") { Text("\(application.travelerCount) 人") }
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
                                LabeledContent("住客") { Text("显示 1 人，行程共 \(application.travelerCount) 人") }
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
