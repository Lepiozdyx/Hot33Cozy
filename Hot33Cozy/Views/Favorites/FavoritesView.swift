import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var recipeManager: RecipeManager
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 12)
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
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(recipeManager.favoriteRecipes) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                    RecipeCardView(recipe: recipe) {
                                        recipeManager.toggleFavorite(recipeID: recipe.id)
                                    }
                                }
                            }
                        }
                        .padding()
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

