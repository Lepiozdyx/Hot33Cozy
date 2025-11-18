import SwiftUI

struct RecipeSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var recipeManager: RecipeManager
    @Binding var selectedRecipe: Recipe?
    
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    
    var filteredRecipes: [Recipe] {
        let allRecipes = recipeManager.allRecipes.sorted { $0.name < $1.name }
        
        if searchText.isEmpty {
            return allRecipes
        }
        return allRecipes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundMain
                    .ignoresSafeArea()
                    .onTapGesture {
                        isSearchFocused = false
                    }
                
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.textMuted)
                        
                        TextField("Search drinks...", text: $searchText)
                            .font(.bodyPrimary)
                            .foregroundColor(.textPrimary)
                            .focused($isSearchFocused)
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.textMuted)
                            }
                        }
                    }
                    .padding()
                    .background(Color.backgroundSurface)
                    .cornerRadius(10)
                    .padding()
                    
                    List {
                        ForEach(filteredRecipes) { recipe in
                            Button(action: {
                                selectedRecipe = recipe
                                dismiss()
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(recipe.name)
                                            .font(.h3CardTitle)
                                            .foregroundColor(.textPrimary)
                                        
                                        HStack(spacing: 12) {
                                            Text(recipe.temperature)
                                            Text("•")
                                            Text("\(recipe.brewingTime / 60)min")
                                        }
                                        .font(.bodySecondary)
                                        .foregroundColor(.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    if selectedRecipe?.id == recipe.id {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.accentYellow)
                                    }
                                }
                            }
                            .listRowBackground(Color.backgroundSurface)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Select Drink")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.textPrimary)
                }
            }
        }
    }
}

#Preview {
    RecipeSelectionView(selectedRecipe: .constant(nil))
        .environmentObject(RecipeManager.shared)
}

