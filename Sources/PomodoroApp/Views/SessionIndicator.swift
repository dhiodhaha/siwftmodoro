import SwiftUI

struct SessionIndicator: View {
    @EnvironmentObject var viewModel: PomodoroViewModel
    
    private let totalSessions = 4
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSessions, id: \.self) { index in
                Circle()
                    .fill(index < (viewModel.completedSessions % 4) ? viewModel.phaseColor : viewModel.phaseColor.opacity(0.3))
                    .frame(width: 10, height: 10)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.completedSessions)
            }
        }
    }
}

