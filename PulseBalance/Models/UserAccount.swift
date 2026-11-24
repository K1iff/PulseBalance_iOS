//
//  UserAccount.swift
//  PulseBalance
//
//  Created by Ryzel Realon on 11/24/26.
//

import Foundation
import SwiftData

@Model
final class UserAccount {
    @Attribute(.unique) var email: String
    var fullName: String
    var passwordSalt: String
    var passwordHash: String
    var createdAt: Date
    var lastLoginAt: Date

    @Relationship(deleteRule: .cascade, inverse: \SavedStressEntry.account)
    var entries: [SavedStressEntry] = []

    init(
        email: String,
        fullName: String,
        passwordSalt: String,
        passwordHash: String,
        createdAt: Date = Date(),
        lastLoginAt: Date = Date()
    ) {
        self.email = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        self.fullName = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        self.passwordSalt = passwordSalt
        self.passwordHash = passwordHash
        self.createdAt = createdAt
        self.lastLoginAt = lastLoginAt
    }
}

@Model
final class SavedStressEntry {
    var tierRawValue: String
    var confidence: Double?
    var sleepHours: Double
    var workOrStudyHours: Double
    var deviceUsageHours: Double
    var recordedAt: Date
    var account: UserAccount?

    init(
        tierRawValue: String,
        confidence: Double?,
        sleepHours: Double,
        workOrStudyHours: Double,
        deviceUsageHours: Double,
        recordedAt: Date = Date(),
        account: UserAccount? = nil
    ) {
        self.tierRawValue = tierRawValue
        self.confidence = confidence
        self.sleepHours = sleepHours
        self.workOrStudyHours = workOrStudyHours
        self.deviceUsageHours = deviceUsageHours
        self.recordedAt = recordedAt
        self.account = account
    }
}
