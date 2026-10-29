import SwiftUI

struct ApplicationPreparationItem: Identifiable {
    let id: String
    let title: String
    let note: String
    var isReady: Bool
}

// Personal preparation state, not a visa authority's review or acceptance.
@Observable final class OngoingVisaApplication {
    let destinationName = "冰岛"
    let visaType = "旅游签证"
    var title: String { destinationName + visaType }
    let subtitle = "2027年3月1–13日 · 三人同行"
    var items: [ApplicationPreparationItem] = [
        .init(id: "passport", title: "护照与复印件", note: "已核对个人信息与有效期", isReady: true),
        .init(id: "photo", title: "签证照片", note: "已整理电子版与纸质照片", isReady: true),
        .init(id: "employment", title: "在职与准假证明", note: "已核对出行时间", isReady: true),
        .init(id: "finance", title: "资金材料", note: "已整理近期流水", isReady: true),
        .init(id: "insurance", title: "旅行保险", note: "已保存保单与英文版本", isReady: true),
        .init(id: "transport", title: "往返交通安排", note: "已与出入境日期对应", isReady: true),
        .init(id: "accommodation", title: "住宿预订证明", note: "核对入住日期、地址与同行人信息", isReady: false),
        .init(id: "itinerary", title: "旅行行程单", note: "公开草稿已收到社区建议，待整理最终版", isReady: false),
        .init(id: "form", title: "申请表", note: "与护照及行程信息再核对一次", isReady: false),
        .init(id: "letter", title: "个人说明", note: "整理与这次旅行相关的补充说明", isReady: false)
    ]
    var readyCount: Int { items.filter(\.isReady).count }
    var progress: Double { Double(readyCount)/Double(max(1, items.count))*0.25 }
}

struct ApplicationOrderProgress: View {
    let progress: Double
    var activeStage: Int = 0
    private let stages = ["准备材料", "预约递交", "等待结果", "申请完成"]
    var body: some View {
        VStack(spacing: 7) {
            ProgressView(value: progress)
                .progressViewStyle(.linear).controlSize(.small)
                .accessibilityLabel("申请进度")
                .accessibilityValue(stages[min(3,max(0,activeStage))])
            HStack(spacing: 0) {
                ForEach(Array(stages.enumerated()), id: \.offset) { index, stage in
                    Text(stage)
                        .font(.system(size: 11, weight: index == activeStage ? .medium : .regular))
                        .foregroundStyle(index == activeStage ? .primary : .secondary)
                        .frame(maxWidth: .infinity, alignment: index == 0 ? .leading : (index == 3 ? .trailing : .center))
                }
            }
        }
    }
}

