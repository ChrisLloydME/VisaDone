import SwiftUI

// A single local application owns the visible preparation, itinerary and timeline.
enum IcelandSection: String, CaseIterable, Identifiable {
    case overview = "申请总览", documents = "材料准备", itinerary = "旅行行程", submission = "预约递交", tracking = "进度追踪", result = "结果回馈"
    var id: String { rawValue }
    var symbol: String {
        switch self {
        case .overview: "square.grid.2x2"
        case .documents: "doc.text"
        case .itinerary: "calendar"
        case .submission: "tray.and.arrow.up"
        case .tracking: "clock"
        case .result: "checkmark.seal"
        }
    }
}
enum IcelandTraveler: String, CaseIterable, Identifiable {
    case student = "本人 · 成年学生", mother = "母亲 · 资助人", father = "父亲 · 同行人"
    var id: String { rawValue }
}
enum IcelandRequirement: String, CaseIterable {
    case official = "官方清单", conditional = "按个人情况", suggested = "辅助建议"
}
enum IcelandPreparation: String, CaseIterable, Identifiable {
    case notStarted = "未开始", progress = "准备中", ready = "已就绪", review = "待核对"
    var id: String { rawValue }
    var symbol: String {
        switch self { case .notStarted: "circle"; case .progress: "circle.lefthalf.filled"; case .ready: "checkmark.circle"; case .review: "exclamationmark.circle" }
    }
}
enum IcelandDocumentGroup: String, CaseIterable, Identifiable {
    case identity = "身份与表格", travel = "交通与住宿", insurance = "旅行保险", finance = "资金与个人情况", extra = "补充材料"
    var id: String { rawValue }
}
struct IcelandDocument: Identifiable {
    let id: String
    let title: String
    let english: String
    let group: IcelandDocumentGroup
    let requirement: IcelandRequirement
    var status: IcelandPreparation
    let summary: String
    let files: [String]
}
struct IcelandActivity: Identifiable, Equatable, Decodable {
    let id: String
    var time: String
    var title: String
    var english: String? = nil
}
struct IcelandDay: Identifiable, Decodable {
    let id: Int
    var title: String
    var route: String
    var transport: String
    var stay: String
    var confirmed: Bool
    var note: String
    var activities: [IcelandActivity]
    var titleEnglish: String? = nil
    var routeEnglish: String? = nil
    var transportEnglish: String? = nil
    var noteEnglish: String? = nil
    var stayDetails: String? = nil
    var transportDetails: String? = nil
}
struct IcelandCase: Identifiable {
    let id: Int
    let submitted: Date
    let returned: Date?
    let city: String
    var duration: Int? { returned.map { Calendar.current.dateComponents([.day], from: submitted, to: $0).day ?? 0 } }
}
enum IcelandSheet: String, Identifiable {
    case create, documentCheck, note, finance, generateItinerary, share, communityReview, report, experience
    var id: String { rawValue }
}

