import SwiftUI
import Combine
import UserNotifications

@MainActor
class PomodoroViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var timeRemaining: Int
    @Published var phase: TimerPhase = .work
    @Published var status: TimerStatus = .idle
    @Published var completedSessions: Int = 0
    @Published var settings: TimerSettings
    @Published var stats: PomodoroStats
    
    // MARK: - Private Properties
    private var timer: AnyCancellable?
    private let storage = StorageService()
    private let sound = SoundService()
    private let notification = NotificationService()
    private let blocker = BlockerService()
    
    // MARK: - Computed Properties
    var progress: Double {
        let total = settings.duration(for: phase)
        return Double(total - timeRemaining) / Double(total)
    }
    
    var timeString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var phaseColor: Color {
        switch phase {
        case .work:
            return Color(red: 1.0, green: 0.39, blue: 0.28) // Tomato
        case .shortBreak, .longBreak:
            return Color(red: 0.6, green: 1.0, blue: 0.6) // Mint
        }
    }
    
    // MARK: - Initialization
    init() {
        let loadedSettings = StorageService().loadSettings()
        self.settings = loadedSettings
        self.stats = StorageService().loadStats()
        self.timeRemaining = loadedSettings.workDuration
        
        notification.requestPermission()
        blocker.cleanup() // Ensure no residual blocks on startup
    }
    
    // MARK: - Timer Controls
    func start() {
        status = .running
        
        // Block social media if enabled and in work phase
        if settings.blockingEnabled && phase == .work {
            blocker.blockSocialMedia()
        }
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    func pause() {
        status = .paused
        timer?.cancel()
        timer = nil
        
        // Always unblock when paused
        if settings.blockingEnabled {
            blocker.unblockSocialMedia()
        }
    }
    
    func reset() {
        pause() // Pause already handles unblocking
        status = .idle
        timeRemaining = settings.duration(for: phase)
    }
    
    func skip() {
        pause()
        moveToNextPhase()
    }
    
    func togglePlayPause() {
        if status == .running {
            pause()
        } else {
            start()
        }
    }
    
    // MARK: - Private Methods
    private func tick() {
        guard timeRemaining > 0 else {
            timerCompleted()
            return
        }
        timeRemaining -= 1
    }
    
    private func timerCompleted() {
        pause() // Pause handles unblocking
        
        // Record stats if work session completed
        if phase == .work {
            let focusMinutes = settings.workDuration / 60
            stats.recordSession(focusMinutes: focusMinutes)
            storage.saveStats(stats)
            completedSessions += 1
        }
        
        // Play sound and show notification
        if settings.soundEnabled {
            sound.playCompletionSound()
        }
        
        if settings.notificationsEnabled {
            notification.sendNotification(for: phase)
        }
        
        moveToNextPhase()
    }
    
    private func moveToNextPhase() {
        // Ensure unblocking happens if we explicitly move phases
        if settings.blockingEnabled {
            blocker.unblockSocialMedia()
        }
        
        // Delegate business logic to the Model (SRP)
        phase = TimerPhase.next(after: phase, completedSessions: completedSessions)
        
        timeRemaining = settings.duration(for: phase)
        status = .idle
    }
    
    // MARK: - Settings
    func updateSettings() {
        storage.saveSettings(settings)
        if status == .idle {
            timeRemaining = settings.duration(for: phase)
        }
    }
}
