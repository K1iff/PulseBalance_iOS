import SwiftUI
import SwiftData

@main
struct PulseBalanceApp: App {
    var body: some Scene {
        WindowGroup {
            RootContainerView()
        }
        .modelContainer(for: [UserAccount.self, SavedStressEntry.self])
    }
}

private struct RootContainerView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("appThemeMode") private var themeModeRaw: String = AppThemeMode.system.rawValue

    @StateObject private var authViewModel = AuthViewModel()
    @State private var isShowingSplash = true

    private var activeTheme: AppThemeMode {
        AppThemeMode(rawValue: themeModeRaw) ?? .system
    }

    var body: some View {
        ZStack {
            if isShowingSplash {
                SplashView {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        isShowingSplash = false
                    }
                }
                .transition(.opacity)
            } else if authViewModel.isAuthenticated {
                MainTabView(authViewModel: authViewModel)
                    .transition(.opacity)
            } else {
                AuthView(viewModel: authViewModel)
                    .transition(.opacity)
            }
        }
        .preferredColorScheme(activeTheme.colorScheme)
        .task {
            authViewModel.restoreSession(using: modelContext)
        }
    }
}
