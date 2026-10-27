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
        .background(DiscoveryTheme.canvas)
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

                    Text("NEW COMMUNITY POST")
                        .font(DiscoveryTheme.eyebrow)
                        .tracking(1.15)
                        .foregroundStyle(DiscoveryTheme.brandStrong)
                }

                Text("Ask the community")
                    .font(.system(size: 26, weight: .semibold, design: .serif))
                    .tracking(-0.2)

                Text("A good question is specific, honest, and yours.")
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
            .help("Close")
            .accessibilityLabel("Close")
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 16)
    }

    // MARK: - Fields

    private var titleField: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Text("QUESTION")
                    .font(.system(size: 9.5, weight: .semibold))
                    .tracking(0.9)
                    .foregroundStyle(.secondary)

                Spacer()

                Text("\(title.count)/110")
                    .font(.system(size: 10, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.tertiary)
            }

            TextField("What would you like to ask?", text: $title)
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
                    if newValue.count > 110 {
                        title = String(newValue.prefix(110))
                    }
                }
                .onSubmit {
                    focusedField = .body
                }
        }
    }

    private var bodyField: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("CONTEXT")
                .font(.system(size: 9.5, weight: .semibold))
                .tracking(0.9)
                .foregroundStyle(.secondary)

            ZStack(alignment: .topLeading) {
                if bodyText.isEmpty {
                    Text("Share the details that matter — dates, documents, the part you are unsure about. Please keep personal information out.")
                        .font(.system(size: 12.5))
                        .foregroundStyle(.tertiary)
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
                    .accessibilityLabel("Post context")
            }
            .frame(minHeight: 148)
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
                Text("TOPIC")
                    .font(.system(size: 9.5, weight: .semibold))
                    .tracking(0.9)
                    .foregroundStyle(.secondary)

                Picker("Topic", selection: $region) {
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
                    Text("Posting as You")
                        .font(.system(size: 11, weight: .medium))
                    Text("Local profile")
                        .font(.system(size: 10))
                        .foregroundStyle(.tertiary)
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

            Text("This is a local prototype. Your post is added to this session only — it is not sent anywhere and disappears when the app closes.")
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
            Text(canPublish ? "A title is all you need to start." : "Add a title to publish.")
                .font(.system(size: 10.5))
                .foregroundStyle(.tertiary)

            Spacer(minLength: 8)

            Button("Cancel") {
                dismiss()
            }
            .keyboardShortcut(.cancelAction)

            Button("Publish") {
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
