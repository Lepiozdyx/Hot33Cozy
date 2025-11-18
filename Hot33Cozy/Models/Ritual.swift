import Foundation
import Combine

struct Ritual: Identifiable, Codable {
    let id: UUID
    var title: String
    var notes: String?
    var date: Date
    var temperature: String?
    var brewingTime: Int?
    var drinkID: Int?
    var imageData: Data?
    
    init(
        id: UUID = UUID(),
        title: String,
        notes: String? = nil,
        date: Date = Date(),
        temperature: String? = nil,
        brewingTime: Int? = nil,
        drinkID: Int? = nil,
        imageData: Data? = nil
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.date = date
        self.temperature = temperature
        self.brewingTime = brewingTime
        self.drinkID = drinkID
        self.imageData = imageData
    }
}

