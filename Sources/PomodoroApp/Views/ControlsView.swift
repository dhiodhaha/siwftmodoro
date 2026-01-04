import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var viewModel: PomodoroViewModel
    
    var body: some View {
        HStack(spacing: 24) {
            // Reset button
            Button {
                viewModel.reset()
            } label: {
                Image(systemName: "arrow.counterclockwise")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .help("Reset Timer")
            
            // Play/Pause button
            Button {
                viewModel.togglePlayPause()
            } label: {
                ZStack {
                    Circle()
                        .fill(viewModel.phaseColor)
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: viewModel.status == .running ? "pause.fill" : "play.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                        .offset(x: viewModel.status == .running ? 0 : 2)
                }
            }
            .buttonStyle(.plain)
            .help(viewModel.status == .running ? "Pause" : "Start")
            
            // Skip button
            Button {
                viewModel.skip()
            } label: {
                Image(systemName: "forward.fill")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .help("Skip to Next Phase")
        }
    }
}

