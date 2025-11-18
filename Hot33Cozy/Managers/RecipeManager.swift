import Foundation
import Combine

final class RecipeManager: ObservableObject {
    static let shared = RecipeManager()
    
    @Published var presetRecipes: [Recipe] = []
    
    private let favoritesKey = "favoriteRecipeIDs"
    
    private init() {
        loadPresetRecipes()
        loadFavorites()
    }
    
    var allRecipes: [Recipe] {
        presetRecipes + DataManager.shared.customRecipes
    }
    
    var favoriteRecipes: [Recipe] {
        allRecipes.filter { $0.isFavorite }
    }
    
    func toggleFavorite(recipeID: Int) {
        if let index = presetRecipes.firstIndex(where: { $0.id == recipeID }) {
            presetRecipes[index].isFavorite.toggle()
            saveFavorites()
        } else if let index = DataManager.shared.customRecipes.firstIndex(where: { $0.id == recipeID }) {
            DataManager.shared.customRecipes[index].isFavorite.toggle()
            DataManager.shared.saveCustomRecipe(DataManager.shared.customRecipes[index])
            saveFavorites()
        }
    }
    
    func getRecipe(by id: Int) -> Recipe? {
        allRecipes.first { $0.id == id }
    }
    
    func generateNextID() -> Int {
        let maxID = allRecipes.map { $0.id }.max() ?? 0
        return maxID + 1
    }
    
    private func loadPresetRecipes() {
        guard let url = Bundle.main.url(forResource: "drinks", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let recipes = try? JSONDecoder().decode([Recipe].self, from: data) else {
            return
        }
        presetRecipes = recipes
    }
    
    private func saveFavorites() {
        let favoriteIDs = allRecipes.filter { $0.isFavorite }.map { String($0.id) }
        UserDefaults.standard.set(favoriteIDs, forKey: favoritesKey)
    }
    
    private func loadFavorites() {
        guard let favoriteIDs = UserDefaults.standard.array(forKey: favoritesKey) as? [String] else {
            return
        }
        
        for idString in favoriteIDs {
            guard let id = Int(idString) else { continue }
            
            if let index = presetRecipes.firstIndex(where: { $0.id == id }) {
                presetRecipes[index].isFavorite = true
            }
        }
    }
}