@Observable final class IcelandApplicationState {
    var isPresented = false
    var isCreated = false
    var section: IcelandSection = .overview
    var traveler: IcelandTraveler = .student
    var sheet: IcelandSheet?
    var applicationCity = "上海"
    var visaCategory = "旅游 · 申根 C 类"
    var applicantName = ""
    var familyName = ""
    var givenName = ""
    var passportNumber = ""
    var nationality = "中国"
    var residence = "中国大陆"
    var residenceCity = ""
    var email = ""
    var birthDate = IcelandApplicationState.date(1998,6,15)
    var background = "在职人员"
    var funding = "自行承担"
    var travelParty = "独自出行"
    var travelerCount = 1
    static let visaCategories = ["旅游 · 申根 C 类","商务 · 申根 C 类","探亲访友 · 申根 C 类","文化或体育活动 · 申根 C 类"]
    static let applicationCities = ["北京","上海","广州","杭州","南京","福州","西安","武汉","成都","重庆"]
    var applicationTitle:String {"冰岛" + (visaCategory.components(separatedBy:" · ").first ?? "") + "签证"}
    var startDate = IcelandApplicationState.date(2027,3,1)
    var endDate = IcelandApplicationState.date(2027,3,13)
    var selectedDocumentID: String? = "accommodation"
    var documentFilter = "全部材料"
    var documentDetailPresented = false
    var acceptedInsightIDs: Set<String> = []
    var documents = IcelandApplicationState.documentFixtures
    var importedBooking: Data?
    var importedBookingName = "hotel-booking-sample.pdf"
    var checkingBooking = false
    var bookingChecked = false
    var selectedCheck = "guests"
    var sponsorReady: Set<String> = ["employment", "identity"]
    var confirmedTransactions: Set<String> = ["savings", "gift", "allowance"]
    var financialDraft = ""
    var selectedDay: Int? = 4
    var days = IcelandApplicationState.dayFixtures
    var flightNumber = "LH4122 / VL2440"
    var checkingFlight = false
    var flightChangeDetected = false
    var flightSynced = false
    var appliedWinterAdvice = false
    var itineraryAssistant = IcelandItineraryAssistant()
    var itineraryLanguage: IcelandItineraryLanguage = .bilingual
    var itineraryGenerated = false
    var itineraryPublic = false
    var reviewDecisions: [Int: String] = [:]
    var reviewReplies: [Int: String] = [:]
    var appointment = IcelandApplicationState.date(2027,1,20)
    var appointmentRecorded = false
    var submittedDate = IcelandApplicationState.date(2027,1,20)
    var submitted = false
    var timelineStatus = "材料准备中"
    var passportDate = IcelandApplicationState.date(2027,2,5)
    var passportReturned = false
    var result = "获签"
    var completed = false
    var experiencePublished = false
    var experienceDraft = ""
    var cases = IcelandApplicationState.caseFixtures
    var contributed = false

