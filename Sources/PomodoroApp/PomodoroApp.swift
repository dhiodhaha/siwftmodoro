import SwiftUI

@main
struct PomodoroApp: App {
    @StateObject private var viewModel = PomodoroViewModel()
    
    init() {
        // Force the app to the foreground even when run as an SPM executable
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
        // Removed .windowStyle(.hiddenTitleBar) temporarily so the window frame is visible
        .windowResizability(.contentSize)
        .defaultSize(width: 320, height: 480)
        
        Settings {
            SettingsView()
                .environmentObject(viewModel)
        }
    }
}
