import Foundation
import Combine

struct Recipe: Identifiable, Codable {
    let id: Int
    var name: String
    var temperature: String
    var brewingTime: Int
    var ingredients: [String]
    var description: String
    var imageName: String
    var isFavorite: Bool
    var isCustom: Bool
    
    static let mock = Recipe(
        id: 2,
        name: "Best Slow Cooker Hot Chocolate",
        temperature: "80°C",
        brewingTime: 15,
        ingredients: [
            "1.5 cups heavy whipping cream",
            "1 (14 oz) can sweetened condensed milk",
            "6 cups milk",
            "1.5 tsp vanilla extract",
            "2 cups chocolate chips (semi-sweet or milk)"
          ],
        description: "1. Pour all ingredients into a slow cooker.\n2. Cover and cook on low for 2 hours, stirring occasionally, until chocolate chips are melted.\n3. Whisk well before serving to ensure mixture is smooth.\n4. Ladle into mugs and serve warm.",
        imageName: "BestSlowCookerHotChocolate"
    )
    
    init(
        id: Int,
        name: String,
        temperature: String,
        brewingTime: Int,
        ingredients: [String],
        description: String,
        imageName: String,
        isFavorite: Bool = false,
        isCustom: Bool = false
    ) {
        self.id = id
        self.name = name
        self.temperature = temperature
        self.brewingTime = brewingTime
        self.ingredients = ingredients
        self.description = description
        self.imageName = imageName
        self.isFavorite = isFavorite
        self.isCustom = isCustom
    }
}

