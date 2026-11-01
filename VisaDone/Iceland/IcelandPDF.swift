import AppKit
import SwiftUI
import PDFKit
import CoreText
import UniformTypeIdentifiers

@MainActor enum IcelandPDF {
    static let bookingText = """
    CENTER HOTELS PLAZA
    ACCOMMODATION RESERVATION

    Sample booking for document review
    Property: Center Hotels Plaza, Reykjavik
    Address: Adalstraeti 4, 101 Reykjavik, Iceland

    Check-in: 03 March 2027
    Check-out: 06 March 2027
    Nights: 3
    Room: Family room

    Guest name: LIN WAN
    Additional guests: Not listed

    Reservation status: Confirmed sample
    Payment: Pay at property

    This is a fictional document for interface demonstration.
    It is not a valid reservation or proof of accommodation.
    """
    static func document(title:String,text:String) -> PDFDocument {
        let data = NSMutableData()
        var media = CGRect(x:0,y:0,width:595,height:842)
        guard let consumer = CGDataConsumer(data:data as CFMutableData),
              let context = CGContext(consumer:consumer,mediaBox:&media,nil) else { return PDFDocument() }
        let paragraph = NSMutableParagraphStyle();paragraph.lineSpacing = 7
        let attrs:[NSAttributedString.Key:Any] = [.font:NSFont.systemFont(ofSize:12),.foregroundColor:NSColor.black,.paragraphStyle:paragraph]
        // Split into manageable pages; no clipping of exported itinerary text.
        let lines = (title + "\n\n" + text).components(separatedBy:"\n")
        for start in stride(from:0,to:lines.count,by:23) {
            context.beginPDFPage(nil)
            context.setFillColor(CGColor(gray:1,alpha:1));context.fill(media)
            NSGraphicsContext.saveGraphicsState()
            NSGraphicsContext.current = NSGraphicsContext(cgContext:context,flipped:false)
            let chunk = lines[start..<min(start+23,lines.count)].joined(separator:"\n")
            (chunk as NSString).draw(in:CGRect(x:48,y:48,width:499,height:746),withAttributes:attrs)
            NSGraphicsContext.restoreGraphicsState()
            context.endPDFPage()
        }
        context.closePDF()
        return PDFDocument(data:data as Data) ?? PDFDocument()
    }
    static func booking(_ application:IcelandApplicationState) -> PDFDocument {
        if let data = application.importedBooking, let document = PDFDocument(data:data) { return document }
        return document(title:"",text:bookingText)
    }
    static func itinerary(_ application:IcelandApplicationState,language:IcelandItineraryLanguage?=nil,days:[IcelandDay]?=nil) -> PDFDocument {
        let text=IcelandItineraryDocument.text(application,language:language ?? application.itineraryLanguage,days:days)
        let paragraph=NSMutableParagraphStyle();paragraph.lineSpacing=4;paragraph.paragraphSpacing=5
        let attributed=NSAttributedString(string:text,attributes:[.font:NSFont.systemFont(ofSize:10),.foregroundColor:NSColor.black,.paragraphStyle:paragraph])
        let data=NSMutableData()
        var media=CGRect(x:0,y:0,width:595,height:842)
        guard let consumer=CGDataConsumer(data:data as CFMutableData),let context=CGContext(consumer:consumer,mediaBox:&media,nil) else {return PDFDocument()}
        let setter=CTFramesetterCreateWithAttributedString(attributed)
        var offset=0
        while offset<attributed.length {
            context.beginPDFPage(nil)
            context.setFillColor(CGColor(gray:1,alpha:1));context.fill(media)
            let path=CGPath(rect:CGRect(x:44,y:42,width:507,height:758),transform:nil)
            let frame=CTFramesetterCreateFrame(setter,CFRange(location:offset,length:0),path,nil)
            CTFrameDraw(frame,context)
            let visible=CTFrameGetVisibleStringRange(frame)
            context.endPDFPage()
            guard visible.length>0 else {break}
            offset+=visible.length
        }
        context.closePDF()
        return PDFDocument(data:data as Data) ?? PDFDocument()
    }
    static func exportItinerary(_ application:IcelandApplicationState,language:IcelandItineraryLanguage?=nil,days:[IcelandDay]?=nil) {
        let panel=NSSavePanel();panel.nameFieldStringValue="冰岛完整行程.pdf";panel.allowedContentTypes=[.pdf]
        guard panel.runModal() == .OK,let url=panel.url else {return}
        itinerary(application,language:language,days:days).write(to:url)
    }
    static func exportChecklist(_ application:IcelandApplicationState) {
        let text = application.activeDocuments.map { "\($0.status == .ready ? "☑" : "☐")  \($0.title) · \($0.requirement.rawValue)\n   \($0.summary)" }.joined(separator:"\n\n")
        let panel = NSSavePanel();panel.nameFieldStringValue = "冰岛申请打印清单.pdf";panel.allowedContentTypes = [.pdf]
        guard panel.runModal() == .OK,let url = panel.url else { return }
        document(title:"个人材料准备清单",text:text+"\n\n个人准备记录，不代表官方审核结果。\n官方原文：\(IcelandApplicationState.checklistURL.absoluteString)").write(to:url)
    }
}

struct IcelandPDFView: NSViewRepresentable {
    let document:PDFDocument
    var highlight:String? = nil
    func makeNSView(context:Context) -> PDFView {
        let view = PDFView()
        view.autoScales = true
        view.displayMode = .singlePageContinuous
        view.displaysPageBreaks = true
        view.backgroundColor = .controlBackgroundColor
        return view
    }
    func updateNSView(_ view:PDFView,context:Context) {
        // Keep scrolling and zoom stable when only the selected check changes.
        let signature = document.string ?? ""
        if context.coordinator.signature != signature {
            context.coordinator.signature = signature
            view.document = document
            view.autoScales = true
            view.layoutDocumentView()
        }
        if let highlight,let selected = view.document?.findString(highlight,withOptions:.caseInsensitive).first {
            selected.color = NSColor.controlAccentColor.withAlphaComponent(0.25)
            view.setCurrentSelection(selected,animate:false)
            view.go(to:selected)
        } else { view.clearSelection() }
    }
    func makeCoordinator() -> Coordinator { Coordinator() }
    final class Coordinator { var signature = "" }
}
