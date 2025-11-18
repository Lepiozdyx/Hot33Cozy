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

