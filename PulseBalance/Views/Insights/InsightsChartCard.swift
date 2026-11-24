import SwiftUI
import Charts

struct InsightsChartCard: View {
    @AppStorage("colorBlindFilterMode") private var colorBlindFilterRaw: String = ColorBlindFilterMode.none.rawValue

    let metric: InsightMetric

    private var activePalette: ColorBlindFilterMode {
        ColorBlindFilterMode(rawValue: colorBlindFilterRaw) ?? .none
    }

    private var cardBackgroundColor: Color {
        #if canImport(UIKit)
        Color(UIColor.secondarySystemGroupedBackground)
        #else
        Color(nsColor: .controlBackgroundColor)
        #endif
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(activePalette.secondaryAccent.opacity(0.15))
                        .frame(width: 40, height: 40)

                    Image(systemName: metric.iconName)
                        .font(.title3)
                        .foregroundStyle(activePalette.secondaryAccent)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(metric.title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(metric.keyTakeaway)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(activePalette.primaryAccent)
                }

                Spacer()
            }

            chartView
                .frame(
                    height: metric.chartStyle == .horizontalBar
                        ? CGFloat(metric.dataPoints.count * 52)
                        : 200
                )
                .padding(.vertical, 4)

            Text(metric.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(activePalette.secondaryAccent.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding()
        .background(cardBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    private var chartView: some View {
        switch metric.chartStyle {
        case .area:
            Chart(metric.dataPoints) { item in
                AreaMark(
                    x: .value("Category", item.category),
                    y: .value("Stress Impact", item.stressImpact)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            activePalette.primaryAccent.opacity(0.35),
                            activePalette.primaryAccent.opacity(0.05)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                LineMark(
                    x: .value("Category", item.category),
                    y: .value("Stress Impact", item.stressImpact)
                )
                .foregroundStyle(activePalette.primaryAccent)
                .lineStyle(StrokeStyle(lineWidth: 3))

                PointMark(
                    x: .value("Category", item.category),
                    y: .value("Stress Impact", item.stressImpact)
                )
                .foregroundStyle(activePalette.primaryAccent)
                .annotation(position: .top) {
                    Text("\(item.stressImpact)%")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .chartYScale(domain: 0...110)

        case .line:
            Chart(metric.dataPoints) { item in
                LineMark(
                    x: .value("Category", item.category),
                    y: .value("Stress Impact", item.stressImpact)
                )
                .foregroundStyle(activePalette.secondaryAccent)
                .lineStyle(StrokeStyle(lineWidth: 3))

                PointMark(
                    x: .value("Category", item.category),
                    y: .value("Stress Impact", item.stressImpact)
                )
                .foregroundStyle(activePalette.primaryAccent)
                .symbolSize(90)
                .annotation(position: .top) {
                    Text("\(item.stressImpact)%")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .chartYScale(domain: 0...110)

        case .verticalBar:
            Chart(metric.dataPoints) { item in
                BarMark(
                    x: .value("Category", item.category),
                    y: .value("Stress Impact", item.stressImpact)
                )
                .foregroundStyle(activePalette.primaryAccent.gradient)
                .cornerRadius(6)
                .annotation(position: .top) {
                    Text("\(item.stressImpact)%")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .chartYScale(domain: 0...110)

        case .horizontalBar:
            Chart(metric.dataPoints) { item in
                BarMark(
                    x: .value("Stress Impact", item.stressImpact),
                    y: .value("Category", item.category)
                )
                .foregroundStyle(activePalette.secondaryAccent.gradient)
                .cornerRadius(6)
                .annotation(position: .trailing) {
                    Text("\(item.stressImpact)%")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .chartXScale(domain: 0...105)

        case .pie:
            Chart(metric.dataPoints) { item in
                SectorMark(
                    angle: .value("Stress Impact", item.stressImpact),
                    innerRadius: .ratio(0.52),
                    angularInset: 2
                )
                .foregroundStyle(by: .value("Category", item.category))
                .annotation(position: .overlay) {
                    Text("\(item.stressImpact)%")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                }
            }
            .chartForegroundStyleScale(range: activePalette.chartSeriesColors)
        }
    }
}

#Preview {
    InsightsChartCard(
        metric: InsightMetric(
            title: "Sleep Duration",
            iconName: "bed.double.fill",
            keyTakeaway: "Optimal Window: 7–9 Hours",
            description: "Balanced sleep drastically lowers predicted stress.",
            chartStyle: .area,
            dataPoints: [
                InsightDataPoint(category: "< 5h", stressImpact: 92),
                InsightDataPoint(category: "5–7h", stressImpact: 65),
                InsightDataPoint(category: "7–9h", stressImpact: 20),
                InsightDataPoint(category: "> 9h", stressImpact: 35)
            ]
        )
    )
    .padding()
}
