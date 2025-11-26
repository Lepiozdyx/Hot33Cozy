import Foundation
import Combine

enum TimePeriod: String, CaseIterable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
}

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let label: String
    let count: Int
}

@MainActor
final class StatisticsViewModel: ObservableObject {
    @Published var selectedPeriod: TimePeriod = .day
    @Published var chartData: [ChartDataPoint] = []
    @Published var detailedRituals: [(String, [Ritual])] = []
    
    private let dataManager = DataManager.shared
    
    func loadData() {
        let rituals = dataManager.rituals
        
        switch selectedPeriod {
        case .day:
            loadDayData(rituals: rituals)
        case .week:
            loadWeekData(rituals: rituals)
        case .month:
            loadMonthData(rituals: rituals)
        }
        
        loadDetailedRituals(rituals: rituals)
    }
    
    private func loadDayData(rituals: [Ritual]) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let todayRituals = rituals.filter { ritual in
            calendar.isDate(ritual.date, inSameDayAs: today)
        }
        
        var hourCounts: [Int: Int] = [:]
        for ritual in todayRituals {
            let hour = calendar.component(.hour, from: ritual.date)
            hourCounts[hour, default: 0] += 1
        }
        
        chartData = (0...23).map { hour in
            ChartDataPoint(
                label: "\(hour):00",
                count: hourCounts[hour] ?? 0
            )
        }
    }
    
    private func loadWeekData(rituals: [Ritual]) {
        let calendar = Calendar.current
        let today = Date()
        
        chartData = (0..<7).reversed().map { daysAgo in
            guard let date = calendar.date(byAdding: .day, value: -daysAgo, to: today) else {
                return ChartDataPoint(label: "", count: 0)
            }
            
            let count = rituals.filter { ritual in
                calendar.isDate(ritual.date, inSameDayAs: date)
            }.count
            
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"
            let label = formatter.string(from: date)
            
            return ChartDataPoint(label: label, count: count)
        }
    }
    
    private func loadMonthData(rituals: [Ritual]) {
        let calendar = Calendar.current
        let today = Date()
        
        chartData = (0..<4).reversed().map { weeksAgo in
            guard let startOfWeek = calendar.date(byAdding: .weekOfYear, value: -weeksAgo, to: today) else {
                return ChartDataPoint(label: "Week \(weeksAgo + 1)", count: 0)
            }
            
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) ?? startOfWeek
            
            let count = rituals.filter { ritual in
                ritual.date >= startOfWeek && ritual.date <= endOfWeek
            }.count
            
            return ChartDataPoint(label: "Week \(4 - weeksAgo)", count: count)
        }
    }
    
    private func loadDetailedRituals(rituals: [Ritual]) {
        let calendar = Calendar.current
        
        let filteredRituals: [Ritual]
        switch selectedPeriod {
        case .day:
            filteredRituals = rituals.filter { calendar.isDateInToday($0.date) }
        case .week:
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
            filteredRituals = rituals.filter { $0.date >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .day, value: -30, to: Date()) ?? Date()
            filteredRituals = rituals.filter { $0.date >= monthAgo }
        }
        
        let grouped = Dictionary(grouping: filteredRituals) { ritual -> Date in
            calendar.startOfDay(for: ritual.date)
        }
        
        let sorted = grouped.sorted { $0.key > $1.key }
        
        detailedRituals = sorted.map { date, rituals in
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

