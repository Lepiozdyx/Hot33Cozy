import Foundation
import Combine

@MainActor
final class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var rituals: [Ritual] = []
    @Published var customRecipes: [Recipe] = []
    
    private let ritualsKey = "savedRituals"
    private let customRecipesKey = "customRecipes"
    
    private init() {
        loadRituals()
        loadCustomRecipes()
    }
    
    func saveRitual(_ ritual: Ritual) {
        if let index = rituals.firstIndex(where: { $0.id == ritual.id }) {
            rituals[index] = ritual
        } else {
            rituals.insert(ritual, at: 0)
        }
        saveRituals()
    }
    
    func deleteRitual(_ ritual: Ritual) {
        rituals.removeAll { $0.id == ritual.id }
        saveRituals()
    }
    
    func saveCustomRecipe(_ recipe: Recipe) {
        if let index = customRecipes.firstIndex(where: { $0.id == recipe.id }) {
            customRecipes[index] = recipe
        } else {
            customRecipes.append(recipe)
        }
        saveCustomRecipes()
    }
    
    func deleteCustomRecipe(_ recipe: Recipe) {
        customRecipes.removeAll { $0.id == recipe.id }
        saveCustomRecipes()
    }
    
    func updateFavoriteStatus(recipeID: Int, isFavorite: Bool) {
        if let index = customRecipes.firstIndex(where: { $0.id == recipeID }) {
            customRecipes[index].isFavorite = isFavorite
            saveCustomRecipes()
        }
    }
    
    func loadFavoritesForCustomRecipes(favoriteIDs: [Int]) {
        for id in favoriteIDs {
            if let index = customRecipes.firstIndex(where: { $0.id == id }) {
                customRecipes[index].isFavorite = true
            }
        }
        saveCustomRecipes()
    }
    
    func generateRecipeID() -> Int {
        RecipeManager.shared.generateNextID()
    }
    
    private func saveRituals() {
        if let encoded = try? JSONEncoder().encode(rituals) {
            UserDefaults.standard.set(encoded, forKey: ritualsKey)
        }
    }
    
    private func loadRituals() {
        if let data = UserDefaults.standard.data(forKey: ritualsKey),
           let decoded = try? JSONDecoder().decode([Ritual].self, from: data) {
            rituals = decoded
        }
    }
    
    private func saveCustomRecipes() {
        if let encoded = try? JSONEncoder().encode(customRecipes) {
            UserDefaults.standard.set(encoded, forKey: customRecipesKey)
        }
    }
    
    private func loadCustomRecipes() {
        if let data = UserDefaults.standard.data(forKey: customRecipesKey),
           let decoded = try? JSONDecoder().decode([Recipe].self, from: data) {
            customRecipes = decoded
        }
    }
}

