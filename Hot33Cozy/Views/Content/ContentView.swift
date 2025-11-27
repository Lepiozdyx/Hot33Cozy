import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var manager = StateManager()
        
    var body: some View {
        Group {
            switch manager.appState {
            case .request:
                LoadingView()
                
            case .support:
                if let url = manager.networkManager.cozyURL {
                    WKWebViewManager(
                        url: url,
                        webManager: manager.networkManager
                    )
                } else {
                    WKWebViewManager(
                        url: NetworkManager.initURL,
                        webManager: manager.networkManager
                    )
                }
                
            case .loading:
                if hasCompletedOnboarding {
                    MainTabView()
                        .preferredColorScheme(.dark)
                } else {
                    OnboardingView()
                }
            }
        }
        .onAppear {
            manager.stateRequest()
        }
    }
}

#Preview {
    ContentView()
}
