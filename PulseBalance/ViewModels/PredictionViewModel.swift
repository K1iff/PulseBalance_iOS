//
//  PredictionViewModel.swift
//  PulseBalance
//
//  Created by Ryzel Realon on 11/24/26.
//

import Foundation
import Combine

@MainActor
final class PredictionViewModel: ObservableObject {
    @Published var input = StressPredictionInput()
    @Published private(set) var result: StressPredictionResult?
    @Published private(set) var isPredicting = false
    @Published var errorMessage: String?

    private let predictionService: StressPredicting

    init(predictionService: StressPredicting = StressPredictionService()) {
        self.predictionService = predictionService
    }

    func applyPreset(_ preset: StressPredictionInput) {
        input = preset
        errorMessage = nil
    }

    func resetInputs() {
        input = StressPredictionInput()
        result = nil
        errorMessage = nil
    }

    func predictStress() {
        guard !isPredicting else { return }

        isPredicting = true
        errorMessage = nil

        let currentInput = input
        let service = predictionService

        Task {
            do {
                let prediction = try await service.predict(using: currentInput)
                self.result = prediction
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isPredicting = false
        }
    }
}
