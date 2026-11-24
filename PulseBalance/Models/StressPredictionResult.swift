import SwiftUI

enum StressTier: String, CaseIterable {
    case low = "Low"
    case moderate = "Moderate"
    case high = "High"
    case unknown = "Unknown"

    init(rawLabel: String) {
        let normalized = rawLabel.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch normalized {
        case "low", "0":
            self = .low
        case "medium", "moderate", "1":
            self = .moderate
        case "high", "2":
            self = .high
        default:
            self = .unknown
        }
    }

    var displayTitle: String {
        switch self {
        case .low: return "Low Stress"
        case .moderate: return "Moderate Stress"
        case .high: return "High Stress"
        case .unknown: return "Unclassified"
        }
    }

    var iconName: String {
        switch self {
        case .low: return "leaf.fill"
        case .moderate: return "waveform.path.ecg"
        case .high: return "exclamationmark.triangle.fill"
        case .unknown: return "questionmark.circle.fill"
        }
    }

    func resolvedColor(using filterMode: ColorBlindFilterMode = .none) -> Color {
        filterMode.color(for: self)
    }

    var summary: String {
        switch self {
        case .low:
            return "Your daily focus workload, sleep recovery, and screen habits appear well balanced."
        case .moderate:
            return "Early signs of mental strain detected. Small adjustments to rest or screen breaks can keep stress in check."
        case .high:
            return "Elevated stress risk detected. Prioritizing restorative sleep, pacing focus blocks, and reducing late-night screen exposure is recommended."
        case .unknown:
            return "Prediction completed with an unrecognized label."
        }
    }

    var recommendations: [String] {
        switch self {
        case .low:
            return [
                "Maintain your current 7 to 9 hour sleep window.",
                "Keep a steady balance between focused work blocks and offline downtime."
            ]
        case .moderate:
            return [
                "Break long work, study, or gaming sessions with 10-minute screen-free intervals.",
                "Aim for at least 7 hours of sleep ahead of demanding days."
            ]
        case .high:
            return [
                "Protect a consistent bedtime and avoid high-intensity gaming or work right before sleep.",
                "Split heavy focus hours into 45-minute intervals rather than marathon sessions.",
                "Balance daily device usage with offline social or physical recovery."
            ]
        case .unknown:
            return [
                "Review your input values and run the prediction again."
            ]
        }
    }
}

struct StressPredictionResult: Equatable {
    let rawLabel: String
    let tier: StressTier
    let confidence: Double?
    let probabilities: [String: Double]
    let timestamp: Date

    init(
        rawLabel: String,
        probabilities: [String: Double] = [:],
        timestamp: Date = Date()
    ) {
        self.rawLabel = rawLabel
        self.tier = StressTier(rawLabel: rawLabel)
        self.probabilities = probabilities
        self.timestamp = timestamp

        if let exactMatch = probabilities[rawLabel] {
            self.confidence = exactMatch
        } else if let caseInsensitiveMatch = probabilities.first(where: {
            $0.key.caseInsensitiveCompare(rawLabel) == .orderedSame
        })?.value {
            self.confidence = caseInsensitiveMatch
        } else {
            self.confidence = probabilities.values.max()
        }
    }

    var formattedConfidence: String? {
        guard let confidence else { return nil }
        let percentage = Int((confidence * 100).rounded())
        return "\(percentage)% confidence"
    }
}
