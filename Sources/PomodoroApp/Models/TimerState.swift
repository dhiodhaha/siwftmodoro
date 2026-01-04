import Foundation

/// Represents the current phase of the Pomodoro timer
enum TimerPhase: String, Codable {
    case work = "Focus Time"
    case shortBreak = "Short Break"
    case longBreak = "Long Break"
    
    var title: String {
        rawValue
    }
    
    var defaultDuration: Int {
        switch self {
        case .work: return 25 * 60  // 25 minutes
        case .shortBreak: return 5 * 60  // 5 minutes
        case .longBreak: return 15 * 60  // 15 minutes
        }
    }
    
    var accentColor: String {
        switch self {
        case .work: return "AccentRed"
        case .shortBreak, .longBreak: return "AccentGreen"
        }
    }
    
    /// Business Logic: Determine the next phase based on current phase and completed sessions
    static func next(after current: TimerPhase, completedSessions: Int) -> TimerPhase {
        switch current {
        case .work:
            // After 4 work sessions, take a long break
            if completedSessions > 0 && completedSessions % 4 == 0 {
                return .longBreak
            } else {
                return .shortBreak
            }
        case .shortBreak, .longBreak:
            return .work
        }
    }
}

/// Represents the current status of the timer
enum TimerStatus {
    case idle
    case running
    case paused
}

/// User-configurable settings for timer durations
struct TimerSettings: Codable {
    var workDuration: Int = 25 * 60
    var shortBreakDuration: Int = 5 * 60
    var longBreakDuration: Int = 15 * 60
    var soundEnabled: Bool = true
    var notificationsEnabled: Bool = true
    var blockingEnabled: Bool = false
    
    func duration(for phase: TimerPhase) -> Int {
        switch phase {
        case .work: return workDuration
        case .shortBreak: return shortBreakDuration
        case .longBreak: return longBreakDuration
        }
    }
}
