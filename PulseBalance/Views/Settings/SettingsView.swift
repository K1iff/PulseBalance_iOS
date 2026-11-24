import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("appThemeMode") private var themeModeRaw: String = AppThemeMode.system.rawValue
    @AppStorage("colorBlindFilterMode") private var colorBlindFilterRaw: String = ColorBlindFilterMode.none.rawValue

    @ObservedObject var authViewModel: AuthViewModel
    @State private var showSignOutConfirmation = false

    private var activeTheme: AppThemeMode {
        AppThemeMode(rawValue: themeModeRaw) ?? .system
    }

    private var activePalette: ColorBlindFilterMode {
        ColorBlindFilterMode(rawValue: colorBlindFilterRaw) ?? .none
    }

    private var sortedEntries: [SavedStressEntry] {
        (authViewModel.currentUser?.entries ?? [])
            .sorted { $0.recordedAt > $1.recordedAt }
    }

    var body: some View {
        NavigationStack {
            Form {
                // Account Profile Section
                if let user = authViewModel.currentUser {
                    Section {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(activePalette.primaryAccent.opacity(0.15))
                                    .frame(width: 52, height: 52)

                                Text(initials(for: user.fullName))
                                    .font(.headline.bold())
                                    .foregroundStyle(activePalette.primaryAccent)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullName)
                                    .font(.headline)

                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)

                                Text("Member since \(user.createdAt.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    } header: {
                        Label("Account Profile", systemImage: "person.crop.circle.fill")
                            .foregroundStyle(activePalette.secondaryAccent)
                    }
                }

                // Appearance (Dark Mode) Section
                Section {
                    Picker("Color Scheme", selection: $themeModeRaw) {
                        ForEach(AppThemeMode.allCases) { mode in
                            Label(mode.rawValue, systemImage: mode.iconName)
                                .tag(mode.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Label("Appearance", systemImage: "moon.stars.fill")
                        .foregroundStyle(activePalette.secondaryAccent)
                } footer: {
                    Text("Switch between Light Mode, Dark Mode, or match your device system setting.")
                }

                // Accessibility / Color-Blind Filters Section
                Section {
                    Picker("Color Vision Filter", selection: $colorBlindFilterRaw) {
                        ForEach(ColorBlindFilterMode.allCases) { filter in
                            Text(filter.rawValue).tag(filter.rawValue)
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text(activePalette.subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 8) {
                            palettePreviewBadge(tier: .low, label: "Low")
                            palettePreviewBadge(tier: .moderate, label: "Moderate")
                            palettePreviewBadge(tier: .high, label: "High")
                        }
                    }
                    .padding(.vertical, 4)
                } header: {
                    Label("Color Blind Accessibility", systemImage: "eye.fill")
                        .foregroundStyle(activePalette.secondaryAccent)
                } footer: {
                    Text("Adapts stress indicators, charts, and accent highlights for color-vision accessibility.")
                }

                // Saved Checkup History
                if !sortedEntries.isEmpty {
                    Section {
                        ForEach(sortedEntries.prefix(5)) { entry in
                            let tier = StressTier(rawLabel: entry.tierRawValue)
                            HStack {
                                Image(systemName: tier.iconName)
                                    .foregroundStyle(tier.resolvedColor(using: activePalette))

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(tier.displayTitle)
                                        .font(.subheadline.weight(.semibold))
                                    Text("Sleep \(entry.sleepHours, specifier: "%.1f")h • Screen \(entry.deviceUsageHours, specifier: "%.1f")h")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Text(entry.recordedAt.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .onDelete(perform: deleteEntries)
                    } header: {
                        Label("Recent Stress Checkups", systemImage: "clock.arrow.circlepath")
                            .foregroundStyle(activePalette.secondaryAccent)
                    }
                }

                // Sign Out Section
                Section {
                    Button(role: .destructive) {
                        showSignOutConfirmation = true
                    } label: {
                        HStack {
                            Spacer()
                            Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                                .font(.headline)
                            Spacer()
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Settings")
            .confirmationDialog(
                "Sign out of Pulse Balance?",
                isPresented: $showSignOutConfirmation,
                titleVisibility: .visible
            ) {
                Button("Sign Out", role: .destructive) {
                    authViewModel.signOut()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Your local account and saved checkup history remain securely stored on this device.")
            }
        }
    }

    private func palettePreviewBadge(tier: StressTier, label: String) -> some View {
        let color = tier.resolvedColor(using: activePalette)
        return HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(label)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(color)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color.opacity(0.14))
        .clipShape(Capsule())
    }

    private func initials(for name: String) -> String {
        let parts = name.split(separator: " ")
        let letters = parts.prefix(2).compactMap { $0.first }
        return letters.isEmpty ? "PB" : String(letters).uppercased()
    }

    private func deleteEntries(at offsets: IndexSet) {
        let currentList = sortedEntries
        for index in offsets {
            guard index < currentList.count else { continue }
            modelContext.delete(currentList[index])
        }
        try? modelContext.save()
    }
}

#Preview {
    SettingsView(authViewModel: AuthViewModel())
        .modelContainer(for: [UserAccount.self, SavedStressEntry.self], inMemory: true)
}
