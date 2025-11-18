import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var rituals: [Ritual] = []
    
    private let dataManager = DataManager.shared
    
    init() {
        loadRituals()
    }
    
    func loadRituals() {
        rituals = dataManager.rituals
    }
    
    func saveRitual(_ ritual: Ritual) {
        dataManager.saveRitual(ritual)
        loadRituals()
    }
    
    func deleteRitual(_ ritual: Ritual) {
        dataManager.deleteRitual(ritual)
        loadRituals()
    }
    
    func groupedRituals() -> [(String, [Ritual])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: rituals) { ritual -> Date in
            calendar.startOfDay(for: ritual.date)
        }
        
        let sorted = grouped.sorted { $0.key > $1.key }
        
        return sorted.map { date, rituals in
            let title: String
            if calendar.isDateInToday(date) {
                title = "Today"
            } else if calendar.isDateInYesterday(date) {
                title = "Yesterday"
            } else {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                title = formatter.string(from: date)
            }
            return (title, rituals.sorted { $0.date > $1.date })
        }
    }
}

