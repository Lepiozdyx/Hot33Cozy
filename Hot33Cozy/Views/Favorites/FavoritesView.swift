import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var recipeManager: RecipeManager
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundMain
                    .ignoresSafeArea()
                
                if recipeManager.favoriteRecipes.isEmpty {
                    EmptyStateView(
                        icon: "heart",
                        title: "No Favorites Yet",
                        message: "Tap the heart icon on any recipe to add it to your favorites."
                    )
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(recipeManager.favoriteRecipes) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                    RecipeCardView(recipe: recipe) {
                                        recipeManager.toggleFavorite(recipeID: recipe.id)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(RecipeManager.shared)
}

