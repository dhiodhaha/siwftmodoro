import SwiftUI

struct StatsView: View {
    @EnvironmentObject var viewModel: PomodoroViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Text("Statistics")
                    .font(.title2.bold())
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
            
            // Summary cards
            HStack(spacing: 16) {
                StatCard(
                    title: "Today",
                    value: "\(viewModel.stats.todaySessions)",
                    subtitle: "sessions"
                )
                
                StatCard(
                    title: "Total",
                    value: "\(viewModel.stats.totalSessions)",
                    subtitle: "sessions"
                )
                
                StatCard(
                    title: "Focus Time",
                    value: formatTime(viewModel.stats.totalFocusMinutes),
                    subtitle: "total"
                )
            }
            
            // Weekly chart
            VStack(alignment: .leading, spacing: 12) {
                Text("Last 7 Days")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                WeeklyChart(data: viewModel.stats.lastSevenDays())
            }
            
            Spacer()
        }
        .padding(24)
        .frame(width: 360, height: 400)
    }
    
    private func formatTime(_ minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes)m"
        } else {
            let hours = minutes / 60
            let mins = minutes % 60
            return mins > 0 ? "\(hours)h \(mins)m" : "\(hours)h"
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.title2.bold())
            
            Text(subtitle)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.fill.tertiary, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct WeeklyChart: View {
    let data: [DailyStats]
    
    private var maxSessions: Int {
        max(data.map(\.sessionsCompleted).max() ?? 1, 1)
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(data) { day in
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(day.sessionsCompleted > 0 ? Color.accentColor : Color.gray.opacity(0.3))
                        .frame(height: CGFloat(day.sessionsCompleted) / CGFloat(maxSessions) * 80 + 4)
                    
                    Text(dayLabel(day.date))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 100)
    }
    
    private func dayLabel(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return "" }
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE"
        return dayFormatter.string(from: date)
    }
}
