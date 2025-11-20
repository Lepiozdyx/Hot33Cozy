import SwiftUI

struct RecipeBookView: View {
    @EnvironmentObject private var recipeManager: RecipeManager
    @State private var showingAddRecipe = false
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundMain
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(recipeManager.allRecipes) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                RecipeCardView(recipe: recipe) {
                                    recipeManager.toggleFavorite(recipeID: recipe.id)
                                }
                            }
                        }
                    }
                    .padding(16)
                }
                .scrollIndicators(.hidden)
            }
            .navigationTitle("Recipe Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddRecipe = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(.textPrimary)
                    }
                }
            }
            .sheet(isPresented: $showingAddRecipe) {
                AddRecipeView()
            }
        }
    }
}

#Preview {
    RecipeBookView()
        .environmentObject(RecipeManager.shared)
        .environmentObject(DataManager.shared)
}

