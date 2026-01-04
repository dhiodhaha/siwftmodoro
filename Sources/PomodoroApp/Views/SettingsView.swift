import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: PomodoroViewModel
    
    var body: some View {
        Form {
            Section("Timer Durations") {
                durationStepper(
                    title: "Focus Duration",
                    value: Binding(
                        get: { viewModel.settings.workDuration / 60 },
                        set: { viewModel.settings.workDuration = $0 * 60 }
                    ),
                    range: 1...60,
                    unit: "min"
                )
                
                durationStepper(
                    title: "Short Break",
                    value: Binding(
                        get: { viewModel.settings.shortBreakDuration / 60 },
                        set: { viewModel.settings.shortBreakDuration = $0 * 60 }
                    ),
                    range: 1...30,
                    unit: "min"
                )
                
                durationStepper(
                    title: "Long Break",
                    value: Binding(
                        get: { viewModel.settings.longBreakDuration / 60 },
                        set: { viewModel.settings.longBreakDuration = $0 * 60 }
                    ),
                    range: 1...60,
                    unit: "min"
                )
            }
            
            Section("Notifications") {
                Toggle("Sound Effects", isOn: $viewModel.settings.soundEnabled)
                Toggle("System Notifications", isOn: $viewModel.settings.notificationsEnabled)
            }
            
            Section("Website Blocking") {
                Toggle("Block Social Media during Focus", isOn: $viewModel.settings.blockingEnabled)
                
                if viewModel.settings.blockingEnabled {
                    Text("⚠️ Requires Administrator Password to modify system hosts file each time blocking starts/ends.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 4)
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 350, height: 280)
        .onChange(of: viewModel.settings.workDuration) { _, _ in viewModel.updateSettings() }
        .onChange(of: viewModel.settings.shortBreakDuration) { _, _ in viewModel.updateSettings() }
        .onChange(of: viewModel.settings.longBreakDuration) { _, _ in viewModel.updateSettings() }
        .onChange(of: viewModel.settings.soundEnabled) { _, _ in viewModel.updateSettings() }
        .onChange(of: viewModel.settings.notificationsEnabled) { _, _ in viewModel.updateSettings() }
        .onChange(of: viewModel.settings.blockingEnabled) { _, _ in viewModel.updateSettings() }
    }
    
    private func durationStepper(title: String, value: Binding<Int>, range: ClosedRange<Int>, unit: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Stepper("\(value.wrappedValue) \(unit)", value: value, in: range)
        }
    }
}
