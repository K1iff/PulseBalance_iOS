//
//  AppPreferences.swift
//  PulseBalance
//
//  Created by Ryzel Realon on 11/24/26.
//

import SwiftUI

enum AppThemeMode: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .system: return "circle.lefthalf.filled"
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

enum ColorBlindFilterMode: String, CaseIterable, Identifiable {
    case none = "Standard"
    case protanopia = "Protanopia (Red-Weak)"
    case deuteranopia = "Deuteranopia (Green-Weak)"
    case tritanopia = "Tritanopia (Blue-Weak)"
    case achromatopsia = "Monochrome"

    var id: String { rawValue }

    var subtitle: String {
        switch self {
        case .none:
            return "Default indigo and teal palette"
        case .protanopia:
            return "Blue and gold high-contrast palette for red-cone deficiency"
        case .deuteranopia:
            return "Cobalt and amber palette for green-cone deficiency"
        case .tritanopia:
            return "Crimson and cyan palette for blue-cone deficiency"
        case .achromatopsia:
            return "High-contrast grayscale luminance palette"
        }
    }

    var primaryAccent: Color {
        switch self {
        case .none:
            return .indigo
        case .protanopia:
            return Color(red: 0.08, green: 0.35, blue: 0.78)
        case .deuteranopia:
            return Color(red: 0.10, green: 0.38, blue: 0.82)
        case .tritanopia:
            return Color(red: 0.72, green: 0.14, blue: 0.28)
        case .achromatopsia:
            return Color(white: 0.28)
        }
    }

    var secondaryAccent: Color {
        switch self {
        case .none:
            return .teal
        case .protanopia:
            return Color(red: 0.85, green: 0.58, blue: 0.05)
        case .deuteranopia:
            return Color(red: 0.88, green: 0.52, blue: 0.08)
        case .tritanopia:
            return Color(red: 0.04, green: 0.56, blue: 0.64)
        case .achromatopsia:
            return Color(white: 0.48)
        }
    }

    func color(for tier: StressTier) -> Color {
        switch (self, tier) {
        case (.none, .low):
            return .teal
        case (.none, .moderate):
            return .orange
        case (.none, .high):
            return .red
        case (.none, .unknown):
            return .indigo

        case (.protanopia, .low), (.deuteranopia, .low):
            return Color(red: 0.05, green: 0.45, blue: 0.85)
        case (.protanopia, .moderate), (.deuteranopia, .moderate):
            return Color(red: 0.90, green: 0.62, blue: 0.04)
        case (.protanopia, .high), (.deuteranopia, .high):
            return Color(red: 0.55, green: 0.18, blue: 0.58)
        case (.protanopia, .unknown), (.deuteranopia, .unknown):
            return primaryAccent

        case (.tritanopia, .low):
            return Color(red: 0.04, green: 0.58, blue: 0.66)
        case (.tritanopia, .moderate):
            return Color(red: 0.92, green: 0.48, blue: 0.52)
        case (.tritanopia, .high):
            return Color(red: 0.76, green: 0.10, blue: 0.22)
        case (.tritanopia, .unknown):
            return primaryAccent

        case (.achromatopsia, .low):
            return Color(white: 0.55)
        case (.achromatopsia, .moderate):
            return Color(white: 0.36)
        case (.achromatopsia, .high):
            return Color(white: 0.16)
        case (.achromatopsia, .unknown):
            return Color(white: 0.42)
        }
    }

    var chartSeriesColors: [Color] {
        [secondaryAccent, primaryAccent]
    }
}
