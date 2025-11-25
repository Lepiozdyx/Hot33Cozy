import SwiftUI

struct MainTabView: View {
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var recipeManager = RecipeManager.shared
    @State private var selectedTab: Tabs = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .recipes:
                    RecipeBookView()
                case .timer:
                    TimerView()
                case .stats:
                    StatisticsView()
                case .favs:
                    FavoritesView()
                }
            }
            
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
        .accentColor(.tabIconActive)
        .environmentObject(dataManager)
        .environmentObject(recipeManager)
    }
}

enum Tabs: CaseIterable, Hashable {
    case home, recipes, timer, stats, favs
    
    var title: String {
        switch self {
        case .home:
            "Home"
        case .recipes:
            "Recipes"
        case .timer:
            "Timer"
        case .stats:
            "Stats"
        case .favs:
            "Favorites"
        }
    }
    
    var icon: ImageResource {
        switch self {
        case .home: .home
        case .recipes: .recipe
        case .timer: .timer
        case .stats: .stats
        case .favs: .favs
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tabs
    private let cornerRadius: CGFloat = 20
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.tabBarBackground)
            
            HStack(spacing: 0) {
                ForEach(Tabs.allCases, id: \.self) { tab in
                    TabButton(
                        tab: tab,
                        isSelected: tab == selectedTab,
                        action: {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                selectedTab = tab
                            }
                        }
                    )
                    if tab != Tabs.allCases.last {
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 90)
        .padding(.horizontal)
    }
}

struct TabButton: View {
    let tab: Tabs
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(tab.icon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(height: isSelected ? 35 : 30)
                    .foregroundStyle(isSelected ? .accent : .secondary)
                
                Text(tab.title)
                    .font(.bodySecondary)
                    .foregroundStyle(isSelected ? .green : .tabIconInactive)
            }
            .padding(2)
//            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainTabView()
}

