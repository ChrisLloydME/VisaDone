// Generates fictional, sanitized community attachments using native text rendering.
// These pages are personal notes, not copies of official visa documents.
import AppKit
import Foundation

let root = URL(fileURLWithPath: CommandLine.arguments[1])
let width: CGFloat = 720
let height: CGFloat = 880
let ink = NSColor(white: 0.12, alpha: 1)
let secondary = NSColor(white: 0.43, alpha: 1)
let line = NSColor(white: 0.84, alpha: 1)

func rect(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, color: NSColor) {
    color.setFill()
    NSBezierPath(rect: NSRect(x: x, y: height - y - h, width: w, height: h)).fill()
}
func text(_ value: String, x: CGFloat = 54, y: CGFloat, w: CGFloat = 612, h: CGFloat = 44, size: CGFloat = 24, bold: Bool = false, serif: Bool = false, color: NSColor = ink) {
    let style = NSMutableParagraphStyle()
    style.lineSpacing = 7
    style.lineBreakMode = .byWordWrapping
    let font = serif ? (NSFont(name: "STSongti-SC-Bold", size: size) ?? .systemFont(ofSize: size, weight: .semibold)) : .systemFont(ofSize: size, weight: bold ? .semibold : .regular)
    (value as NSString).draw(in: NSRect(x: x, y: height - y - h, width: w, height: h), withAttributes: [.font: font, .foregroundColor: color, .paragraphStyle: style])
}
func header(_ kind: String, title: String, subtitle: String) {
    rect(0, 0, width, height, color: NSColor(white: 0.975, alpha: 1))
    text("VisaDone  /  \(kind)", y: 42, size: 19, color: secondary)
    text(title, y: 106, h: 136, size: 48, serif: true)
    text(subtitle, y: 256, size: 22, color: secondary)
    rect(54, 314, 612, 1, color: line)
}
func footer(_ note: String) {
    rect(54, 796, 612, 1, color: line)
    text(note, y: 816, size: 18, color: secondary)
}
func render(_ name: String, content: () -> Void) throws {
    let image = NSImage(size: NSSize(width: width, height: height))
    image.lockFocus()
    content()
    image.unlockFocus()
    guard let tiff = image.tiffRepresentation, let rep = NSBitmapImageRep(data: tiff), let data = rep.representation(using: .png, properties: [:]) else { return }
    let folder = root.appendingPathComponent("VisaDone/Assets.xcassets/CommunityDocuments/\(name).imageset")
    try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
    try data.write(to: folder.appendingPathComponent("cover.png"))
    let contents: [String: Any] = ["images": [["filename": "cover.png", "idiom": "universal"]], "info": ["author": "xcode", "version": 1]]
    try JSONSerialization.data(withJSONObject: contents, options: [.prettyPrinted, .sortedKeys]).write(to: folder.appendingPathComponent("Contents.json"))
    print(name)
}

