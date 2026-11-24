//
//  StressPredictionService.swift
//  PulseBalance
//
//  Created by Ryzel Realon on 11/24/26.
//

import Foundation
import CoreML

enum StressPredictionError: LocalizedError {
    case modelUnavailable(String)
    case tensorAllocationFailed
    case inferenceFailed(String)

    var errorDescription: String? {
        switch self {
        case .modelUnavailable(let reason):
            return "Unable to load the stress prediction model: \(reason)"
        case .tensorAllocationFailed:
            return "Unable to allocate the input feature array for prediction."
        case .inferenceFailed(let reason):
            return "Prediction failed: \(reason)"
        }
    }
}

protocol StressPredicting {
    func predict(using input: StressPredictionInput) async throws -> StressPredictionResult
}

final class StressPredictionService: StressPredicting {
    private var cachedModel: GamingPerformanceModel?

    private func loadModel() throws -> GamingPerformanceModel {
        if let cachedModel {
            return cachedModel
        }

        do {
            let configuration = MLModelConfiguration()
            let model = try GamingPerformanceModel(configuration: configuration)
            cachedModel = model
            return model
        } catch {
            throw StressPredictionError.modelUnavailable(error.localizedDescription)
        }
    }

    func predict(using input: StressPredictionInput) async throws -> StressPredictionResult {
        let model = try loadModel()
        let features = input.toFeatureArray()

        guard let featureArray = try? MLMultiArray(
            shape: [1, NSNumber(value: features.count)],
            dataType: .double
        ) else {
            throw StressPredictionError.tensorAllocationFailed
        }

        for (index, value) in features.enumerated() {
            featureArray[index] = NSNumber(value: value)
        }

        do {
            let modelInput = GamingPerformanceModelInput(input: featureArray)
            let prediction = try await model.prediction(input: modelInput)
            let rawLabel = String(prediction.classLabel)

            var probabilities: [String: Double] = [:]
            for (key, value) in prediction.classProbability {
                probabilities[String(key)] = value
            }

            return StressPredictionResult(
                rawLabel: rawLabel,
                probabilities: probabilities
            )
        } catch {
            throw StressPredictionError.inferenceFailed(error.localizedDescription)
        }
    }
}
