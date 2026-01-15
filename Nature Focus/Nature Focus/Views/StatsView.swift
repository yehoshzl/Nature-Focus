//
//  StatsView.swift
//  Nature Focus
//
//  Created by Claude on 15/01/2026.
//

import SwiftUI

struct StatsView: View {
    @StateObject private var statsManager = StatsManager()
    @State private var selectedTimeframe: StatsTimeframe = .week

    enum StatsTimeframe: String, CaseIterable {
        case today = "Today"
        case week = "Week"
        case month = "Month"
        case allTime = "All Time"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.spacing.lg) {
                // Timeframe Picker
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(StatsTimeframe.allCases, id: \.self) { timeframe in
                        Text(timeframe.rawValue).tag(timeframe)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, Theme.spacing.screenMargin)

                // Streak Card
                StreakIndicator(
                    currentStreak: statsManager.overallStats.currentStreak,
                    longestStreak: statsManager.overallStats.longestStreak
                )
                .padding(.horizontal, Theme.spacing.screenMargin)

                // Stats Summary Cards
                HStack(spacing: Theme.spacing.md) {
                    StatsSummaryCard(
                        title: "Sessions",
                        value: "\(currentSessionCount)",
                        icon: "tree.fill",
                        iconColor: Theme.colors.forestGreen
                    )

                    StatsSummaryCard(
                        title: "Minutes",
                        value: "\(currentMinutes)",
                        subtitle: formatHours(currentMinutes),
                        icon: "clock.fill",
                        iconColor: Theme.colors.deepTeal
                    )
                }
                .padding(.horizontal, Theme.spacing.screenMargin)

                // Chart (not shown for "Today" view)
                if selectedTimeframe != .today {
                    StatsChartView(data: chartData)
                        .padding(.horizontal, Theme.spacing.screenMargin)
                }

                // All Time stats
                if selectedTimeframe == .allTime {
                    allTimeStatsSection
                        .padding(.horizontal, Theme.spacing.screenMargin)
                }

                Spacer(minLength: Theme.spacing.xl)
            }
            .padding(.top, Theme.spacing.md)
        }
        .background(Theme.colors.deepTeal.ignoresSafeArea())
        .navigationTitle("Statistics")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
        .onAppear {
            statsManager.refreshStats()
        }
    }

    // MARK: - Computed Properties

    private var currentSessionCount: Int {
        switch selectedTimeframe {
        case .today:
            return statsManager.todayStats.sessionsCompleted
        case .week:
            return statsManager.thisWeekStats.totalSessions
        case .month:
            return statsManager.thisMonthStats.totalSessions
        case .allTime:
            return statsManager.overallStats.totalSessions
        }
    }

    private var currentMinutes: Int {
        switch selectedTimeframe {
        case .today:
            return statsManager.todayStats.totalMinutes
        case .week:
            return statsManager.thisWeekStats.totalMinutes
        case .month:
            return statsManager.thisMonthStats.totalMinutes
        case .allTime:
            return statsManager.overallStats.totalMinutes
        }
    }

    private var chartData: [DailyStats] {
        switch selectedTimeframe {
        case .today:
            return []
        case .week:
            return statsManager.thisWeekStats.dailyBreakdown
        case .month:
            // For month view, show last 7 days for simplicity
            return Array(statsManager.thisMonthStats.dailyBreakdown.suffix(7))
        case .allTime:
            // Show this week's breakdown for all time
            return statsManager.thisWeekStats.dailyBreakdown
        }
    }

    private var allTimeStatsSection: some View {
        VStack(spacing: Theme.spacing.md) {
            HStack(spacing: Theme.spacing.md) {
                StatsSummaryCard(
                    title: "Avg Session",
                    value: String(format: "%.0f", statsManager.overallStats.averageSessionMinutes),
                    subtitle: "minutes",
                    icon: "timer",
                    iconColor: Theme.colors.lightSage
                )

                if let firstDate = statsManager.overallStats.firstSessionDate {
                    StatsSummaryCard(
                        title: "Member Since",
                        value: formatMemberSince(firstDate),
                        icon: "calendar",
                        iconColor: Theme.colors.forestGreen
                    )
                }
            }
        }
    }

    // MARK: - Helper Methods

    private func formatHours(_ minutes: Int) -> String? {
        guard minutes >= 60 else { return nil }
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        if remainingMinutes == 0 {
            return "\(hours)h"
        }
        return "\(hours)h \(remainingMinutes)m"
    }

    private func formatMemberSince(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        StatsView()
    }
}
