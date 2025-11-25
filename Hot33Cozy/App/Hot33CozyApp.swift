import SwiftUI

@main
struct Hot33CozyApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView()
                    .preferredColorScheme(.dark)
            } else {
                OnboardingView()
            }
        }
    }
}
