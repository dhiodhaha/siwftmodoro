import Foundation

/// Daily statistics record
struct DailyStats: Codable, Identifiable {
    var id: String { date }
    let date: String  // Format: yyyy-MM-dd
    var sessionsCompleted: Int
    var totalFocusMinutes: Int
}

/// Overall statistics for the Pomodoro app
struct PomodoroStats: Codable {
    var totalSessions: Int = 0
    var totalFocusMinutes: Int = 0
    var dailyHistory: [DailyStats] = []
    
    /// Get today's date string
    private static var todayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    /// Get or create today's stats
    mutating func todayStats() -> DailyStats {
        let today = Self.todayString
        if let existing = dailyHistory.first(where: { $0.date == today }) {
            return existing
        }
        let newStats = DailyStats(date: today, sessionsCompleted: 0, totalFocusMinutes: 0)
        dailyHistory.insert(newStats, at: 0)
        return newStats
    }
    
    /// Record a completed work session
    mutating func recordSession(focusMinutes: Int) {
        totalSessions += 1
        totalFocusMinutes += focusMinutes
        
        let today = Self.todayString
        if let index = dailyHistory.firstIndex(where: { $0.date == today }) {
            dailyHistory[index].sessionsCompleted += 1
            dailyHistory[index].totalFocusMinutes += focusMinutes
        } else {
            let newStats = DailyStats(
                date: today,
                sessionsCompleted: 1,
                totalFocusMinutes: focusMinutes
            )
            dailyHistory.insert(newStats, at: 0)
        }
        
        // Keep only last 30 days
        if dailyHistory.count > 30 {
            dailyHistory = Array(dailyHistory.prefix(30))
        }
    }
    
    /// Get stats for last 7 days
    func lastSevenDays() -> [DailyStats] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var result: [DailyStats] = []
        let calendar = Calendar.current
        
        for dayOffset in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) else { continue }
            let dateString = formatter.string(from: date)
            
            if let existing = dailyHistory.first(where: { $0.date == dateString }) {
                result.append(existing)
            } else {
                result.append(DailyStats(date: dateString, sessionsCompleted: 0, totalFocusMinutes: 0))
            }
        }
        
        return result.reversed()
    }
    
    /// Sessions completed today
    var todaySessions: Int {
        let today = Self.todayString
        return dailyHistory.first(where: { $0.date == today })?.sessionsCompleted ?? 0
    }
}
