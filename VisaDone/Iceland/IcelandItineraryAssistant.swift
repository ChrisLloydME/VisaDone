import SwiftUI

struct IcelandItineraryMessage: Identifiable {
    let id=UUID()
    let fromUser:Bool
    let text:String
    var proposal:IcelandItineraryProposal? = nil
}
struct IcelandItineraryProposal: Identifiable {
    let id=UUID()
    let title:String
    let explanation:String
    let before:[IcelandDay]
    let after:[IcelandDay]
    let sourceIDs:[String]
    var applied=false
    var dismissed=false
    var canUndo=true
}

@Observable final class IcelandItineraryAssistant {
    var draft=""
    var scope="当前日期"
    var firstDay=IcelandApplicationState.date(2027,3,5)
    var lastDay=IcelandApplicationState.date(2027,3,8)
    var working=false
    var messages:[IcelandItineraryMessage]=[
        .init(fromUser:false,text:"你的三月行程已带入：13 天、3 人同行、不自驾，航班与住宿都在草稿里。我们可以按天调整，也可以一起检查整段行程。\n\n先选一个日期，再告诉我想保留什么、想改变什么。我会给出修改前后的安排，确认后再写入行程。")
    ]
    func prepare(_ application:IcelandApplicationState) {
        guard messages.count == 1,let day=application.days.first(where:{$0.id == application.selectedDay}) else {return}
        let request="和父母同行，这一天能不能轻松一点？保留酒店和小团接驳。"
        messages.append(.init(fromUser:true,text:request+"\n"+IcelandApplicationState.shortDate(IcelandItineraryDocument.date(day,application))))
        let proposal=makeProposal([day],request:request)
        messages.append(.init(fromUser:false,text:proposal.explanation,proposal:proposal))
    }
    func send(_ application:IcelandApplicationState,prompt:String?=nil) {
        let request=(prompt ?? draft).trimmingCharacters(in:.whitespacesAndNewlines)
        guard !request.isEmpty,!working else { return }
        draft="";working=true
        let selected=application.days.filter { day in
            let date=Calendar.current.date(byAdding:.day,value:day.id,to:application.startDate)!
            if scope == "全程" { return true }
            if scope == "一段日期" { return Calendar.current.startOfDay(for:date) >= Calendar.current.startOfDay(for:firstDay) && Calendar.current.startOfDay(for:date) <= Calendar.current.startOfDay(for:lastDay) }
            return day.id == application.selectedDay
        }
        let targets=selected.isEmpty ? Array(application.days.prefix(1)) : selected
        let dates=targets.map { IcelandApplicationState.shortDate(Calendar.current.date(byAdding:.day,value:$0.id,to:application.startDate)!) }
        messages.append(.init(fromUser:true,text:request+"\n"+(targets.count == 1 ? dates[0] : dates[0]+" — "+dates.last!)))
        let proposal=makeProposal(targets,request:request)
        Task { @MainActor in
            try? await Task.sleep(for:.milliseconds(550))
            messages.append(.init(fromUser:false,text:proposal.explanation,proposal:proposal));working=false
        }
    }
    private func makeProposal(_ days:[IcelandDay],request:String) -> IcelandItineraryProposal {
        var revised=days
        let weather=request.contains("雨") || request.contains("天气") || request.contains("取消")
        let slower=request.contains("轻松") || request.contains("减少") || request.contains("慢")
        let accommodation = !slower && (request.contains("住宿") || request.contains("酒店") || request.contains("衔接"))
        let english=request.contains("英文") || request.contains("双语") || request.contains("签证")
        for i in revised.indices {
            if weather {
                revised[i].note="保留原定交通和住宿。户外活动若因天气取消，改为附近室内参观或在住宿地休息；小团当天安排由运营方确认。"
                revised[i].noteEnglish="Keep the planned transport and overnight accommodation. If outdoor activities are cancelled due to weather, visit a nearby indoor attraction or rest at the hotel. Confirm the guided-tour schedule with the operator."
                revised[i].activities.append(.init(id:UUID().uuidString,time:"备选",title:"天气备选：室内参观或酒店休息",english:"Weather alternative: an indoor visit or rest at the hotel"))
            } else if accommodation {
                revised[i].note="过夜地点：\(revised[i].stay)。交通与入住衔接单独确认；较晚抵达时提前与酒店沟通。保留现有预订，不增加当天的跨城移动。"
                revised[i].noteEnglish="Overnight: \(IcelandItineraryDocument.stay(revised[i])). Confirm transfers and check-in arrangements separately; contact the hotel before a late arrival. Retain the existing accommodation and avoid additional intercity travel."
            } else if english {
                revised[i].note="以行程、交通和住宿分别说明当天安排；未确认的小团标为计划中。具体日期、航班号与酒店名称全部保留。"
                revised[i].noteEnglish="The daily plan lists the route, transport and accommodation separately. Unconfirmed guided tours remain planned activities. Exact dates, flight numbers and hotel names are retained."
            } else {
                let original=revised[i].activities
                if original.count>5 {
                    let keep = revised[i].id == 4 ? [0,1,6,10,11] : Array(0..<min(3,original.count)) + [original.count-2,original.count-1]
                    revised[i].activities=keep.filter {original.indices.contains($0)}.map {original[$0]}
                    revised[i].activities.append(.init(id:UUID().uuidString,time:"机动",title:"其余停留点视时间与体力安排，不作为必达项目",english:"Other stops are optional, subject to available time and the group’s energy"))
                } else {
                    revised[i].activities.append(.init(id:UUID().uuidString,time:"机动",title:"预留休息与交通机动时间",english:"Allow time for rest and transport delays"))
                }
                revised[i].note="减少当天必达停留点，保留已列出的航班、住宿与小团接驳；出发前再按天气和运营方安排确认顺序。"
                revised[i].noteEnglish="Reduce the number of essential stops. Keep the listed flights, hotels and guided-tour transfers; confirm the final order with the operator and weather conditions before departure."
            }
        }
        let explanation=weather ? "我补了一套天气备选，原来的航班与酒店没有移动。冰洞、徒步或极光取消时，行程仍然有明确的休息与室内安排。你可以先核对下方变化，再写入草稿。" : accommodation ? "我把每天的过夜地点和抵达衔接写清楚了，保留现有酒店名称。晚到入住单独提示，避免为了补一个景点又增加跨城移动。" : english ? "我将说明整理成适合行程单阅读的中英文表述，保留具体日期、航班号与住宿名称，未确认的小团仍标为计划中。" : "我先按“不自驾、父母同行”的节奏减少必达项目，把其余地点改为机动停留。航班和酒店保持原安排，中文编辑稿与英文行程单会一起更新。"
        return .init(title:weather ? "补充天气备选" : accommodation ? "核对住宿衔接" : english ? "整理双语行程说明" : "放慢行程节奏",explanation:explanation,before:days,after:revised,sourceIDs:["kirkjufell-morning","glacier-meets-sea","itinerary-template"])
    }
    func apply(_ id:UUID,to application:IcelandApplicationState) {
        guard let m=messages.firstIndex(where:{$0.proposal?.id == id}),let proposal=messages[m].proposal else { return }
        let affected=Set(proposal.after.map(\.id))
        for i in messages.indices where i != m {
            if let earlier=messages[i].proposal,earlier.applied,!affected.isDisjoint(with:earlier.after.map(\.id)) {
                messages[i].proposal?.canUndo=false
            }
        }
        for day in proposal.after { if let i=application.days.firstIndex(where:{$0.id == day.id}) { application.days[i]=day } }
        messages[m].proposal?.applied=true
        application.itineraryGenerated=true
    }
    func undo(_ id:UUID,in application:IcelandApplicationState) {
        guard let m=messages.firstIndex(where:{$0.proposal?.id == id}),let proposal=messages[m].proposal,proposal.canUndo else { return }
        for day in proposal.before { if let i=application.days.firstIndex(where:{$0.id == day.id}) { application.days[i]=day } }
        messages[m].proposal?.applied=false;messages[m].proposal?.dismissed=true
    }
    func dismiss(_ id:UUID) {
        guard let m=messages.firstIndex(where:{$0.proposal?.id == id}) else { return }
        messages[m].proposal?.dismissed=true
    }
}
