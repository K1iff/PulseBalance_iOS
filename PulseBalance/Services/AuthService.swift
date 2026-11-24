//
//  AuthService.swift
//  PulseBalance
//
//  Created by Ryzel Realon on 11/24/26.
//

import Foundation
import SwiftData

enum AuthError: LocalizedError {
    case emptyFullName
    case invalidEmailFormat
    case weakPassword
    case passwordMismatch
    case emailAlreadyRegistered
    case invalidCredentials
    case storageFailure(String)

    var errorDescription: String? {
        switch self {
        case .emptyFullName:
            return "Please enter your full name."
        case .invalidEmailFormat:
            return "Please enter a valid email address."
        case .weakPassword:
            return "Password must be at least 8 characters long and include both letters and numbers."
        case .passwordMismatch:
            return "Passwords do not match. Please re-enter them."
        case .emailAlreadyRegistered:
            return "An account with this email already exists. Try signing in instead."
        case .invalidCredentials:
            return "Incorrect email or password. Please verify your credentials."
        case .storageFailure(let reason):
            return "Database error: \(reason)"
        }
    }
}

@MainActor
final class AuthService {
    func register(
        fullName: String,
        email: String,
        password: String,
        confirmPassword: String,
        in context: ModelContext
    ) throws -> UserAccount {
        let trimmedName = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !trimmedName.isEmpty else {
            throw AuthError.emptyFullName
        }

        guard isValidEmail(normalizedEmail) else {
            throw AuthError.invalidEmailFormat
        }

        guard isStrongPassword(password) else {
            throw AuthError.weakPassword
        }

        guard password == confirmPassword else {
            throw AuthError.passwordMismatch
        }

        if try fetchAccount(byEmail: normalizedEmail, in: context) != nil {
            throw AuthError.emailAlreadyRegistered
        }

        let salt = SecurityHasher.generateSalt()
        let hash = SecurityHasher.hash(password: password, salt: salt)

        let newAccount = UserAccount(
            email: normalizedEmail,
            fullName: trimmedName,
            passwordSalt: salt,
            passwordHash: hash
        )

        context.insert(newAccount)

        do {
            try context.save()
            return newAccount
        } catch {
            throw AuthError.storageFailure(error.localizedDescription)
        }
    }

    func signIn(
        email: String,
        password: String,
        in context: ModelContext
    ) throws -> UserAccount {
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard isValidEmail(normalizedEmail), !password.isEmpty else {
            throw AuthError.invalidCredentials
        }

        guard let account = try fetchAccount(byEmail: normalizedEmail, in: context) else {
            throw AuthError.invalidCredentials
        }

        guard SecurityHasher.verify(
            password: password,
            salt: account.passwordSalt,
            expectedHash: account.passwordHash
        ) else {
            throw AuthError.invalidCredentials
        }

        account.lastLoginAt = Date()
        try? context.save()

        return account
    }

    func fetchAccount(byEmail email: String, in context: ModelContext) throws -> UserAccount? {
        let normalized = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let descriptor = FetchDescriptor<UserAccount>(
            predicate: #Predicate<UserAccount> { $0.email == normalized }
        )

        do {
            return try context.fetch(descriptor).first
        } catch {
            throw AuthError.storageFailure(error.localizedDescription)
        }
    }

    // MARK: - Validation Helpers

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }

    private func isStrongPassword(_ password: String) -> Bool {
        guard password.count >= 8 else { return false }
        let hasLetter = password.rangeOfCharacter(from: .letters) != nil
        let hasDigit = password.rangeOfCharacter(from: .decimalDigits) != nil
        return hasLetter && hasDigit
    }
}
