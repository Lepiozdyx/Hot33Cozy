import SwiftUI

struct MainTabView: View {
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var recipeManager = RecipeManager.shared
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            RecipeBookView()
                .tabItem {
                    Label("Recipes", systemImage: "book")
                }
            
            TimerView()
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
            
            StatisticsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
        .accentColor(.tabIconActive)
        .environmentObject(dataManager)
        .environmentObject(recipeManager)
    }
}

#Preview {
    MainTabView()
}

