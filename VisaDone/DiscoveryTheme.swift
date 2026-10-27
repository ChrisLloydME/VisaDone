//
//  DiscoveryTheme.swift
//  VisaDone
//

import AppKit
import SwiftUI

/// A small, deliberate design language for the Discovery experience.
/// Text and backgrounds otherwise defer to macOS semantic colors.
enum DiscoveryTheme {
    static let brand = Color(nsColor: NSColor(name: nil) { appearance in
        appearance.isDark
            ? NSColor(red: 0.44, green: 0.78, blue: 0.72, alpha: 1)
            : NSColor(red: 0.08, green: 0.36, blue: 0.33, alpha: 1)
    })

    static let brandStrong = Color(nsColor: NSColor(name: nil) { appearance in
        appearance.isDark
            ? NSColor(red: 0.54, green: 0.87, blue: 0.80, alpha: 1)
            : NSColor(red: 0.05, green: 0.29, blue: 0.27, alpha: 1)
    })

    static let schengen = Color(nsColor: NSColor(name: nil) { appearance in
        appearance.isDark
            ? NSColor(red: 0.47, green: 0.76, blue: 0.78, alpha: 1)
            : NSColor(red: 0.12, green: 0.37, blue: 0.42, alpha: 1)
    })

    static let unitedStates = Color(nsColor: NSColor(name: nil) { appearance in
        appearance.isDark
            ? NSColor(red: 0.60, green: 0.70, blue: 0.93, alpha: 1)
            : NSColor(red: 0.24, green: 0.34, blue: 0.59, alpha: 1)
    })

    static let unitedKingdom = Color(nsColor: NSColor(name: nil) { appearance in
        appearance.isDark
            ? NSColor(red: 0.86, green: 0.62, blue: 0.47, alpha: 1)
            : NSColor(red: 0.52, green: 0.30, blue: 0.19, alpha: 1)
    })

    static let canvas = Color(nsColor: NSColor(name: nil) { appearance in
        appearance.isDark
            ? NSColor(red: 0.071, green: 0.078, blue: 0.082, alpha: 1)
            : NSColor(red: 0.965, green: 0.957, blue: 0.941, alpha: 1)
    })

    static let surface = Color(nsColor: NSColor(name: nil) { appearance in
        appearance.isDark
            ? NSColor(red: 0.117, green: 0.125, blue: 0.13, alpha: 1)
            : NSColor(red: 1, green: 1, blue: 1, alpha: 1)
    })

    static let surfaceMuted = Color(nsColor: NSColor(name: nil) { appearance in
        appearance.isDark
            ? NSColor(red: 0.145, green: 0.154, blue: 0.16, alpha: 1)
            : NSColor(red: 0.988, green: 0.984, blue: 0.976, alpha: 1)
    })

    static let field = Color(nsColor: NSColor(name: nil) { appearance in
        appearance.isDark
            ? NSColor(red: 0.148, green: 0.157, blue: 0.164, alpha: 1)
            : NSColor(red: 1, green: 1, blue: 1, alpha: 0.82)
    })

    static let hairline = Color(nsColor: .separatorColor)

    static let liked = Color(nsColor: NSColor(name: nil) { appearance in
        appearance.isDark
            ? NSColor(red: 0.95, green: 0.47, blue: 0.45, alpha: 1)
            : NSColor(red: 0.73, green: 0.21, blue: 0.20, alpha: 1)
    })

    static let onBrand = Color(nsColor: NSColor(name: nil) { appearance in
        appearance.isDark
            ? NSColor(red: 0.035, green: 0.095, blue: 0.085, alpha: 1)
            : NSColor.white
    })

    static let hoverFill = Color(nsColor: NSColor(name: nil) { appearance in
        appearance.isDark
            ? NSColor(white: 1, alpha: 0.07)
            : NSColor(white: 0, alpha: 0.045)
    })

    static let quietFill = Color(nsColor: NSColor(name: nil) { appearance in
        appearance.isDark
            ? NSColor(white: 1, alpha: 0.055)
            : NSColor(white: 0, alpha: 0.035)
    })

    static let cardRadius: CGFloat = 12
    static let contentMaxWidth: CGFloat = 1440
    static let pageInset: CGFloat = 36
    static let cardSpacing: CGFloat = 18
    static let masonryMinColumnWidth: CGFloat = 262

    static let serifTitle = Font.system(size: 16.5, weight: .semibold, design: .serif)
    static let serifLargeTitle = Font.system(size: 21, weight: .semibold, design: .serif)
    static let pageTitle = Font.system(size: 38, weight: .semibold, design: .serif)
    static let sectionTitle = Font.system(size: 12.5, weight: .medium)
    static let eyebrow = Font.system(size: 10, weight: .semibold)
    static let metadata = Font.system(size: 11, weight: .regular)
    static let small = Font.system(size: 11.5, weight: .regular)
    static let body = Font.system(size: 13.5, weight: .regular)
    static let buttonLabel = Font.system(size: 12, weight: .medium)
}

private extension NSAppearance {
    var isDark: Bool {
        bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
    }
}

extension View {
    /// Keeps the feed at a comfortable measure on very wide displays.
    func discoveryPageWidth() -> some View {
        frame(maxWidth: DiscoveryTheme.contentMaxWidth, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}