try render("visaAccommodationCheck") {
    header("社区补充", title: "住宿证明\n多查一栏住客信息", subtitle: "冰岛旅游  ·  一次补件经历")
    let rows = [("入住与离店", "与行程逐晚对应"), ("预订人", "已核对"), ("同行人", "原订单未显示"), ("补充说明", "联系住宿方确认")]
    for (index, row) in rows.enumerated() {
        let y: CGFloat = 348 + CGFloat(index) * 84
        text(row.0, y: y, w: 210, size: 24, bold: true)
        text(row.1, x: 294, y: y, w: 372, size: 24)
        rect(54, y + 61, 612, 1, color: line)
    }
    text("要问的问题", y: 706, size: 20, color: secondary)
    text("你的订单能对应全部同行人吗？", y: 741, size: 25, bold: true)
    footer("个案经验，非统一要求  ·  已移除预订信息")
}
try render("visaIcelandItinerary") {
    header("行程草稿", title: "冰岛九日行程\n请帮我看一眼", subtitle: "公开版  ·  仅保留相对天数与城市")
    text("天数", y: 336, size: 19, color: secondary)
    text("路线与过夜地", x: 154, y: 336, w: 300, size: 19, color: secondary)
    text("待核对", x: 476, y: 336, w: 190, size: 19, color: secondary)
    let rows = [("01", "抵达 · 雷克雅未克", "入住衔接"), ("02", "市区 · 周边", "交通安排"), ("03", "南岸 · 维克", "住宿日期"), ("04", "维克 → 冰河湖", "路程偏满？"), ("05", "冰河湖周边", "天气余量"), ("06", "南岸返程", "停靠取舍"), ("07", "机动日", "保留空白"), ("08", "雷克雅未克", "返程核对"), ("09", "离境", "航班衔接")]
    for (index, row) in rows.enumerated() {
        let y: CGFloat = 382 + CGFloat(index) * 43
        if index == 3 { rect(46, y - 4, 628, 40, color: NSColor(white: 0.91, alpha: 1)) }
        text(row.0, y: y, w: 80, size: 21)
        text(row.1, x: 154, y: y, w: 304, size: 21, bold: index == 3)
        text(row.2, x: 476, y: y, w: 190, size: 21, color: secondary)
    }
    footer("草稿待审，不代表已核实交通或已完成预订")
}
try render("visaDocumentChecklist") {
    header("准备清单", title: "递交前\n把未确认的再看一遍", subtitle: "官方要求与个人准备状态，分开记录")
    let rows = [("身份证明", "原件已核对"), ("行程安排", "草稿待审"), ("住宿信息", "住客信息待核"), ("资金材料", "日期复查"), ("保险文件", "适用范围待确认"), ("个人说明", "是否需要待核实")]
    for (index, row) in rows.enumerated() {
        let y: CGFloat = 351 + CGFloat(index) * 66
        rect(56, y + 6, 21, 21, color: NSColor(white: 0.88, alpha: 1))
        text(row.0, x: 96, y: y, w: 235, size: 23, bold: true)
        text(row.1, x: 346, y: y, w: 320, size: 23, color: secondary)
        rect(96, y + 47, 570, 1, color: line)
    }
    footer("“已备齐”是个人标记，不等于官方审核通过")
}
try render("visaProcessingTimeline") {
    header("进度记录", title: "我的递交时间线\n今天补上最后一项", subtitle: "英国访客  ·  上海  ·  本人上报")
    rect(71, 366, 2, 330, color: line)
    let rows = [("10 / 14", "完成递交", "记录实际递交日期"), ("10 / 24", "收到寄出通知", "通知与签收分别记录"), ("10 / 26", "签收护照", "收到后再核对结果")]
    for (index, row) in rows.enumerated() {
        let y: CGFloat = 352 + CGFloat(index) * 131
        NSColor(white: 0.22, alpha: 1).setFill()
        NSBezierPath(ovalIn: NSRect(x: 64, y: height - y - 26, width: 16, height: 16)).fill()
        text(row.0, x: 106, y: y, w: 160, size: 25, bold: true)
        text(row.1, x: 292, y: y, w: 374, size: 26, bold: true)
        text(row.2, x: 292, y: y + 43, w: 374, size: 21, color: secondary)
    }
    text("同类型、同地点，再对照时间。", y: 746, size: 24)
    footer("虚构社区案例  ·  个人上报，不是官方时效")
}
try render("visaItineraryReview") {
    header("改稿笔记", title: "AI 起稿之后\n我删掉了这些安排", subtitle: "脱敏分享  ·  保留修改理由")
    let rows = [("初稿", "一天三个远点", "缺少中间交通与入住衔接"), ("核对", "先补交通，再看密度", "社区提醒是核对线索，不是结论"), ("修改", "删掉一站，转城日留白", "未确认的安排仍标为计划")]
    for (index, row) in rows.enumerated() {
        let y: CGFloat = 348 + CGFloat(index) * 137
        text(row.0, y: y, w: 100, size: 21, color: secondary)
        text(row.1, x: 160, y: y, w: 506, size: 27, bold: true)
        text(row.2, x: 160, y: y + 48, w: 506, h: 65, size: 22, color: secondary)
        if index < 2 { rect(160, y + 106, 506, 1, color: line) }
    }
    footer("生成内容与社区建议，都需要自己核对")
}
try render("visaProcessingComparison") {
    header("进度交流", title: "先看条件\n再对照处理时间", subtitle: "把记录写完整，比只报天数更有帮助")
    let rows = [("申请国家", "先确认是否相同"), ("签证类别", "不要混合比较"), ("递交地点", "城市与服务方式"), ("关键日期", "递交、通知、签收"), ("记录完整度", "无更新 ≠ 仍在处理")]
    for (index, row) in rows.enumerated() {
        let y: CGFloat = 352 + CGFloat(index) * 78
        text(row.0, y: y, w: 220, size: 24, bold: true)
        text(row.1, x: 294, y: y, w: 372, size: 24)
        rect(54, y + 55, 612, 1, color: line)
    }
    footer("社区自愿上报，不预测个人结果或官方时效")
}
let catalog = root.appendingPathComponent("VisaDone/Assets.xcassets/CommunityDocuments/Contents.json")
try "{\"info\":{\"author\":\"xcode\",\"version\":1}}".write(to: catalog, atomically: true, encoding: .utf8)