// An in-window, nonmodal panel. It leaves the map interactive at both heights.
// The native macOS sheet is reserved for opening the preparation checklist.
struct ApplicationProgressDrawer: View {
    @Bindable var application: OngoingVisaApplication
    var readyCount: Int? = nil
    var totalCount: Int? = nil
    var nextAction: String? = nil
    var overallProgress: Double? = nil
    var activeStage: Int = 0
    var phaseTitle: String = "材料准备中"
    let onContinue: () -> Void
    private var currentReady: Int { readyCount ?? application.readyCount }
    private var currentTotal: Int { totalCount ?? application.items.count }
    @State private var expanded = true
    @State private var dragHeight: CGFloat?
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    private let expandedHeight: CGFloat = 270
    private let collapsedHeight: CGFloat = 64
    private var restingHeight: CGFloat { expanded ? expandedHeight : collapsedHeight }
    private var height: CGFloat { dragHeight ?? restingHeight }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button { setExpanded(!expanded) } label: {
                VStack(spacing: 6) {
                    Capsule().fill(.secondary.opacity(0.45)).frame(width: 34, height: 4)
                    HStack(spacing: 9) {
                        Text("我的申请").font(.system(size: 22, weight: .bold))
                        Spacer(minLength: 0)
                        Image(systemName: expanded ? "chevron.down" : "chevron.up")
                            .font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 22).padding(.top, 9).padding(.bottom, 10)
                .frame(height: collapsedHeight)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .highPriorityGesture(drawerDrag)
            .help("拖动或点按以展开、收起当前申请")
            .accessibilityLabel("我的申请")
            .accessibilityValue(expanded ? "已展开" : "已收起")
            .accessibilityAdjustableAction { direction in
                switch direction {
                case .increment: setExpanded(true)
                case .decrement: setExpanded(false)
                @unknown default: break
                }
            }

            VStack(alignment: .leading, spacing: 14) {
                Divider()
                HStack(spacing: 10) {
                    Image("visaFlagIS").resizable().scaledToFill()
                        .frame(width: 32, height: 32).clipShape(Circle())
                    VStack(alignment: .leading, spacing: 4) {
                        Text(application.destinationName).font(.system(size: 16, weight: .semibold))
                        Text(application.visaType).font(.system(size: 12)).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(activeStage == 3 ? "已完成" : "正在进行").font(.system(size: 11)).foregroundStyle(.secondary)
                }
                HStack {
                    Text(phaseTitle).fontWeight(.medium)
                    Spacer()
                    Text("\(currentReady)/\(currentTotal) 项就绪").foregroundStyle(.secondary)
                }
                .font(.system(size: 12))
                ApplicationOrderProgress(progress: overallProgress ?? Double(currentReady)/Double(max(1,currentTotal))*0.25,activeStage:activeStage)
                HStack {
                    Text("下一项：\(nextAction ?? application.items.first { !$0.isReady }?.title ?? "复核准备清单")")
                        .font(.system(size: 11)).foregroundStyle(.secondary).lineLimit(1)
                    Spacer(minLength: 8)
                    Button(activeStage == 3 ? "查看记录" : (activeStage == 2 ? "查看进度" : "继续准备"), action: onContinue)
                        .controlSize(.small).buttonStyle(.bordered)
                }
            }
            .padding(.horizontal, 22).padding(.top, 4).padding(.bottom, 22)
            .opacity(min(1, max(0, (height-collapsedHeight)/60)))
            .accessibilityHidden(!expanded)
            .allowsHitTesting(expanded && dragHeight == nil)
        }
        .frame(height: height, alignment: .top)
        .clipped()
        .glassEffect(.regular, in: .rect(cornerRadius: 26))
    }

    private var drawerDrag: some Gesture {
        DragGesture(minimumDistance: 4, coordinateSpace: .global)
            .onChanged { value in
                dragHeight = min(expandedHeight, max(collapsedHeight, restingHeight-value.translation.height))
            }
            .onEnded { value in
                let projected = restingHeight-value.predictedEndTranslation.height
                setExpanded(projected > (expandedHeight+collapsedHeight)/2)
            }
    }

    private func setExpanded(_ value: Bool) {
        withAnimation(reduceMotion ? nil : .snappy(duration: 0.25, extraBounce: 0)) {
            expanded = value
            dragHeight = nil
        }
    }
}

struct OngoingApplicationSheet: View {
    @Bindable var application: OngoingVisaApplication
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(application.title).font(.system(size: 22, weight: .semibold))
                    Text(application.subtitle).font(.system(size: 12)).foregroundStyle(.secondary)
                }
                Spacer()
                Button("完成") { dismiss() }.keyboardShortcut(.cancelAction)
            }
            ApplicationOrderProgress(progress: application.progress)
            HStack {
                Text("个人准备清单").font(.headline)
                Spacer()
                Text("\(application.readyCount) / \(application.items.count) 项已就绪").font(.system(size: 12)).foregroundStyle(.secondary)
            }
            List {
                ForEach($application.items) { $item in
                    Toggle(isOn: $item.isReady) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title).font(.system(size: 13, weight: .medium))
                            Text(item.note).font(.system(size: 11)).foregroundStyle(.secondary)
                        }.padding(.vertical, 6)
                    }
                    .toggleStyle(.checkbox)
                }
            }
            .listStyle(.inset).scrollContentBackground(.hidden)
            Text("这份清单记录你的准备状态，请结合适用的官方材料清单核对。")
                .font(.system(size: 11)).foregroundStyle(.secondary)
        }
        .padding(24).frame(width: 680, height: 640)
    }
}
