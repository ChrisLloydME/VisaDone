import SwiftUI

enum IcelandItineraryLanguage:String,CaseIterable,Identifiable {
    case english="English",bilingual="中英双语"
    var id:String {rawValue}
}
enum IcelandItineraryDocument {
    static func date(_ day:IcelandDay,_ application:IcelandApplicationState) -> Date {
        Calendar.current.date(byAdding:.day,value:day.id,to:application.startDate)!
    }
    static func dateText(_ date:Date) -> String {
        date.formatted(.dateTime.day().month(.abbreviated).year().locale(Locale(identifier:"en_GB")))
    }
    static func safe(_ text:String) -> String {
        text.replacingOccurrences(of:"(?i)\\b(PNR|confirmation[ \\-]*(?:code|number))\\s*[:：#]?\\s*[a-z0-9-]{5,12}\\b",with:"$1: [hidden]",options:.regularExpression)
    }
    static func stay(_ day:IcelandDay) -> String {
        switch day.id {case 0,11:"In transit / overnight flight";case 12:"Arrive home in Shanghai";default:safe(day.stayDetails ?? day.stay)}
    }
    static func transport(_ day:IcelandDay) -> String {
        safe(day.transportDetails ?? day.transportEnglish ?? day.transport)
    }
    static func text(_ application:IcelandApplicationState,language:IcelandItineraryLanguage,days:[IcelandDay]?=nil) -> String {
        let bilingual=language == .bilingual
        let header="TRAVEL ITINERARY\nIceland · Denmark · Germany (transit)\n\(dateText(application.startDate)) – \(dateText(application.endDate)) · 3 travellers\n\n"
        return header+(days ?? application.days).map { day in
            let title="\(dateText(date(day,application))) | \(day.titleEnglish ?? day.title)"
            let english="Route: \(day.routeEnglish ?? day.route)\nTransport: \(transport(day))\nAccommodation: \(stay(day))\n\(day.activities.map { "• " + ($0.english ?? $0.title) }.joined(separator:"\n"))\nNotes: \(day.noteEnglish ?? day.note)\nStatus: \(day.confirmed ? "Confirmed reservations linked" : "Planned; reservations to be confirmed")"
            let chinese=bilingual ? "\n\n\(day.title)\n路线：\(day.route)\n交通：\(day.transport)\n住宿：\(day.stay)\n\(day.activities.map { "• " + $0.title }.joined(separator:"\n"))\n备注：\(day.note)" : ""
            return safe(title+"\n"+english+chinese)
        }.joined(separator:"\n\n────────────────────────\n\n")
    }
}

struct IcelandFullItineraryView:View {
    @Bindable var application:IcelandApplicationState
    @State private var range=false
    @State private var from=IcelandApplicationState.date(2027,3,1)
    @State private var through=IcelandApplicationState.date(2027,3,13)
    private var days:[IcelandDay] { application.days.filter { !range || (Calendar.current.startOfDay(for:IcelandItineraryDocument.date($0,application))>=Calendar.current.startOfDay(for:from) && Calendar.current.startOfDay(for:IcelandItineraryDocument.date($0,application))<=Calendar.current.startOfDay(for:through)) } }
    var body:some View {
        VStack(spacing:0) {
            HStack {
                Picker("语言",selection:$application.itineraryLanguage) { ForEach(IcelandItineraryLanguage.allCases) { Text($0.rawValue).tag($0) } }.fixedSize()
                Toggle("选择日期范围",isOn:$range).toggleStyle(.checkbox)
                if range {
                    DatePicker("从",selection:$from,in:application.startDate...application.endDate,displayedComponents:.date).labelsHidden()
                    Text("至").foregroundStyle(.secondary)
                    DatePicker("至",selection:$through,in:from...max(from,application.endDate),displayedComponents:.date).labelsHidden()
                }
                Spacer()
                Button("导出 PDF…",systemImage:"square.and.arrow.up") { IcelandPDF.exportItinerary(application,language:application.itineraryLanguage,days:days) }
            }.controlSize(.regular).padding(16)
            Divider()
            ScrollView {
                VStack(alignment:.leading,spacing:24) {
                    VStack(alignment:.leading,spacing:8) {
                        Text("TRAVEL ITINERARY").font(.title2.weight(.semibold))
                        Text("Iceland · Denmark · Germany (transit)").font(.headline)
                        Text(IcelandItineraryDocument.dateText(application.startDate)+" — "+IcelandItineraryDocument.dateText(application.endDate)+" · 3 travellers").foregroundStyle(.secondary)
                        Text("保留具体日期、航班号与住宿名称；PNR 和 confirmation code 已隐藏。")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                    ForEach(days) { day in
                        VStack(alignment:.leading,spacing:12) {
                            Divider()
                            HStack(alignment:.firstTextBaseline) {
                                Text(IcelandItineraryDocument.dateText(IcelandItineraryDocument.date(day,application))).font(.headline).monospacedDigit()
                                Spacer()
                                Text(day.confirmed ? "Confirmed" : "Planned").font(.callout).foregroundStyle(.secondary)
                            }
                            Text(day.titleEnglish ?? day.title).font(.title3.weight(.semibold))
                            if application.itineraryLanguage == .bilingual { Text(day.title).foregroundStyle(.secondary) }
                            Grid(alignment:.topLeading,horizontalSpacing:20,verticalSpacing:9) {
                                documentRow("Route",english:day.routeEnglish ?? day.route,chinese:day.route)
                                documentRow("Transport",english:IcelandItineraryDocument.transport(day),chinese:day.transport)
                                documentRow("Accommodation",english:IcelandItineraryDocument.stay(day),chinese:day.stay)
                            }
                            VStack(alignment:.leading,spacing:8) {
                                ForEach(day.activities) { activity in
                                    HStack(alignment:.top,spacing:10) {
                                        Text("•").foregroundStyle(.secondary)
                                        VStack(alignment:.leading,spacing:3) {
                                            Text(IcelandItineraryDocument.safe(activity.english ?? activity.title))
                                            if application.itineraryLanguage == .bilingual { Text(IcelandItineraryDocument.safe(activity.title)).font(.callout).foregroundStyle(.secondary) }
                                        }
                                    }
                                }
                            }
                            Text(IcelandItineraryDocument.safe(day.noteEnglish ?? day.note)).font(.callout).lineSpacing(3)
                            if application.itineraryLanguage == .bilingual { Text(IcelandItineraryDocument.safe(day.note)).font(.callout).foregroundStyle(.secondary).lineSpacing(3) }
                        }
                    }
                    if days.isEmpty { ContentUnavailableView("所选日期没有行程",systemImage:"calendar") }
                }.textSelection(.enabled).padding(28).frame(maxWidth:860,alignment:.leading).frame(maxWidth:.infinity)
            }
        }.onAppear {from=application.startDate;through=application.endDate}
        .onChange(of:application.startDate) {_,_ in from=application.startDate;through=application.endDate}
        .onChange(of:from) {_,value in if through<value {through=value} }
    }
    private func documentRow(_ label:String,english:String,chinese:String) -> some View {
        GridRow(alignment:.top) {
            Text(label).font(.callout).foregroundStyle(.secondary).frame(width:110,alignment:.leading)
            VStack(alignment:.leading,spacing:3) {
                Text(IcelandItineraryDocument.safe(english))
                if application.itineraryLanguage == .bilingual && english != chinese { Text(IcelandItineraryDocument.safe(chinese)).font(.callout).foregroundStyle(.secondary) }
            }.frame(maxWidth:.infinity,alignment:.leading)
        }
    }
}
