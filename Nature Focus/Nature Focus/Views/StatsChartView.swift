//
//  StatsChartView.swift
//  Nature Focus
//
//  Created by Claude on 15/01/2026.
//

import SwiftUI

struct StatsChartView: View {
    let data: [DailyStats]
    let showDayLabels: Bool

    init(data: [DailyStats], showDayLabels: Bool = true) {
        self.data = data
        self.showDayLabels = showDayLabels
    }

    private var maxMinutes: Int {
        max(data.map { $0.totalMinutes }.max() ?? 1, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing.sm) {
            Text("Focus Time")
                .font(Theme.typography.bodyLarge())
                .foregroundColor(Theme.colors.charcoal)

            if data.isEmpty || data.allSatisfy({ $0.totalMinutes == 0 }) {
                emptyStateView
            } else {
                chartView
            }
        }
        .padding(Theme.spacing.cardPadding)
        .background(Theme.colors.softCream)
        .cornerRadius(Theme.borderRadiusMedium)
    }

    private var emptyStateView: some View {
        VStack(spacing: Theme.spacing.sm) {
            Image(systemName: "chart.bar")
                .font(.system(size: 32))
                .foregroundColor(Theme.colors.mediumGray)

            Text("No focus time recorded")
                .font(Theme.typography.body())
                .foregroundColor(Theme.colors.mediumGray)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
    }

    private var chartView: some View {
        HStack(alignment: .bottom, spacing: Theme.spacing.xs) {
            ForEach(data) { day in
                VStack(spacing: Theme.spacing.xs) {
                    // Minutes label on top of bar
                    if day.totalMinutes > 0 {
                        Text("\(day.totalMinutes)")
                            .font(Theme.typography.small())
                            .foregroundColor(Theme.colors.charcoal)
                    }

                    // Bar
                    RoundedRectangle(cornerRadius: 4)
                        .fill(day.totalMinutes > 0 ? Theme.colors.forestGreen : Theme.colors.lightSage.opacity(0.3))
                        .frame(height: barHeight(for: day.totalMinutes))

                    // Day label
                    if showDayLabels {
                        Text(dayLabel(for: day.date))
                            .font(Theme.typography.small())
                            .foregroundColor(isToday(day.date) ? Theme.colors.forestGreen : Theme.colors.mediumGray)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 180)
    }

    private func barHeight(for minutes: Int) -> CGFloat {
        let minHeight: CGFloat = 4
        let maxHeight: CGFloat = 120

        if minutes == 0 {
            return minHeight
        }

        let ratio = CGFloat(minutes) / CGFloat(maxMinutes)
        return max(ratio * maxHeight, minHeight)
    }

    private func dayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }

    private func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
}

#Preview {
    let calendar = Calendar.current
    let today = Date()

    let sampleData = (0..<7).map { dayOffset -> DailyStats in
        let date = calendar.date(byAdding: .day, value: -6 + dayOffset, to: today)!
        let minutes = [0, 15, 45, 30, 0, 60, 25][dayOffset]
        return DailyStats(date: date, sessionsCompleted: minutes > 0 ? 1 : 0, totalMinutes: minutes, coinsEarned: minutes)
    }

    return VStack {
        StatsChartView(data: sampleData)
        StatsChartView(data: [])
    }
    .padding()
    .background(Theme.colors.deepTeal)
}
