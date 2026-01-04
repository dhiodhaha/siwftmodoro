import SwiftUI

struct TimerView: View {
    @EnvironmentObject var viewModel: PomodoroViewModel
    
    private let lineWidth: CGFloat = 12
    private let size: CGFloat = 200
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(
                    viewModel.phaseColor.opacity(0.2),
                    lineWidth: lineWidth
                )
            
            // Progress circle
            Circle()
                .trim(from: 0, to: viewModel.progress)
                .stroke(
                    viewModel.phaseColor,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.5), value: viewModel.progress)
            
            // Time display
            VStack(spacing: 4) {
                Text(viewModel.timeString)
                    .font(.system(size: 48, weight: .light, design: .monospaced))
                    .foregroundStyle(.primary)
                
                Text(viewModel.phase.title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: size, height: size)
    }
}

