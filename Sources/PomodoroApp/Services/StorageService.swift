import Foundation

class StorageService {
    private let settingsKey = "pomodoro_settings"
    private let statsKey = "pomodoro_stats"
    private let defaults = UserDefaults.standard
    
    // MARK: - Settings
    func saveSettings(_ settings: TimerSettings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            defaults.set(encoded, forKey: settingsKey)
        }
    }
    
    func loadSettings() -> TimerSettings {
        guard let data = defaults.data(forKey: settingsKey),
              let settings = try? JSONDecoder().decode(TimerSettings.self, from: data) else {
            return TimerSettings()
        }
        return settings
    }
    
    // MARK: - Statistics
    func saveStats(_ stats: PomodoroStats) {
        if let encoded = try? JSONEncoder().encode(stats) {
            defaults.set(encoded, forKey: statsKey)
        }
    }
    
    func loadStats() -> PomodoroStats {
        guard let data = defaults.data(forKey: statsKey),
              let stats = try? JSONDecoder().decode(PomodoroStats.self, from: data) else {
            return PomodoroStats()
        }
        return stats
    }
}
