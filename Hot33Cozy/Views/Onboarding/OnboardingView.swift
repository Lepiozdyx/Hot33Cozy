import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "cup.and.saucer.fill",
            title: "Track Your Rituals",
            description: "Record every warm beverage moment with notes, photos, and brewing details."
        ),
        OnboardingPage(
            icon: "book.fill",
            title: "Discover Recipes",
            description: "Explore curated tea and beverage recipes with precise brewing parameters."
        ),
        OnboardingPage(
            icon: "timer",
            title: "Perfect Timing",
            description: "Use the built-in timer to brew your drinks to perfection every time."
        )
    ]
    
    var body: some View {
        ZStack {
            Color.backgroundMain
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        hasCompletedOnboarding = true
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                }
                .buttonStyle(.primary)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: page.icon)
                .font(.system(size: 100))
                .foregroundColor(.accentYellow)
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.h1ScreenTitle)
                    .foregroundColor(.textPrimary)
                
                Text(page.description)
                    .font(.bodyPrimary)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    OnboardingView()
}

