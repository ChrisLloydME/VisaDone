import SwiftUI

struct IcelandVisaSelectionFields:View {
    @Bindable var application:IcelandApplicationState
    var body:some View {
        Picker("签证类别",selection:$application.visaCategory) {
            ForEach(IcelandApplicationState.visaCategories,id:\.self) {Text($0).tag($0)}
        }.pickerStyle(.menu)
        Picker("申请地点",selection:$application.applicationCity) {
            ForEach(IcelandApplicationState.applicationCities,id:\.self) {Text("中国 · " + $0).tag($0)}
        }.pickerStyle(.menu)
    }
}
struct IcelandApplicantPreferences:View {
    @Bindable var application:IcelandApplicationState
    var body:some View {
        Picker("职业情况",selection:$application.background) {
            ForEach(["在职人员","自由职业","在读学生","退休人员","暂未就业"],id:\.self) {Text($0).tag($0)}
        }.pickerStyle(.menu)
        Picker("同行安排",selection:$application.travelParty) {
            ForEach(["独自出行","与家人同行","与朋友同行","其他"],id:\.self) {Text($0).tag($0)}
        }.pickerStyle(.menu)
        if application.travelParty != "独自出行" {
            Stepper("出行人数（含本人）：\(application.travelerCount)",value:$application.travelerCount,in:2...8)
        }
        Picker("费用承担",selection:$application.funding) {
            ForEach(["自行承担","家人资助","单位承担","共同承担"],id:\.self) {Text($0).tag($0)}
        }.pickerStyle(.menu)
        .onChange(of:application.travelParty) {_,value in
            application.travelerCount=value == "独自出行" ? 1 : max(2,application.travelerCount)
        }
    }
}

struct IcelandDestinationIntroduction:View {
    var body:some View {
        ScrollView {
            VStack(alignment:.leading,spacing:22) {
                VStack(alignment:.leading,spacing:9) {
                    Text("冰岛与申根区").font(.headline)
                    Text("冰岛属于申根区。统一申根签证可用于在申根成员国之间旅行；短期停留通常以任意 180 天内累计不超过 90 天计算。")
                        .font(.body).lineSpacing(4)
                }
                VStack(alignment:.leading,spacing:9) {
                    Text("什么时候向冰岛申请？").font(.headline)
                    Text("如果这次只去冰岛，或冰岛是多个申根目的地中停留时间最长的一站，应向冰岛递交申请。若几个国家停留时间相同，则按首先到访的申根国家确定申请地。")
                        .font(.body).lineSpacing(4)
                    Text("通常应在合法居住地所属的领区申请。多国旅行时，先确认主要目的地，再选择递交城市。")
                        .font(.callout).foregroundStyle(.secondary).lineSpacing(3)
                }
                VStack(alignment:.leading,spacing:9) {
                    Text("申根区有哪些国家？").font(.headline)
                    Text("奥地利、比利时、保加利亚、克罗地亚、捷克、丹麦、爱沙尼亚、芬兰、法国、德国、希腊、匈牙利、冰岛、意大利、拉脱维亚、列支敦士登、立陶宛、卢森堡、马耳他、荷兰、挪威、波兰、葡萄牙、罗马尼亚、斯洛伐克、斯洛文尼亚、西班牙、瑞典、瑞士。")
                        .font(.callout).foregroundStyle(.secondary).lineSpacing(4)
                }
                VStack(alignment:.leading,spacing:9) {
                    Text("官方资料").font(.headline)
                    Link("冰岛政府 · 申请条件",destination:IcelandApplicationState.governmentURL)
                    Link("冰岛政府 · 申根成员国",destination:URL(string:"https://island.is/en/do-you-need-a-visa")!)
                    Link("VFS · 冰岛驻华使馆签证资料",destination:URL(string:"https://www.vfsglobal.com/one-pager/iceland/china/english/index.html")!)
                }.font(.callout)
            }.textSelection(.enabled).padding(22)
        }
    }
}
