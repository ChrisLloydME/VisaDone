//
//  ComposePostView.swift
//  VisaDone
//

import SwiftUI

struct ComposePostView: View {
    @Bindable var model: VisaDoneModel
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var bodyText = ""
    @State private var region: PostRegion = .schengen
    @FocusState private var focusedField: Field?

    private enum Field {
        case title
        case body
    }

    private var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canPublish: Bool {
        !trimmedTitle.isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            Rectangle()
                .fill(DiscoveryTheme.hairline.opacity(0.7))
                .frame(height: 1)

            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 19) {
                    titleField
                    bodyField
                    topicPicker
                    localNote
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.automatic)

            footer
        }
        .frame(width: 600, height: 590)
        .background(.regularMaterial)
        .onAppear {
            DispatchQueue.main.async {
                focusedField = .title
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(DiscoveryTheme.brandStrong)
                        .frame(width: 5, height: 5)

                    Text("分享新经历")
                        .font(DiscoveryTheme.eyebrow)
                        .foregroundStyle(DiscoveryTheme.brandStrong)
                }

                Text("发布帖子")
                    .font(.system(size: 26, weight: .semibold, design: .serif))
                    .tracking(-0.2)

                Text("写下你的问题，或分享一段准备出发的经历。")
                    .font(.system(size: 12.5))
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 12)

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 26, height: 26)
                    .background {
                        Circle()
                            .fill(DiscoveryTheme.quietFill)
                    }
                    .contentShape(Circle())
            }
            .buttonStyle(SoftPressButtonStyle())
            .help("关闭")
            .accessibilityLabel("关闭")
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 16)
    }

    // MARK: - Fields

    private var titleField: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Text("标题")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)

                Spacer()

                Text("\(title.count)/36")
                    .font(.system(size: 10, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }

            TextField("用一句话说说你想分享什么", text: $title)
                .textFieldStyle(.plain)
                .font(.system(size: 15, weight: .medium, design: .serif))
                .focused($focusedField, equals: .title)
                .padding(.horizontal, 11)
                .frame(height: 40)
                .background {
                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                        .fill(DiscoveryTheme.field)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                        .strokeBorder(
                            focusedField == .title ? DiscoveryTheme.brand.opacity(0.75) : DiscoveryTheme.hairline,
                            lineWidth: focusedField == .title ? 1.5 : 1
                        )
                }
                .onChange(of: title) { _, newValue in
                    if newValue.count > 36 {
                        title = String(newValue.prefix(36))
                    }
                }
                .onSubmit {
                    focusedField = .body
                }
        }
    }

    private var bodyField: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("正文")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)

            ZStack(alignment: .topLeading) {
                if bodyText.isEmpty {
                    Text("可以聊聊行程、材料和你的实际经历。请勿填写护照号等个人敏感信息。")
                        .font(.system(size: 12.5))
                        .foregroundStyle(.secondary)
                        .lineSpacing(2.5)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 11)
                        .allowsHitTesting(false)
                }

                TextEditor(text: $bodyText)
                    .font(.system(size: 13))
                    .lineSpacing(3)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 4)
                    .focused($focusedField, equals: .body)
                    .accessibilityLabel("帖子正文")
            }
            .frame(height: 148)
            .background {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(DiscoveryTheme.field)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .strokeBorder(
                        focusedField == .body ? DiscoveryTheme.brand.opacity(0.75) : DiscoveryTheme.hairline,
                        lineWidth: focusedField == .body ? 1.5 : 1
                    )
            }
        }
    }

    private var topicPicker: some View {
        HStack(alignment: .bottom, spacing: 18) {
            VStack(alignment: .leading, spacing: 7) {
                Text("分类")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)

                Picker("分类", selection: $region) {
                    ForEach(PostRegion.allCases, id: \.self) { region in
                        Text(region.title).tag(region)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
                .frame(width: 200, alignment: .leading)
            }

            Spacer(minLength: 8)

            HStack(spacing: 7) {
                AuthorAvatarView(author: .you, size: 22)
                VStack(alignment: .leading, spacing: 1) {
                    Text("以林晚的身份发布")
                        .font(.system(size: 11, weight: .medium))
                    Text("个人账号")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.bottom, 2)
        }
    }

    private var localNote: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "internaldrive")
                .font(.system(size: 11.5, weight: .medium))
                .foregroundStyle(DiscoveryTheme.brandStrong)
                .padding(.top, 1)

            Text("发布后可在发现页查看，本次内容仅保存在当前使用中。")
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
                .lineSpacing(1.5)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(11)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 9, style: .continuous)
                .fill(DiscoveryTheme.surfaceMuted)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 9, style: .continuous)
                .strokeBorder(DiscoveryTheme.hairline.opacity(0.65), lineWidth: 1)
        }
    }

    // MARK: - Footer

    private var footer: some View {
        HStack(spacing: 9) {
            Text(canPublish ? "写好标题，就可以发布了。" : "请先填写标题。")
                .font(.system(size: 10.5))
                .foregroundStyle(.secondary)

            Spacer(minLength: 8)

            Button("取消") {
                dismiss()
            }
            .keyboardShortcut(.cancelAction)

            Button("发布") {
                model.addPost(title: title, body: bodyText, region: region)
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .keyboardShortcut(.return, modifiers: .command)
            .disabled(!canPublish)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(.bar)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(DiscoveryTheme.hairline.opacity(0.7))
                .frame(height: 1)
        }
    }
}

#Preview("Compose") {
    ComposePostView(model: VisaDoneModel())
}
