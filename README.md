# Pulse Balance 🫀

PulseBalance is a SwiftUI-based iOS application designed to help users, particularly students, predict and understand their stress levels by analyzing daily lifestyle factors, academic habits, and digital behavior. It leverages a local CoreML model to provide personalized stress assessments and actionable recommendations, all while prioritizing user privacy with on-device data storage and authentication.

[![Swift](https://img.shields.io/badge/Swift-5.7-orange?style=for-the-badge&logo=swift)]() [![SwiftData](https://img.shields.io/badge/SwiftData-supported-blue?style=for-the-badge)]() [![CoreML](https://img.shields.io/badge/CoreML-integrated-brightgreen?style=for-the-badge)]()

## 🚀 Features

-   **ML-Powered Stress Prediction** 🧠: Utilizes a built-in CoreML model (`GamingPerformanceModel.mlmodel`) to predict stress levels (Low, Moderate, High) based on 11 lifestyle and performance inputs.
-   **Data-Driven Insights** 📊: Presents visualizations showing the correlation between key factors—like sleep duration, study hours, and device usage—and predicted stress levels.
-   **Secure Local Authentication** 🔒: Features an on-device account system using SwiftData. Passwords are never transmitted and are stored securely using a salted SHA-256 hash.
-   **Persistent Checkup History** 📜: Automatically saves each stress prediction to a local history, allowing users to track their well-being over time.
-   **Customizable Appearance** ✨: Includes full support for Light Mode, Dark Mode, and System-based themes.
-   **Advanced Accessibility** ♿: Offers multiple color vision filters (Protanopia, Deuteranopia, Tritanopia, Monochrome) that adapt the entire app's color palette for users with color blindness.

## ⚙️ How It Works

1.  **Local Account** 👤: The user creates a secure, on-device account. All data, including credentials and checkup history, is stored locally using SwiftData.
2.  **Input Metrics** 📝: In the "Checkup" tab, the user provides input across several categories:
    *   **Personal:** Age, Gender
    *   **Lifestyle:** Daily study/work hours, sleep hours, social activity
    *   **Digital Habits:** Primary gaming genre, daily device usage, gaming intensity
    *   **Performance:** Academic grades, schedule consistency, reaction time
3.  **Prediction** 🔮: The app feeds the input array into the `GamingPerformanceModel` CoreML model.
4.  **Analysis** 📈: The model returns a predicted stress tier (Low, Moderate, or High) along with class probabilities.
5.  **Results & Recommendations** ✅: The app displays the result with a confidence score, a probability breakdown, and a list of actionable recommendations tailored to the predicted stress level. The result is then saved to the user's local history.

## 🛠️ Technology Stack

-   **UI Framework:** SwiftUI
-   **Data Persistence:** SwiftData
-   **Machine Learning:** CoreML
-   **Security:** CryptoKit (for SHA-256 password hashing)
-   **Charting:** Swift Charts

## 📂 Project Structure

The project is organized using a feature-based MVVM architecture.

```
PulseBalance/
├── App/                # App entry point, main TabView, and root container
├── Models/             # Data models (SwiftData, ML I/O, App Preferences)
├── Resources/          # Assets catalog and the CoreML model
├── Services/           # Business logic (Auth, ML Prediction, Hashing)
├── ViewModels/         # State management and logic for views
└── Views/              # SwiftUI views organized by feature
    ├── Auth/           # Splash, Sign In/Up screens
    ├── Insights/       # Charts and data visualizations
    ├── Prediction/     # Main checkup form and result display
    └── Settings/       # Account, Appearance, and History settings
```

## 🚀 Getting Started

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/K1iff/PulseBalance_iOS.git
    ```
2.  **Open `PulseBalance.xcodeproj`** in Xcode.
3.  Select a target simulator or a connected physical device.
4.  **Build and run** the project (⌘+R).

## 📚 Usage Examples

*   **Perform a Stress Checkup:** Navigate to the "Checkup" tab, input your daily lifestyle and academic data, and tap "Predict Stress Level" to get an immediate assessment and personalized recommendations.
*   **Analyze Trends:** Visit the "Insights" tab to view charts and data visualizations that illustrate the correlation between various lifestyle factors and stress levels.
*   **Customize Appearance:** In the "Settings" tab, adjust the app's color scheme (Light, Dark, System) and enable color vision filters for accessibility.
*   **Manage Account:** The "Settings" tab also allows you to view your profile, check your recent history, and sign out.

## ✨ Contributing

Contributions are welcome! Please feel free to:

-   Fork the repository.
-   Create a new branch for your feature (`git checkout -b feature/AmazingFeature`).
-   Commit your changes (`git commit -m 'Add some AmazingFeature'`).
-   Push to the branch (`git push origin feature/AmazingFeature`).
-   Open a Pull Request.

Please ensure your code adheres to the existing style and conventions.

## 📜 License

No license information was provided for this repository.

## 🔗 Important Links

*   **Repository:** [PulseBalance_iOS](https://github.com/K1iff/PulseBalance_iOS)

---

### 🌟 Show your support!

Give a ⭐️ if this project helped you!

Made with ❤️ by [K1iff](https://github.com/K1iff)


---
**<p align="center">Generated by [ReadmeCodeGen](https://www.readmecodegen.com/)</p>**
