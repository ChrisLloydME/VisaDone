import AppKit
import SwiftUI
import PDFKit

struct IcelandOfficialReference: Identifiable {
    let id:String
    let title:String
    let page:Int
    let start:String
    let end:String
    static func forDocument(_ id:String) -> Self? {
        switch id {
        case "form": .init(id:id,title:"第1项 · 申请表",page:0,start:"1. Harmonized",end:"2. The travel")
        case "passport": .init(id:id,title:"第2–3项 · 护照与照片",page:0,start:"2. The travel",end:"4. Travel medical")
        case "insurance": .init(id:id,title:"第4项 · 旅行医疗保险",page:0,start:"4. Travel medical",end:"5. Proof of Transportation")
        case "flight": .init(id:id,title:"第5项 · 交通证明",page:0,start:"5. Proof of Transportation",end:"6. Travel itinerary")
        case "itinerary": .init(id:id,title:"第6项 · 旅行行程",page:0,start:"6. Travel itinerary",end:"7. Proof of accommodation")
        case "accommodation": .init(id:id,title:"第7项 · 住宿证明",page:0,start:"7. Proof of accommodation",end:"8. Chinese Identity")
        case "identity": .init(id:id,title:"第8–9项 · 身份证与户口簿",page:0,start:"8. Chinese Identity",end:"10. Proof of sufficient")
        case "bank": .init(id:id,title:"第10项 · 资金证明",page:0,start:"10. Proof of sufficient",end:"11. Proof of employment")
        case "sponsor": .init(id:id,title:"第11项 · 身份与资金来源",page:0,start:"11. Proof of employment",end:"12. For volunteer")
        default:nil
        }
    }
}

@MainActor @Observable final class IcelandOfficialChecklist {
    static let shared=IcelandOfficialChecklist()
    var document:PDFDocument?
    var loading=false
    var error=false
    func load() async {
        guard document == nil,!loading else { return }
        loading=true;error=false
        defer { loading=false }
        do {
            let (data,response)=try await URLSession.shared.data(for:URLRequest(url:IcelandApplicationState.checklistURL,cachePolicy:.useProtocolCachePolicy))
            guard (response as? HTTPURLResponse)?.statusCode == 200,let pdf=PDFDocument(data:data) else { error=true;return }
            document=pdf
        } catch { self.error=true }
    }
    func passage(_ reference:IcelandOfficialReference) -> String? {
        guard let original=document?.page(at:reference.page),let text=original.string else { return nil }
        let ns=text as NSString
        let start=ns.range(of:reference.start,options:.caseInsensitive)
        guard start.location != NSNotFound else { return nil }
        let remaining=NSRange(location:start.location,length:ns.length-start.location)
        let end=ns.range(of:reference.end,options:.caseInsensitive,range:remaining)
        let limit=end.location == NSNotFound ? ns.length : end.location
        // Keep every original English and Chinese sentence, including all subclauses.
        return ns.substring(with:NSRange(location:start.location,length:limit-start.location))
            .trimmingCharacters(in:.whitespacesAndNewlines)
    }

}

struct IcelandOfficialExcerpt: View {
    let reference:IcelandOfficialReference
    @State private var source=IcelandOfficialChecklist.shared
    @State private var expanded=false
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        VStack(alignment:.leading,spacing:8) {
            Button { expanded=true } label: {
                Label("官方原文 · " + reference.title,systemImage:"building.columns")
                    .font(.callout.weight(.medium)).foregroundStyle(IcelandSourceColor.official(scheme))
            }.buttonStyle(.plain)
            if let passage=source.passage(reference) {
                Text(passage).font(.body).lineSpacing(4)
                    .foregroundStyle(IcelandSourceColor.official(scheme))
                    .textSelection(.enabled).fixedSize(horizontal:false,vertical:true)
                    .frame(maxWidth:.infinity,alignment:.leading)
            } else if source.document != nil {
                Button("阅读完整官方段落",systemImage:"doc.text") { expanded=true }
                    .buttonStyle(.link)
            } else if source.error {
                HStack { Text("未能载入原始 PDF").foregroundStyle(.secondary);Button("重试") { Task { await source.load() } };Link("打开官方原文",destination:IcelandApplicationState.checklistURL) }
            } else { ProgressView("载入官方原文…").controlSize(.small) }
        }
        .task { await source.load() }
        .sheet(isPresented:$expanded) {
            VStack(spacing:0) {
                HStack {
                    Text("VFS · 冰岛个人旅游材料清单").font(.headline)
                    Spacer()
                    Link("官网",destination:IcelandApplicationState.vfsURL)
                    Button("完成") { expanded=false }.keyboardShortcut(.cancelAction)
                }.padding(18)
                if let document=source.document { IcelandPDFView(document:document,highlight:reference.start) }
                else { ProgressView().frame(maxWidth:.infinity,maxHeight:.infinity) }
            }.frame(width:870,height:720)
        }
    }
}

