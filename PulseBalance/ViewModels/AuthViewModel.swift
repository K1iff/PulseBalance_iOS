import Foundation
import SwiftUI
import SwiftData
import Combine

enum AuthMode: String, CaseIterable, Identifiable {
    case signIn = "Sign In"
    case signUp = "Create Account"

    var id: String { rawValue }
}

@MainActor
final class AuthViewModel: ObservableObject {
    @AppStorage("activeUserEmail") private var activeUserEmail: String = ""

    @Published var mode: AuthMode = .signIn
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    @Published private(set) var currentUser: UserAccount?

    private let authService = AuthService()

    var isAuthenticated: Bool {
        currentUser != nil
    }

    var passwordMeetsLength: Bool {
        password.count >= 8
    }

    var passwordHasLetterAndNumber: Bool {
        password.rangeOfCharacter(from: .letters) != nil &&
        password.rangeOfCharacter(from: .decimalDigits) != nil
    }

    func restoreSession(using context: ModelContext) {
        guard !activeUserEmail.isEmpty else {
            currentUser = nil
            return
        }

        do {
            if let account = try authService.fetchAccount(byEmail: activeUserEmail, in: context) {
                currentUser = account
            } else {
                activeUserEmail = ""
                currentUser = nil
            }
        } catch {
            activeUserEmail = ""
            currentUser = nil
        }
    }

    func submit(using context: ModelContext) {
        errorMessage = nil

        do {
            let account: UserAccount
            switch mode {
            case .signIn:
                account = try authService.signIn(
                    email: email,
                    password: password,
                    in: context
                )
            case .signUp:
                account = try authService.register(
                    fullName: fullName,
                    email: email,
                    password: password,
                    confirmPassword: confirmPassword,
                    in: context
                )
            }

            currentUser = account
            activeUserEmail = account.email
            clearSensitiveFields()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func switchMode(to newMode: AuthMode) {
        mode = newMode
        errorMessage = nil
        confirmPassword = ""
    }

    func signOut() {
        currentUser = nil
        activeUserEmail = ""
        clearSensitiveFields()
    }

    private func clearSensitiveFields() {
        password = ""
        confirmPassword = ""
        errorMessage = nil
    }
}   
