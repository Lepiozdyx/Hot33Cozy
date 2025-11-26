import Foundation
import Combine

@MainActor
final class RecipeManager: ObservableObject {
    static let shared = RecipeManager()
    
    @Published var presetRecipes: [Recipe] = []
    
    private let favoritesKey = "favoriteRecipeIDs"
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        loadPresetRecipes()
        observeDataManager()
        loadCustomRecipeFavorites()
    }
    
    private func observeDataManager() {
        DataManager.shared.$customRecipes
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    var allRecipes: [Recipe] {
        presetRecipes + DataManager.shared.customRecipes
    }
    
    var favoriteRecipes: [Recipe] {
        allRecipes.filter { $0.isFavorite }
    }
    
    func toggleFavorite(recipeID: Int) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            if let index = self.presetRecipes.firstIndex(where: { $0.id == recipeID }) {
                self.presetRecipes[index].isFavorite.toggle()
                self.saveFavorites()
            } else if let recipe = DataManager.shared.customRecipes.first(where: { $0.id == recipeID }) {
                let newFavoriteStatus = !recipe.isFavorite
                DataManager.shared.updateFavoriteStatus(recipeID: recipeID, isFavorite: newFavoriteStatus)
                self.saveFavorites()
            }
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
              var recipes = try? JSONDecoder().decode([Recipe].self, from: data) else {
            return
        }
        
        let favoriteIDs = loadFavoriteIDs()
        
        for id in favoriteIDs {
            if let index = recipes.firstIndex(where: { $0.id == id }) {
                recipes[index].isFavorite = true
            }
        }
        
        presetRecipes = recipes
    }
    
    private func loadFavoriteIDs() -> [Int] {
        guard let favoriteIDs = UserDefaults.standard.array(forKey: favoritesKey) as? [String] else {
            return []
        }
        return favoriteIDs.compactMap { Int($0) }
    }
    
    private func saveFavorites() {
        let favoriteIDs = allRecipes.filter { $0.isFavorite }.map { String($0.id) }
        UserDefaults.standard.set(favoriteIDs, forKey: favoritesKey)
    }
    
    private func loadCustomRecipeFavorites() {
        let favoriteIDs = loadFavoriteIDs()
        
        let customRecipeIDs = favoriteIDs.filter { id in
            DataManager.shared.customRecipes.contains(where: { $0.id == id })
        }
        
        if !customRecipeIDs.isEmpty {
            Task { @MainActor in
                DataManager.shared.loadFavoritesForCustomRecipes(favoriteIDs: customRecipeIDs)
            }
        }
    }
}