    static let checklistURL = URL(string: "https://www.vfsglobal.com/one-pager/iceland/china/english/pdf/Individual-Tourism-checklist-EN.pdf")!
    static let governmentURL = URL(string: "https://island.is/en/get-a-visa")!
    static let vfsURL = URL(string: "https://visa.vfsglobal.com/chn/en/isl/")!
    var activeDocuments: [IcelandDocument] {
        documents.filter { doc in
            if funding != "家人资助", ["sponsor", "relationship"].contains(doc.id) { return false }
            if background != "在读学生",doc.id == "student" {return false}
            if background == "在读学生",doc.id == "employment" {return false}
            return true
        }
    }
    var readyCount: Int { activeDocuments.filter { $0.status == .ready }.count }
    var reviewCount: Int { activeDocuments.filter { $0.status == .review }.count }
    var selectedDocument: IcelandDocument { documents.first { $0.id == selectedDocumentID } ?? documents[0] }
    var dateSummary: String { Self.shortDate(startDate) + "–" + endDate.formatted(.dateTime.month().day().locale(Locale(identifier:"zh_Hans_CN"))) }
    var schengenEntryDate: Date { Calendar.current.date(byAdding:.day,value:1,to:startDate)! }
    var schengenExitDate: Date { Calendar.current.date(byAdding:.day,value:-1,to:endDate)! }
    var tripDays: Int { max(1,(Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 10)+1) }
    var readiness: Double { Double(readyCount)/Double(max(1,activeDocuments.count)) }
    var returnedCases: [IcelandCase] { cases.filter { $0.returned != nil } }
    var durations: [Int] { returnedCases.compactMap(\.duration).sorted() }
    var median: Int { durations.isEmpty ? 0 : (durations[(durations.count-1)/2]+durations[durations.count/2])/2 }
    var percentile80: Int { durations.isEmpty ? 0 : durations[max(0,Int(ceil(Double(durations.count)*0.8))-1)] }
    var publicItinerary: String {
        days.map { day in "第 \(day.id+1) 天 · \(day.title)\n\(day.route)\n\(day.confirmed ? "已确认交通或住宿" : "计划中，尚未预订")\n\(day.note)" }.joined(separator: "\n\n")
    }
    func openDocument(_ id: String) { selectedDocumentID = id; documentDetailPresented = true; section = .documents; traveler = .student }
    func toggleInsight(_ insight:IcelandCommunityInsight) {
        if acceptedInsightIDs.contains(insight.id) {
            acceptedInsightIDs.remove(insight.id)
            documents.removeAll { $0.id == "community-" + insight.id }
            if selectedDocumentID == "community-" + insight.id { selectedDocumentID = insight.documentID;documentDetailPresented = false }
        } else {
            acceptedInsightIDs.insert(insight.id)
            if insight.action == .material {
                documents.append(.init(id:"community-"+insight.id,title:insight.materialTitle,english:"Community-informed preparation",group:.extra,
                    requirement:.suggested,status:.progress,summary:insight.summary,files:[]))
            }
        }
    }
    func setStatus(_ id: String, _ value: IcelandPreparation) {
        guard let index = documents.firstIndex(where: { $0.id == id }) else { return }
        documents[index].status = value
    }
    func create() {
        isCreated = true; section = .overview; sheet = nil
        days = IcelandApplicationState.dayFixtures
        if tripDays < days.count { days = Array(days.prefix(tripDays)) }
        else if tripDays > days.count {
            for index in days.count..<min(tripDays,30) {
                days.append(.init(id: index,title: "机动与返程安排",route: "待确认",transport: "待补充",stay: "待补充",confirmed: false,note: "补充与实际预订对应的安排。",activities: []))
            }
        }
    }
    func shiftItineraryReferences(from previous:Date,to next:Date) {
        let calendar=Calendar.current
        let offset=calendar.dateComponents([.day],from:previous,to:next).day ?? 0
        guard offset != 0,let regex=try? NSRegularExpression(pattern:"([0-9]{1,2})\\s*月\\s*([0-9]{1,2})\\s*日") else {return}
        func shifted(_ text:String) -> String {
            let original=text as NSString
            let result=NSMutableString(string:text)
            for match in regex.matches(in:text,range:NSRange(location:0,length:original.length)).reversed() {
                let month=Int(original.substring(with:match.range(at:1))) ?? 3
                let day=Int(original.substring(with:match.range(at:2))) ?? 1
                let date=Self.date(calendar.component(.year,from:previous),month,day)
                let updated=calendar.date(byAdding:.day,value:offset,to:date)!
                result.replaceCharacters(in:match.range,with:"\(calendar.component(.month,from:updated))月\(calendar.component(.day,from:updated))日")
            }
            return result as String
        }
        for i in days.indices {
            days[i].note=shifted(days[i].note)
            for a in days[i].activities.indices {days[i].activities[a].title=shifted(days[i].activities[a].title)}
        }
    }
    func syncFlight() {
        flightNumber = "LH2440"; flightSynced = true
        for index in days.indices {
            days[index].transport = days[index].transport.replacingOccurrences(of:"LH4122 / VL2440",with:"LH2440")
            days[index].transportDetails=days[index].transportDetails?.replacingOccurrences(of:"LH4122 / VL2440",with:"LH2440")
            days[index].transportEnglish=days[index].transportEnglish?.replacingOccurrences(of:"LH4122 / VL2440",with:"LH2440")
            days[index].note = days[index].note.replacingOccurrences(of:"LH4122 / VL2440 为原草稿中的航班标识。",with:"航班标识已更新为 LH2440。")
            for activity in days[index].activities.indices {
                days[index].activities[activity].english=days[index].activities[activity].english?.replacingOccurrences(of:"LH4122 / VL2440",with:"LH2440")
                days[index].activities[activity].title = days[index].activities[activity].title.replacingOccurrences(of:"LH4122 / VL2440",with:"LH2440")
            }
        }
        if !financialDraft.isEmpty { financialDraft += "\n\nThe Munich–Copenhagen flight reference has been updated to LH2440." }
    }
    func acceptAdvice(_ id: Int) {
        reviewDecisions[id] = "已采纳"
        if id == 0, let index = days.firstIndex(where: { $0.id == 5 }) {
            days[index].note = "黄金圈当天只安排三个主要停留点；冬季小团顺序以运营方与天气为准。"
            if let activity = days[index].activities.first(where:{$0.title.contains("塞里雅兰")}),
               let later = days.firstIndex(where:{$0.id == 7}) {
                days[index].activities.removeAll { $0.id == activity.id }
                days[later].activities.insert(.init(id:activity.id,time:"沿途",title:activity.title,english:activity.english),at:max(0,days[later].activities.count-1))
            }
            days[index].noteEnglish="Keep three main stops on the Golden Circle day. Confirm the winter tour sequence with the operator and adapt to the weather."
            appliedWinterAdvice = true
        }
        if id == 1, let index = days.firstIndex(where: { $0.id == 6 }) {
            days[index].note = "为冰洞活动预留天气机动时间，取消时返回住宿地。"
            days[index].noteEnglish="Allow flexibility for the ice cave excursion; return to the accommodation if it is cancelled due to weather."
        }
        if id == 2 { setStatus("insurance", .review) }
    }
    func recordContribution(hasReturn: Bool) {
        cases.append(.init(id: (cases.map(\.id).max() ?? 0)+1,submitted: submittedDate,returned: hasReturn ? passportDate : nil,city: applicationCity))
        contributed = true
    }
    func makeExperienceDraft() {
        experienceDraft = "这次在\(applicationCity)申请冰岛旅游签证，和父母三人同行。\n\n我是成年在读学生，主要由母亲资助。准备时把自己的在读情况、资助人的材料和共享的行程分别整理，避免混在一起。\n\n住宿订单最值得提前核对：日期、地址和同行人信息最好逐项看一遍。冬季不自驾，小团未确认的项目我保留为计划中。\n\n申请结果：\(result)。以上只是我的个人经历，具体材料仍请核对适用的官方清单。"
    }
    static func shortDate(_ date:Date) -> String {
        date.formatted(.dateTime.year().month().day().locale(Locale(identifier:"zh_Hans_CN")))
    }
    var overallProgress: Double { completed ? 1 : (submitted ? (passportReturned ? 0.9 : 0.65) : readiness*0.25) }
    var progressStage:Int { completed ? 3 : (submitted ? 2 : 0) }
    static func date(_ y: Int,_ m: Int,_ d: Int) -> Date {
        Calendar(identifier: .gregorian).date(from: DateComponents(year:y,month:m,day:d,hour:12))!
    }
    static let documentFixtures: [IcelandDocument] = [
        .init(id:"form",title:"申根申请表",english:"Application form",group:.identity,requirement:.official,status:.ready,summary:"打印完整表格，核对申请人信息并亲笔签署。",files:["application-form.pdf"]),
        .init(id:"passport",title:"护照与照片",english:"Passport & photograph",group:.identity,requirement:.official,status:.ready,summary:"核对护照有效期、签发时间、空白页与近期证件照。",files:["passport-copy.pdf","photo.jpg"]),
        .init(id:"identity",title:"身份证与户口簿",english:"Identity & household registration",group:.identity,requirement:.official,status:.ready,summary:"整理身份证正反面及户口簿内容页复印件。",files:["identity-documents.pdf"]),
        .init(id:"flight",title:"往返与申根内交通",english:"Transportation reservations",group:.travel,requirement:.official,status:.ready,summary:"将国际航班、欧洲中转和冰岛段交通放在同一条时间线上。",files:["flight-reservations.pdf"]),
        .init(id:"accommodation",title:"住宿预订证明",english:"Accommodation proof",group:.travel,requirement:.official,status:.review,summary:"住宿预订应覆盖预计停留期间；核对每晚入住地与行程衔接。",files:["hotel-booking-sample.pdf","south-coast-stay.pdf","copenhagen-stay.pdf"]),
        .init(id:"itinerary",title:"每日旅行行程",english:"Daily travel itinerary",group:.travel,requirement:.official,status:.progress,summary:"逐日说明申根全程的地点、交通与住宿，区分预订和旅行计划。",files:["winter-itinerary-draft.pdf"]),
        .init(id:"insurance",title:"申根旅行医疗保险",english:"Travel medical insurance",group:.insurance,requirement:.official,status:.review,summary:"核对申根全程、医疗保障和不低于 30,000 欧元的保额；留意保单时区。",files:["travel-insurance.pdf"]),
        .init(id:"bank",title:"本人银行流水",english:"Personal bank statements",group:.finance,requirement:.official,status:.progress,summary:"整理连续近期银行对账单，必要时补充资金来源说明。",files:["bank-statement-sample.pdf"]),
        .init(id:"student",title:"在读与假期证明",english:"Student status",group:.finance,requirement:.conditional,status:.ready,summary:"成年学生的个案材料：在读证明、学籍报告、校历和准假情况分别核对。",files:["enrollment-certificate.pdf","chsi-report.pdf","academic-calendar.pdf"]),
        .init(id:"employment",title:"个人身份与收入证明",english:"Occupation and income",group:.finance,requirement:.conditional,status:.progress,summary:"根据个人职业情况整理相应身份与收入资料。",files:[]),
        .init(id:"sponsor",title:"资助相关材料",english:"Financial sponsorship",group:.finance,requirement:.conditional,status:.progress,summary:"按实际资助关系整理资助人收入、流水、身份文件和资助声明。",files:["sponsor-employment.pdf","sponsor-identity.pdf"]),
        .init(id:"relationship",title:"亲属关系辅助证明",english:"Relationship evidence",group:.extra,requirement:.suggested,status:.ready,summary:"本案例用于解释资助关系；不将未成年人条款直接套用于成年申请人。",files:["relationship-evidence.pdf"]),
        .init(id:"marriage",title:"结婚证与婚姻关系材料",english:"Marriage and family ties",group:.extra,requirement:.suggested,status:.notStarted,summary:"已婚申请人可按情况补充结婚证复印件，说明家庭关系；涉及配偶资助时与对应资金资料一起整理。",files:["marriage-certificate-copy.pdf"]),
        .init(id:"property",title:"房产与长期居住资料",english:"Property and residence",group:.extra,requirement:.suggested,status:.progress,summary:"按情况整理房产证或不动产权证复印件，补充说明国内资产与长期居住情况。",files:["property-certificate-copy.pdf"]),
        .init(id:"social-insurance",title:"社保缴纳记录",english:"Social insurance contributions",group:.extra,requirement:.suggested,status:.notStarted,summary:"整理近期社保缴纳记录，与工作单位、在职情况及收入资料对应。",files:["social-insurance-record.pdf"]),
        .init(id:"return-work",title:"返岗与准假说明",english:"Employment and return-to-work arrangements",group:.extra,requirement:.suggested,status:.progress,summary:"在准假说明中列明旅行时间、休假安排与预计返岗时间，补充说明国内工作联系。",files:["leave-and-return-to-work.pdf"]),
        .init(id:"passport-spares",title:"护照备用复印件与领取资料",english:"Spare passport copies and collection",group:.extra,requirement:.suggested,status:.progress,summary:"额外准备护照信息页复印件，与递交收据、领取通知分开留存，方便后续核对。",files:["passport-biodata-spares.pdf", "passport-collection-receipt.pdf"]),
        .init(id:"identity-spares",title:"身份证、户口簿备用复印件",english:"Spare identity and household copies",group:.extra,requirement:.suggested,status:.ready,summary:"保留身份证正反面、户口簿户主页及本人页等备用复印件，正式递交份数仍按官方清单核对。",files:["identity-card-spares.pdf", "hukou-spares.pdf"]),
        .init(id:"explanation",title:"补充说明信",english:"Supporting explanation",group:.extra,requirement:.suggested,status:.progress,summary:"简要说明在读、费用承担与特殊资金变动，保留可核对的事实。",files:[])
    ]
    static let dayFixtures: [IcelandDay] = {
        guard let url = Bundle.main.url(forResource:"itinerary",withExtension:"json"),
              let data = try? Data(contentsOf:url),
              let days = try? JSONDecoder().decode([IcelandDay].self,from:data),!days.isEmpty else {
            return [.init(id:0,title:"旅行草稿",route:"上海 → 冰岛",transport:"航班与小团",stay:"待确认",confirmed:false,note:"待载入行程",activities:[])]
        }
        return days
    }()
    static let caseFixtures: [IcelandCase] = {
        let values = [5,6,6,7,7,7] + Array(repeating:12,count:10) + Array(repeating:14,count:9) + Array(repeating:15,count:5) + Array(repeating:16,count:7) + Array(repeating:17,count:3) + Array(repeating:18,count:3) + [19,19,20,20,21,25,25,25,25,26,26,27,27,28,28,30,32,35,38]
        return values.enumerated().map { i,d in
            let submitted = Calendar.current.date(byAdding:.day,value:-(i%27),to:date(2026,12,20))!
            return .init(id:i,submitted:submitted,returned:Calendar.current.date(byAdding:.day,value:d,to:submitted),city:"上海")
        }
    }()
}
