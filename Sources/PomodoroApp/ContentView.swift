import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: PomodoroViewModel
    @State private var showingStats = false
    
    var body: some View {
        ZStack {
            // Background gradient
            backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Header
                headerView
                
                Spacer()
                
                // Timer
                TimerView()
                
                // Session indicator
                SessionIndicator()
                
                Spacer()
                
                // Controls
                ControlsView()
                
                Spacer()
            }
            .padding(24)
        }
        .frame(width: 320, height: 480)
        .sheet(isPresented: $showingStats) {
            StatsView()
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(.windowBackgroundColor),
                Color(.windowBackgroundColor).opacity(0.95)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var headerView: some View {
        HStack {
            Text(viewModel.phase.title)
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Button {
                showingStats = true
            } label: {
                Image(systemName: "chart.bar.fill")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 42)
    }
}
