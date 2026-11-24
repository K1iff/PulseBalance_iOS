//
//  InsightsView.swift
//  PulseBalance
//
//  Created by Ryzel Realon on 11/24/26.
//

import SwiftUI

struct InsightsView: View {
    @StateObject private var viewModel = InsightsViewModel()

    private var groupedBackgroundColor: Color {
        #if canImport(UIKit)
        Color(UIColor.systemGroupedBackground)
        #else
        Color(nsColor: .windowBackgroundColor)
        #endif
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Risk Factors by Category")
                            .font(.title3.bold())
                            .foregroundStyle(.indigo)

                        Text("Explore how sleep, study habits, attendance, and screen exposure correlate with predicted student stress.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    Picker("Category Filter", selection: $viewModel.selectedFilter) {
                        ForEach(InsightFilter.allCases) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    LazyVStack(spacing: 18) {
                        ForEach(viewModel.filteredMetrics) { metric in
                            InsightsChartCard(metric: metric)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Model Insights")
            .background(groupedBackgroundColor)
        }
    }
}

#Preview {
    InsightsView()
}
