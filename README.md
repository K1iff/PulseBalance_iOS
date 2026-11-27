# Pulse Balance

A native iOS wellness and performance analytics application built with SwiftUI and Core ML that predicts user stress levels and visualizes lifestyle insights for gamers and everyday users.

![Platform](https://img.shields.io/badge/Platform-iOS%2016.0%2B-000000?style=for-the-badge&logo=apple&logoColor=white)
![Language](https://img.shields.io/badge/Swift-5.9-F05138?style=for-the-badge&logo=swift&logoColor=white)
![Framework](https://img.shields.io/badge/Framework-SwiftUI-007AFF?style=for-the-badge&logo=swift&logoColor=white)
![ML Engine](https://img.shields.io/badge/ML-Core%20ML-34C759?style=for-the-badge&logo=apple&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-5856D6?style=for-the-badge)

---

## Features

* **On-Device Stress Prediction:** Evaluates lifestyle, sleep, and gaming performance metrics locally using Core ML (`GamingPerformanceModel.mlmodel`) to generate real-time stress predictions without external server latency.
* **Interactive Wellness Insights:** Visualizes historical trends and biometric/lifestyle correlations through custom SwiftUI insight cards and charts (`InsightsChartCard`).
* **Secure Local Authentication:** Provides splash onboarding, account registration, and credential validation backed by cryptographic hashing (`SecurityHasher` & `AuthService`).
* **Customizable App Preferences:** Allows users to manage account details, reset prediction history, and tailor tracking settings via `SettingsView`.
* **Clean Tabbed Navigation:** Organizes Prediction, Insights, and Settings into an intuitive native tab interface (`MainTabView`).

---

## How it Works

PulseBalance follows a clean **MVVM (Model–View–ViewModel)** architecture paired with a local service layer:

1. **Authentication Flow:** On launch, `PulseBalanceApp` displays `SplashView` and routes unauthenticated users to `AuthView`. `AuthViewModel` delegates credential hashing and persistence to `AuthService` and `SecurityHasher`.
2. **Input & Inference:** Inside `PredictionView`, users log daily habits and performance indicators (`StressPredictionInput`). `PredictionViewModel` passes these inputs to `StressPredictionService`, which runs on-device inference against `GamingPerformanceModel.mlmodel` and returns a structured `StressPredictionResult`.
3. **Analytics & Visualization:** `InsightsViewModel` aggregates prediction metrics (`InsightMetric`) and renders visual summaries inside `InsightsView` using `InsightsChartCard`.

---

## Tech Stack

* **Language:** Swift 5
* **UI Framework:** SwiftUI
* **Machine Learning:** Core ML (`GamingPerformanceModel.mlmodel`)
* **Security & Storage:** CryptoKit / Local Hashing (`SecurityHasher`), `UserDefaults` / AppStorage (`AppPreferences`)
* **Architecture:** MVVM (Model–View–ViewModel)
* **IDE & Build System:** Xcode (`PulseBalance.xcodeproj`)

---

## Project Structure

```text
PulseBalance_iOS/
├── PulseBalance.xcodeproj/             # Xcode project configuration and schemes
├── PulseBalance/
│   ├── App/
│   │   ├── PulseBalanceApp.swift       # Application entry point & root state
│   │   └── MainTabView.swift           # Primary bottom tab bar navigation
│   ├── Models/
│   │   ├── AppPreferences.swift        # Persistent user settings & preferences
│   │   ├── InsightMetric.swift         # Data model for analytics charts
│   │   ├── StressPredictionInput.swift # Input parameters for Core ML inference
│   │   ├── StressPredictionResult.swift# Structured prediction output & recommendations
│   │   └── UserAccount.swift           # User profile and credential model
│   ├── Resources/
│   │   ├── Assets.xcassets/            # AppIcon, AccentColor, and BrandLogo SVG
│   │   └── GamingPerformanceModel.mlmodel # Pre-trained Core ML prediction model
│   ├── Services/
│   │   ├── AuthService.swift           # Account creation & session validation
│   │   ├── SecurityHasher.swift        # Password hashing & security utilities
│   │   └── StressPredictionService.swift # Core ML wrapper & scoring logic
│   ├── ViewModels/
│   │   ├── AuthViewModel.swift         # State management for login & registration
│   │   ├── InsightsViewModel.swift     # Data aggregation for wellness charts
│   │   └── PredictionViewModel.swift   # State management for stress predictions
│   └── Views/
│       ├── Auth/
│       │   ├── SplashView.swift        # Branded launch screen
│       │   └── AuthView.swift          # Login & sign-up interface
│       ├── Insights/
│       │   ├── InsightsView.swift      # Main analytics dashboard
│       │   └── InsightsChartCard.swift # Reusable visual metric card
│       ├── Prediction/
│       │   ├── PredictionView.swift    # Interactive lifestyle/gaming input form
│       │   └── PredictionResultCard.swift # Stress score & feedback display card
│       └── Settings/
│           └── SettingsView.swift      # User preferences & account controls
└── README.md
```

---

## Getting Started

### Prerequisites

* **macOS** 13.0 (Ventura) or later
* **Xcode** 15.0 or later
* **iOS Simulator** or physical iPhone running **iOS 16.0+**

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/k1iff/pulsebalance_ios.git
   cd pulsebalance_ios
   ```

2. **Open the project in Xcode:**
   ```bash
   open PulseBalance.xcodeproj
   ```

3. **Select a target device:**
   * In the top Xcode toolbar, choose an iOS Simulator (e.g., **iPhone 15 Pro**) or connect your physical iOS device.

4. **Build and run:**
   * Press `Cmd + R` (or click the **Run** button) to compile the app and launch it in the simulator.

---

## Usage Examples

### Running a Stress Prediction
1. Launch the app and create a local profile on the **Sign Up** screen (or log in with an existing account).
2. Navigate to the **Prediction** tab.
3. Adjust the sliders and input fields for your daily habits, sleep duration, and session metrics (`StressPredictionInput`).
4. Tap **Analyze / Predict** to view your computed stress level and actionable wellness feedback inside `PredictionResultCard`.

### Reviewing Wellness Trends
1. Switch to the **Insights** tab in `MainTabView`.
2. Inspect your aggregated `InsightMetric` cards to track changes in stress patterns over time.

---

## How to Contribute

Contributions, bug reports, and feature suggestions are welcome!

1. **Fork** the repository (`https://github.com/k1iff/pulsebalance_ios`).
2. **Create a new feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Commit your changes** with clear, descriptive messages:
   ```bash
   git commit -m "Add: description of your feature or fix"
   ```
4. **Push to your branch:**
   ```bash
   git push origin feature/your-feature-name
   ```
5. Open a **Pull Request** detailing your changes and any UI/model updates.

---

## Important Links

* **Repository:** [github.com/k1iff/pulsebalance_ios](https://github.com/k1iff/pulsebalance_ios)
* **Issue Tracker:** [github.com/k1iff/pulsebalance_ios/issues](https://github.com/k1iff/pulsebalance_ios/issues)
* **Apple Core ML Documentation:** [developer.apple.com/documentation/coreml](https://developer.apple.com/documentation/coreml)
* **SwiftUI Documentation:** [developer.apple.com/documentation/swiftui](https://developer.apple.com/documentation/swiftui)

---

Made by [k1iff](https://github.com/k1iff)
