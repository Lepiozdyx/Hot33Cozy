import Foundation
import Combine
import SwiftUI

final class TimerViewModel: ObservableObject {
    @Published var remainingTime: Int
    @Published var isRunning = false
    @Published var showCompletionOverlay = false
    @Published var drinkName: String
    @Published var notes: String
    
    private let defaultTime = 900
    private var totalTime: Int
    private var timer: AnyCancellable?
    private var backgroundDate: Date?
    
    init(presetTime: Int? = nil, drinkName: String = "", autoStart: Bool = false) {
        self.totalTime = presetTime ?? defaultTime
        self.remainingTime = totalTime
        self.drinkName = drinkName
        self.notes = ""
        
        if autoStart {
            start()
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return Double(remainingTime) / Double(totalTime)
    }
    
    var timeString: String {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func start() {
        guard !isRunning else { return }
        isRunning = true
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    func stop() {
        isRunning = false
        timer?.cancel()
        timer = nil
    }
    
    func reset() {
        stop()
        remainingTime = totalTime
        showCompletionOverlay = false
    }
    
    func selectDrink(recipe: Recipe) {
        stop()
        totalTime = recipe.brewingTime
        remainingTime = totalTime
        drinkName = recipe.name
    }
    
    private func tick() {
        guard remainingTime > 0 else {
            complete()
            return
        }
        remainingTime -= 1
    }
    
    private func complete() {
        stop()
        showCompletionOverlay = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.showCompletionOverlay = false
            self?.reset()
        }
    }
    
    @objc private func appWillResignActive() {
        if isRunning {
            backgroundDate = Date()
        }
    }
    
    @objc private func appDidBecomeActive() {
        guard isRunning, let backgroundDate = backgroundDate else { return }
        
        let elapsed = Int(Date().timeIntervalSince(backgroundDate))
        remainingTime = max(0, remainingTime - elapsed)
        
        if remainingTime == 0 {
            complete()
        }
        
        self.backgroundDate = nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

