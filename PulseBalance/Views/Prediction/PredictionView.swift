import SwiftUI
import SwiftData

struct PredictionView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("colorBlindFilterMode") private var colorBlindFilterRaw: String = ColorBlindFilterMode.none.rawValue

    @StateObject private var viewModel = PredictionViewModel()
    var currentUser: UserAccount?

    private var activePalette: ColorBlindFilterMode {
        ColorBlindFilterMode(rawValue: colorBlindFilterRaw) ?? .none
    }

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                Form {
                    Section {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Age")
                                Spacer()
                                Text("\(Int(viewModel.input.age)) yrs")
                                    .foregroundStyle(.secondary)
                                    .monospacedDigit()
                            }
                            Slider(value: $viewModel.input.age, in: 14...75, step: 1)
                                .tint(activePalette.primaryAccent)
                        }

                        Picker("Gender", selection: $viewModel.input.gender) {
                            ForEach(GenderOption.allCases) { option in
                                Text(option.label).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                    } header: {
                        Label("Personal Profile", systemImage: "person.fill")
                            .foregroundStyle(activePalette.secondaryAccent)
                    }

                    Section {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Daily Work / Study Focus")
                                Spacer()
                                Text("\(viewModel.input.studyHours, specifier: "%.1f") hrs")
                                    .foregroundStyle(.secondary)
                                    .monospacedDigit()
                            }
                            Slider(value: $viewModel.input.studyHours, in: 0...16, step: 0.5)
                                .tint(activePalette.primaryAccent)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Daily Sleep Hours")
                                Spacer()
                                Text("\(viewModel.input.sleepHours, specifier: "%.1f") hrs")
                                    .foregroundStyle(.secondary)
                                    .monospacedDigit()
                            }
                            Slider(value: $viewModel.input.sleepHours, in: 0...14, step: 0.5)
                                .tint(activePalette.primaryAccent)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Schedule Consistency")
                                Spacer()
                                Text("\(Int(viewModel.input.attendance))%")
                                    .foregroundStyle(.secondary)
                                    .monospacedDigit()
                            }
                            Slider(value: $viewModel.input.attendance, in: 0...100, step: 1)
                                .tint(activePalette.primaryAccent)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Performance / Output Score")
                                Spacer()
                                Text("\(Int(viewModel.input.grades)) / 100")
                                    .foregroundStyle(.secondary)
                                    .monospacedDigit()
                            }
                            Slider(value: $viewModel.input.grades, in: 50...100, step: 1)
                                .tint(activePalette.primaryAccent)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Social Activity Level")
                                Spacer()
                                Text("\(viewModel.input.socialActivity, specifier: "%.1f") / 10")
                                    .foregroundStyle(.secondary)
                                    .monospacedDigit()
                            }
                            Slider(value: $viewModel.input.socialActivity, in: 0...10, step: 0.5)
                                .tint(activePalette.primaryAccent)
                        }
                    } header: {
                        Label("Work, Rest & Lifestyle", systemImage: "heart.text.square.fill")
                            .foregroundStyle(activePalette.secondaryAccent)
                    }

                    Section {
                        Picker("Primary Gaming Genre", selection: $viewModel.input.gamingGenre) {
                            ForEach(GamingGenreOption.allCases) { genre in
                                Text(genre.label).tag(genre)
                            }
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Daily Device Usage")
                                Spacer()
                                Text("\(viewModel.input.deviceUsage, specifier: "%.1f") hrs")
                                    .foregroundStyle(.secondary)
                                    .monospacedDigit()
                            }
                            Slider(value: $viewModel.input.deviceUsage, in: 0...24, step: 0.5)
                                .tint(activePalette.primaryAccent)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Gaming Habit Intensity")
                                Spacer()
                                Text("\(Int(viewModel.input.addictionScore)) / 10")
                                    .foregroundStyle(.secondary)
                                    .monospacedDigit()
                            }
                            Slider(value: $viewModel.input.addictionScore, in: 0...10, step: 1)
                                .tint(activePalette.primaryAccent)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Average Reaction Time")
                                Spacer()
                                Text("\(Int(viewModel.input.reactionTimeMs)) ms")
                                    .foregroundStyle(.secondary)
                                    .monospacedDigit()
                            }
                            Slider(value: $viewModel.input.reactionTimeMs, in: 100...1000, step: 10)
                                .tint(activePalette.primaryAccent)
                        }
                    } header: {
                        Label("Digital & Gaming Habits", systemImage: "gamecontroller.fill")
                            .foregroundStyle(activePalette.secondaryAccent)
                    }

                    Section {
                        Button {
                            viewModel.predictStress()
                        } label: {
                            HStack(spacing: 10) {
                                Spacer()
                                if viewModel.isPredicting {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Image(systemName: "brain.head.profile")
                                }
                                Text(viewModel.isPredicting ? "Analyzing..." : "Predict Stress Level")
                                    .font(.headline)
                                Spacer()
                            }
                            .foregroundStyle(.white)
                            .padding(.vertical, 6)
                        }
                        .buttonStyle(.plain)
                        .disabled(viewModel.isPredicting)
                        .listRowBackground(activePalette.primaryAccent)
                    }

                    if let result = viewModel.result {
                        Section {
                            PredictionResultCard(result: result)
                                .id("predictionResultSection")
                        } header: {
                            Label("Analysis Result", systemImage: "doc.text.magnifyingglass")
                                .foregroundStyle(activePalette.secondaryAccent)
                        }
                    }
                }
                .formStyle(.grouped)
                .navigationTitle("Stress Checkup")
                .sensoryFeedback(.impact(weight: .medium), trigger: viewModel.result)
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Menu {
                            Section("Load Sample Routine") {
                                Button("Balanced Routine") {
                                    viewModel.applyPreset(.balancedRoutine)
                                }
                                Button("Deadline Crunch") {
                                    viewModel.applyPreset(.deadlineCrunch)
                                }
                                Button("Late-Night Gamer") {
                                    viewModel.applyPreset(.lateNightGamer)
                                }
                            }

                            Divider()

                            Button("Reset Defaults", role: .destructive) {
                                viewModel.resetInputs()
                            }
                        } label: {
                            Label("Presets", systemImage: "slider.horizontal.3")
                        }
                    }
                }
                .onChange(of: viewModel.result) { _, newValue in
                    guard let newValue else { return }
                    saveCheckupToHistory(result: newValue)
                    withAnimation(.easeInOut) {
                        proxy.scrollTo("predictionResultSection", anchor: .top)
                    }
                }
                .alert(
                    "Prediction Error",
                    isPresented: Binding(
                        get: { viewModel.errorMessage != nil },
                        set: { if !$0 { viewModel.errorMessage = nil } }
                    )
                ) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(viewModel.errorMessage ?? "")
                }
            }
        }
    }

    private func saveCheckupToHistory(result: StressPredictionResult) {
        guard let currentUser else { return }

        let entry = SavedStressEntry(
            tierRawValue: result.tier.rawValue,
            confidence: result.confidence,
            sleepHours: viewModel.input.sleepHours,
            workOrStudyHours: viewModel.input.studyHours,
            deviceUsageHours: viewModel.input.deviceUsage,
            account: currentUser
        )

        modelContext.insert(entry)
        try? modelContext.save()
    }
}

#Preview {
    PredictionView()
        .modelContainer(for: [UserAccount.self, SavedStressEntry.self], inMemory: true)
}
