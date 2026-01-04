import Foundation
import UserNotifications

class NotificationService {
    func requestPermission() {
        guard Bundle.main.bundleIdentifier != nil else {
            print("Notifications disabled: No bundle identifier found (running as executable?)")
            return
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func sendNotification(for phase: TimerPhase) {
        guard Bundle.main.bundleIdentifier != nil else { return }
        
        let content = UNMutableNotificationContent()
        
        switch phase {
        case .work:
            content.title = "Focus Session Complete! 🎉"
            content.body = "Great work! Time for a break."
        case .shortBreak:
            content.title = "Break's Over!"
            content.body = "Ready to focus again?"
        case .longBreak:
            content.title = "Long Break Complete!"
            content.body = "Feeling refreshed? Let's get back to work!"
        }
        
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil  // Deliver immediately
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to send notification: \(error.localizedDescription)")
            }
        }
    }
}
