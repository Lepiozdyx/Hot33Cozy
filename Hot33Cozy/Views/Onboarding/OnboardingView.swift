import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "img_onb1",
            title: "Mindfulness in every cup",
            description: "Write down what and when you drink — turn ordinary drinks into cozy habits."
        ),
        OnboardingPage(
            icon: "img_onb2",
            title: "Brew with perfect precision",
            description: "Use the built-in timer and recipes to make perfect drinks every time, from green tea to cocoa with pepper."
        ),
        OnboardingPage(
            icon: "img_onb3",
            title: "Track your warm habits",
            description: "Look at how many cups you've drunk, what your favorite drinks are, and how your rituals are changing."
        )
    ]
    
    var body: some View {
        ZStack {
            Color.backgroundMain
                .ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .automatic))
                .ignoresSafeArea(edges: .top)
                
                Button {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        hasCompletedOnboarding = true
                    }
                } label: {
                    Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                }
                .buttonStyle(.primary)
                .padding(.horizontal)
                .padding(.bottom, 20)
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
        VStack(spacing: 20) {
            Image(page.icon)
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()

            VStack(spacing: 8) {
                Text(page.title)
                    .font(.onbTitle)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)

                Text(page.description)
                    .font(.h1ScreenTitle)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .ignoresSafeArea(edges: .top)
    }
}


#Preview {
    OnboardingView()
}

