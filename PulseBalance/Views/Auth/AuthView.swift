import SwiftUI
import SwiftData

struct AuthView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("colorBlindFilterMode") private var colorBlindFilterRaw: String = ColorBlindFilterMode.none.rawValue

    @ObservedObject var viewModel: AuthViewModel

    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false

    private var activePalette: ColorBlindFilterMode {
        ColorBlindFilterMode(rawValue: colorBlindFilterRaw) ?? .none
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Brand Header
                    VStack(spacing: 12) {
                        Image("BrandLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 72, height: 72)
                            .padding(14)
                            .background(activePalette.primaryAccent.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 20))

                        Text("Pulse Balance")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(activePalette.primaryAccent)

                        Text(
                            viewModel.mode == .signIn
                            ? "Sign in to track and analyze your daily stress balance."
                            : "Create a local account to save your stress checkups securely on this device."
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    }
                    .padding(.top, 16)

                    // Mode Switcher
                    Picker("Authentication Mode", selection: Binding(
                        get: { viewModel.mode },
                        set: { viewModel.switchMode(to: $0) }
                    )) {
                        ForEach(AuthMode.allCases) { authMode in
                            Text(authMode.rawValue).tag(authMode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    // Form Fields
                    VStack(spacing: 16) {
                        if viewModel.mode == .signUp {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Full Name")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)

                                TextField("Enter your full name", text: $viewModel.fullName)
                                    .textContentType(.name)
                                    .padding(12)
                                    .background(Color.secondary.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email Address")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)

                            TextField("name@example.com", text: $viewModel.email)
                                .textContentType(.emailAddress)
                                #if os(iOS)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                #endif
                                .autocorrectionDisabled()
                                .padding(12)
                                .background(Color.secondary.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)

                            HStack {
                                Group {
                                    if isPasswordVisible {
                                        TextField("Enter password", text: $viewModel.password)
                                    } else {
                                        SecureField("Enter password", text: $viewModel.password)
                                    }
                                }
                                .textContentType(viewModel.mode == .signIn ? .password : .newPassword)

                                Button {
                                    isPasswordVisible.toggle()
                                } label: {
                                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundStyle(.secondary)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(12)
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        if viewModel.mode == .signUp {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Confirm Password")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)

                                HStack {
                                    Group {
                                        if isConfirmPasswordVisible {
                                            TextField("Re-enter password", text: $viewModel.confirmPassword)
                                        } else {
                                            SecureField("Re-enter password", text: $viewModel.confirmPassword)
                                        }
                                    }
                                    .textContentType(.newPassword)

                                    Button {
                                        isConfirmPasswordVisible.toggle()
                                    } label: {
                                        Image(systemName: isConfirmPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                            .foregroundStyle(.secondary)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(12)
                                .background(Color.secondary.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }

                            // Password Verification Checklist
                            VStack(alignment: .leading, spacing: 6) {
                                requirementRow(
                                    met: viewModel.passwordMeetsLength,
                                    label: "At least 8 characters"
                                )
                                requirementRow(
                                    met: viewModel.passwordHasLetterAndNumber,
                                    label: "Contains both letters and numbers"
                                )
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(.horizontal)

                    // Validation Error Banner
                    if let errorMessage = viewModel.errorMessage {
                        HStack(spacing: 10) {
                            Image(systemName: "exclamationmark.circle.fill")
                            Text(errorMessage)
                                .font(.footnote.weight(.medium))
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                        .foregroundStyle(.red)
                        .padding(12)
                        .background(Color.red.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                    }

                    // Primary Action Button
                    Button {
                        viewModel.submit(using: modelContext)
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: viewModel.mode == .signIn ? "lock.open.fill" : "person.badge.plus")
                            Text(viewModel.mode == .signIn ? "Sign In" : "Create Account")
                                .font(.headline)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(activePalette.primaryAccent)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)

                    // Local Security Note
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.shield.fill")
                            .foregroundStyle(activePalette.secondaryAccent)
                        Text("Credentials are salted and SHA-256 hashed locally on your device.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle(viewModel.mode.rawValue)
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }

    private func requirementRow(met: Bool, label: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: met ? "checkmark.circle.fill" : "circle")
                .font(.caption)
                .foregroundStyle(met ? activePalette.secondaryAccent : .secondary)

            Text(label)
                .font(.caption)
                .foregroundStyle(met ? .primary : .secondary)
        }
    }
}

#Preview {
    AuthView(viewModel: AuthViewModel())
        .modelContainer(for: [UserAccount.self, SavedStressEntry.self], inMemory: true)
}
