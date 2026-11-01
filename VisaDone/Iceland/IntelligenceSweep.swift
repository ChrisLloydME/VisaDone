// Adapted from Livsy90/IntelligenceGlow, IntelligenceSweep.swift.
// Copyright (c) 2025 Artem — MIT; see Licenses/IntelligenceGlow-MIT.txt.
// Scoped to active AI content in the macOS material list.
import SwiftUI

extension View {
    func icelandIntelligenceSweep<S: InsettableShape>(
        in shape: S,
        borderColor: Color = .primary,
        colors: [Color] = IcelandIntelligenceStyle.colors,
        blurRadius: CGFloat = 18,
        lineWidth: CGFloat = 0.7,
        sweepSpan: Double = 130,
        sweepOffset: Double = 140
    ) -> some View {
        modifier(
            IntelligenceSweep(
                shape: shape,
                borderColor: borderColor,
                colors: colors,
                blurRadius: blurRadius,
                lineWidth: lineWidth,
                sweepSpan: sweepSpan,
                sweepOffset: sweepOffset
            )
        )
    }
}

private struct IntelligenceSweep<S: InsettableShape>: ViewModifier {
    let shape: S
    let borderColor: Color
    let colors: [Color]
    let blurRadius: CGFloat
    let lineWidth: CGFloat
    let sweepSpan: Double
    let sweepOffset: Double
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content
            .background {
                ZStack {
                    shape.stroke(borderColor.tertiary, lineWidth: lineWidth)

                    if reduceMotion {
                        sweepContent(rotation: 0)
                    } else {
                        KeyframeAnimator(initialValue: 0) { value in
                            sweepContent(rotation: value * 360)
                        } keyframes: { _ in
                            LinearKeyframe(1, duration: 2.6)
                        }
                    }
                }
                .padding(0.5)
            }
    }
    
    @ViewBuilder
    private func sweepContent(rotation: Double) -> some View {
        let borderGradient = AngularGradient(
            colors: [.clear, borderColor, .clear],
            center: .center,
            startAngle: .degrees(sweepOffset + rotation),
            endAngle: .degrees(sweepOffset + sweepSpan + rotation)
        )
        let sweepGradient = LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        ZStack {
            shape
                .fill(sweepGradient)
                .mask {
                    Rectangle()
                        .overlay {
                            shape
                                .blur(radius: blurRadius)
                                .blendMode(.destinationOut)
                        }
                }
                .mask {
                    shape
                        .fill(borderGradient)
                        .blur(radius: blurRadius / 1.5)
                        .padding(-blurRadius * 2)
                }

            shape.stroke(borderGradient, lineWidth: lineWidth)
        }
    }
}

enum IcelandIntelligenceStyle {
    static let colors:[Color]=[
        Color(red:188/255,green:130/255,blue:243/255),
        Color(red:245/255,green:185/255,blue:234/255),
        Color(red:141/255,green:159/255,blue:255/255),
        Color(red:255/255,green:103/255,blue:120/255),
        Color(red:255/255,green:186/255,blue:113/255),
        Color(red:198/255,green:134/255,blue:255/255)
    ]
}
