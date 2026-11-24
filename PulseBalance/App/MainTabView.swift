import SwiftUI
import SwiftData

struct MainTabView: View {
    @AppStorage("colorBlindFilterMode") private var colorBlindFilterRaw: String = ColorBlindFilterMode.none.rawValue
    @ObservedObject var authViewModel: AuthViewModel

    private var activePalette: ColorBlindFilterMode {
        ColorBlindFilterMode(rawValue: colorBlindFilterRaw) ?? .none
    }

    var body: some View {
        TabView {
            PredictionView(currentUser: authViewModel.currentUser)
                .tabItem {
                    Label("Checkup", systemImage: "sparkles.rectangle.stack.fill")
                }

            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "chart.bar.xaxis")
                }

            SettingsView(authViewModel: authViewModel)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(activePalette.primaryAccent)
    }
}

#Preview {
    MainTabView(authViewModel: AuthViewModel())
        .modelContainer(for: [UserAccount.self, SavedStressEntry.self], inMemory: true)
}
