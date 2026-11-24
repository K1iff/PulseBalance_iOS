//
//  InsightsViewModel.swift
//  PulseBalance
//
//  Created by Ryzel Realon on 11/24/26.
//

import Foundation
import Combine

enum InsightFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case lifestyle = "Lifestyle & Rest"
    case academics = "Academics"
    case gaming = "Gaming & Tech"

    var id: String { rawValue }
}

@MainActor
final class InsightsViewModel: ObservableObject {
    @Published var selectedFilter: InsightFilter = .all
    @Published private(set) var metrics: [InsightMetric] = []

    init() {
        loadMetrics()
    }

    var filteredMetrics: [InsightMetric] {
        switch selectedFilter {
        case .all:
            return metrics
        case .lifestyle:
            return metrics.filter {
                $0.title == "Sleep Duration" || $0.title == "Gender Distribution"
            }
        case .academics:
            return metrics.filter {
                $0.title == "Study Hours" || $0.title == "Class Attendance"
            }
        case .gaming:
            return metrics.filter {
                $0.title == "Gaming Hours" || $0.title == "Daily Device Usage"
            }
        }
    }

    private func loadMetrics() {
        metrics = [
            InsightMetric(
                title: "Sleep Duration",
                iconName: "bed.double.fill",
                keyTakeaway: "Optimal Window: 7–9 Hours",
                description: "Notice the U-Curve: acute stress spikes among sleep-deprived students (< 5h), drops sharply at 7–9 hours, and rises slightly for oversleepers.",
                chartStyle: .area,
                dataPoints: [
                    InsightDataPoint(category: "< 5h", stressImpact: 92),
                    InsightDataPoint(category: "5–7h", stressImpact: 65),
                    InsightDataPoint(category: "7–9h", stressImpact: 20),
                    InsightDataPoint(category: "> 9h", stressImpact: 35)
                ]
            ),
            InsightMetric(
                title: "Study Hours",
                iconName: "book.closed.fill",
                keyTakeaway: "Sweet Spot: 2–5 Hours Daily",
                description: "Balanced daily study blocks keep stress low. Both under-preparing (< 2h) and marathon cramming (> 8h) drive up cognitive strain.",
                chartStyle: .line,
                dataPoints: [
                    InsightDataPoint(category: "< 2h", stressImpact: 70),
                    InsightDataPoint(category: "2–5h", stressImpact: 40),
                    InsightDataPoint(category: "5–8h", stressImpact: 55),
                    InsightDataPoint(category: "> 8h", stressImpact: 85)
                ]
            ),
            InsightMetric(
                title: "Class Attendance",
                iconName: "person.3.fill",
                keyTakeaway: "Target: Above 90%",
                description: "Falling below 75% attendance strongly correlates with compounding catch-up workload and elevated academic stress.",
                chartStyle: .verticalBar,
                dataPoints: [
                    InsightDataPoint(category: "< 75%", stressImpact: 88),
                    InsightDataPoint(category: "75–90%", stressImpact: 50),
                    InsightDataPoint(category: "> 90%", stressImpact: 25)
                ]
            ),
            InsightMetric(
                title: "Gaming Hours",
                iconName: "gamecontroller.fill",
                keyTakeaway: "Moderation: Under 5 Hours",
                description: "Casual and moderate gaming show lower stress impact, while heavy sessions (> 5h) correlate with reduced sleep and study recovery.",
                chartStyle: .horizontalBar,
                dataPoints: [
                    InsightDataPoint(category: "< 2h (Casual)", stressImpact: 30),
                    InsightDataPoint(category: "2–5h (Moderate)", stressImpact: 45),
                    InsightDataPoint(category: "> 5h (Heavy)", stressImpact: 80)
                ]
            ),
            InsightMetric(
                title: "Daily Device Usage",
                iconName: "iphone.gen3",
                keyTakeaway: "Healthy Cap: Under 6 Hours",
                description: "Extended total screen exposure beyond 8 hours per day amplifies mental fatigue and disrupts evening wind-down routines.",
                chartStyle: .verticalBar,
                dataPoints: [
                    InsightDataPoint(category: "< 4h", stressImpact: 28),
                    InsightDataPoint(category: "4–8h", stressImpact: 54),
                    InsightDataPoint(category: "> 8h", stressImpact: 84)
                ]
            ),
            InsightMetric(
                title: "Gender Distribution",
                iconName: "person.2.circle.fill",
                keyTakeaway: "Balanced Cohort Split",
                description: "Baseline distribution of elevated stress indicators observed across female and male student cohorts in the training dataset.",
                chartStyle: .pie,
                dataPoints: [
                    InsightDataPoint(category: "Female", stressImpact: 48),
                    InsightDataPoint(category: "Male", stressImpact: 52)
                ]
            )
        ]
    }
}
