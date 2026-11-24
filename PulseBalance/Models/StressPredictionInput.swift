import Foundation

enum GenderOption: Int, CaseIterable, Identifiable {
    case female = 0
    case male = 1

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .female: return "Female"
        case .male: return "Male"
        }
    }
}

enum GamingGenreOption: Int, CaseIterable, Identifiable {
    case action = 0
    case rpg = 1
    case shooter = 2
    case strategy = 3
    case casualOrOther = 4

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .action: return "Action"
        case .rpg: return "RPG"
        case .shooter: return "Shooter"
        case .strategy: return "Strategy"
        case .casualOrOther: return "Casual / Other"
        }
    }
}

struct StressPredictionInput: Equatable {
    var age: Double = 24.0
    var gender: GenderOption = .female
    var studyHours: Double = 5.0
    var sleepHours: Double = 7.0
    var attendance: Double = 90.0
    var gamingGenre: GamingGenreOption = .action
    var socialActivity: Double = 5.0
    var deviceUsage: Double = 6.0
    var reactionTimeMs: Double = 250.0
    var addictionScore: Double = 3.0
    var grades: Double = 85.0

    /// Returns the 11 numerical features in the exact index order expected by GamingPerformanceModel.
    func toFeatureArray() -> [Double] {
        [
            age,
            Double(gender.rawValue),
            studyHours,
            sleepHours,
            attendance,
            Double(gamingGenre.rawValue),
            socialActivity,
            deviceUsage,
            reactionTimeMs,
            addictionScore,
            grades
        ]
    }
}

extension StressPredictionInput {
    static let balancedRoutine = StressPredictionInput(
        age: 25,
        gender: .female,
        studyHours: 4.5,
        sleepHours: 8.0,
        attendance: 95,
        gamingGenre: .casualOrOther,
        socialActivity: 6.5,
        deviceUsage: 4.5,
        reactionTimeMs: 240,
        addictionScore: 2.0,
        grades: 88
    )

    static let deadlineCrunch = StressPredictionInput(
        age: 27,
        gender: .male,
        studyHours: 9.5,
        sleepHours: 4.5,
        attendance: 82,
        gamingGenre: .strategy,
        socialActivity: 2.0,
        deviceUsage: 10.5,
        reactionTimeMs: 340,
        addictionScore: 4.0,
        grades: 76
    )

    static let lateNightGamer = StressPredictionInput(
        age: 22,
        gender: .male,
        studyHours: 2.0,
        sleepHours: 5.0,
        attendance: 70,
        gamingGenre: .shooter,
        socialActivity: 3.0,
        deviceUsage: 11.5,
        reactionTimeMs: 210,
        addictionScore: 8.0,
        grades: 68
    )
}
