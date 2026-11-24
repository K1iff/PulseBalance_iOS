//
//  InsightMetric.swift
//  PulseBalance
//
//  Created by Ryzel Realon on 11/24/26.
//

import Foundation

enum InsightChartStyle: String, CaseIterable {
    case area
    case line
    case verticalBar
    case horizontalBar
    case pie
}

struct InsightDataPoint: Identifiable, Equatable {
    let id: UUID
    let category: String
    let stressImpact: Int

    init(id: UUID = UUID(), category: String, stressImpact: Int) {
        self.id = id
        self.category = category
        self.stressImpact = stressImpact
    }
}

struct InsightMetric: Identifiable, Equatable {
    let id: UUID
    let title: String
    let iconName: String
    let keyTakeaway: String
    let description: String
    let chartStyle: InsightChartStyle
    let dataPoints: [InsightDataPoint]

    init(
        id: UUID = UUID(),
        title: String,
        iconName: String,
        keyTakeaway: String,
        description: String,
        chartStyle: InsightChartStyle,
        dataPoints: [InsightDataPoint]
    ) {
        self.id = id
        self.title = title
        self.iconName = iconName
        self.keyTakeaway = keyTakeaway
        self.description = description
        self.chartStyle = chartStyle
        self.dataPoints = dataPoints
    }
}
