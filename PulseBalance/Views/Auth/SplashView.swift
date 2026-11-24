import SwiftUI

struct SplashView: View {
    @AppStorage("colorBlindFilterMode") private var colorBlindFilterRaw: String = ColorBlindFilterMode.none.rawValue

    @State private var logoScale: CGFloat = 0.72
    @State private var logoOpacity: Double = 0.0
    @State private var pulseRingScale: CGFloat = 0.85
    @State private var pulseRingOpacity: Double = 0.55
    @State private var textOffset: CGFloat = 16
    @State private var textOpacity: Double = 0.0

    let onFinished: () -> Void

    private var activePalette: ColorBlindFilterMode {
        ColorBlindFilterMode(rawValue: colorBlindFilterRaw) ?? .none
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    activePalette.primaryAccent.opacity(0.14),
                    activePalette.secondaryAccent.opacity(0.10),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [activePalette.primaryAccent, activePalette.secondaryAccent],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2.5
                        )
                        .frame(width: 148, height: 148)
                        .scaleEffect(pulseRingScale)
                        .opacity(pulseRingOpacity)

                    Circle()
                        .fill(activePalette.primaryAccent.opacity(0.10))
                        .frame(width: 124, height: 124)

                    Image("BrandLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 84, height: 84)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                VStack(spacing: 8) {
                    Text("Pulse Balance")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [activePalette.primaryAccent, activePalette.secondaryAccent],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text("Mindful Habits. Measurable Calm.")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                }
                .offset(y: textOffset)
                .opacity(textOpacity)
            }
            .padding()
        }
        .onAppear {
            startEntranceAnimation()
        }
    }

    private func startEntranceAnimation() {
        withAnimation(.spring(response: 0.65, dampingFraction: 0.72)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }

        withAnimation(.easeOut(duration: 1.2).repeatForever(autoreverses: false)) {
            pulseRingScale = 1.32
            pulseRingOpacity = 0.0
        }

        withAnimation(.easeOut(duration: 0.55).delay(0.25)) {
            textOffset = 0
            textOpacity = 1.0
        }

        Task {
            try? await Task.sleep(for: .seconds(1.85))
            await MainActor.run {
                onFinished()
            }
        }
    }
}

#Preview {
    SplashView(onFinished: {})
}
