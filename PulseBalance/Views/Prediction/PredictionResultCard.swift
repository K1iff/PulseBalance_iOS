import SwiftUI

struct PredictionResultCard: View {
    @AppStorage("colorBlindFilterMode") private var colorBlindFilterRaw: String = ColorBlindFilterMode.none.rawValue

    let result: StressPredictionResult

    private var activePalette: ColorBlindFilterMode {
        ColorBlindFilterMode(rawValue: colorBlindFilterRaw) ?? .none
    }

    private var tierColor: Color {
        result.tier.resolvedColor(using: activePalette)
    }

    private var sortedProbabilities: [(label: String, value: Double)] {
        result.probabilities
            .map { (label: $0.key, value: $0.value) }
            .sorted { $0.value > $1.value }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(tierColor.opacity(0.15))
                        .frame(width: 56, height: 56)

                    Image(systemName: result.tier.iconName)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(tierColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(result.tier.displayTitle.uppercased())
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundStyle(tierColor)

                    if let confidenceText = result.formattedConfidence {
                        Text(confidenceText)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()
            }

            Text(result.tier.summary)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            if !sortedProbabilities.isEmpty {
                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Class Probability Breakdown")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)

                    ForEach(sortedProbabilities, id: \.label) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(item.label.capitalized)
                                    .font(.caption.weight(.medium))
                                Spacer()
                                Text("\(Int((item.value * 100).rounded()))%")
                                    .font(.caption.monospacedDigit())
                                    .foregroundStyle(.secondary)
                            }

                            GeometryReader { proxy in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Color.secondary.opacity(0.15))
                                        .frame(height: 6)

                                    Capsule()
                                        .fill(tierColor)
                                        .frame(
                                            width: max(0, min(proxy.size.width, proxy.size.width * item.value)),
                                            height: 6
                                        )
                                }
                            }
                            .frame(height: 6)
                        }
                    }
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Recommended Actions")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                ForEach(result.tier.recommendations, id: \.self) { tip in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(tierColor)
                            .padding(.top, 2)

                        Text(tip)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    List {
        PredictionResultCard(
            result: StressPredictionResult(
                rawLabel: "High",
                probabilities: ["Low": 0.08, "Moderate": 0.16, "High": 0.76]
            )
        )
    }
}
