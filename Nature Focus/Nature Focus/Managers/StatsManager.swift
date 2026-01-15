//
//  StatsManager.swift
//  Nature Focus
//
//  Created by Claude on 15/01/2026.
//

import Foundation
import Combine

struct DailyStats: Identifiable {
    let id = UUID()
    let date: Date
    let sessionsCompleted: Int
    let totalMinutes: Int
    let coinsEarned: Int
}

struct WeeklyStats {
    let weekStartDate: Date
    let dailyBreakdown: [DailyStats]
    let totalSessions: Int
    let totalMinutes: Int
    let totalCoins: Int
}

struct MonthlyStats {
    let monthDate: Date
    let dailyBreakdown: [DailyStats]
    let totalSessions: Int
    let totalMinutes: Int
    let totalCoins: Int
}

struct OverallStats {
    let totalSessions: Int
    let totalMinutes: Int
    let totalCoins: Int
    let currentStreak: Int
    let longestStreak: Int
    let averageSessionMinutes: Double
    let firstSessionDate: Date?
}

class StatsManager: ObservableObject {
    private let sessionManager: SessionManager

    @Published var todayStats: DailyStats
    @Published var thisWeekStats: WeeklyStats
    @Published var thisMonthStats: MonthlyStats
    @Published var overallStats: OverallStats

    init(sessionManager: SessionManager = SessionManager()) {
        self.sessionManager = sessionManager

        // Initialize with empty stats
        let today = Date()
        self.todayStats = DailyStats(date: today, sessionsCompleted: 0, totalMinutes: 0, coinsEarned: 0)
        self.thisWeekStats = WeeklyStats(weekStartDate: today, dailyBreakdown: [], totalSessions: 0, totalMinutes: 0, totalCoins: 0)
        self.thisMonthStats = MonthlyStats(monthDate: today, dailyBreakdown: [], totalSessions: 0, totalMinutes: 0, totalCoins: 0)
        self.overallStats = OverallStats(totalSessions: 0, totalMinutes: 0, totalCoins: 0, currentStreak: 0, longestStreak: 0, averageSessionMinutes: 0, firstSessionDate: nil)

        refreshStats()
    }

    func refreshStats() {
        todayStats = calculateTodayStats()
        thisWeekStats = calculateThisWeekStats()
        thisMonthStats = calculateThisMonthStats()
        overallStats = calculateOverallStats()
    }

    private func calculateTodayStats() -> DailyStats {
        let sessions = sessionManager.getSessionsToday()
        let totalMinutes = sessions.reduce(0) { $0 + Int($1.duration) } / 60
        let totalCoins = sessions.reduce(0) { $0 + Int($1.coinsEarned) }

        return DailyStats(
            date: Date(),
            sessionsCompleted: sessions.count,
            totalMinutes: totalMinutes,
            coinsEarned: totalCoins
        )
    }

    private func calculateThisWeekStats() -> WeeklyStats {
        let calendar = Calendar.current
        let today = Date()
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) else {
            return WeeklyStats(weekStartDate: today, dailyBreakdown: [], totalSessions: 0, totalMinutes: 0, totalCoins: 0)
        }

        let sessions = sessionManager.getSessionsForWeek(containing: today)
        let dailyBreakdown = getDailyBreakdown(for: sessions, in: weekInterval)

        let totalSessions = sessions.count
        let totalMinutes = sessions.reduce(0) { $0 + Int($1.duration) } / 60
        let totalCoins = sessions.reduce(0) { $0 + Int($1.coinsEarned) }

        return WeeklyStats(
            weekStartDate: weekInterval.start,
            dailyBreakdown: dailyBreakdown,
            totalSessions: totalSessions,
            totalMinutes: totalMinutes,
            totalCoins: totalCoins
        )
    }

    private func calculateThisMonthStats() -> MonthlyStats {
        let calendar = Calendar.current
        let today = Date()
        guard let monthInterval = calendar.dateInterval(of: .month, for: today) else {
            return MonthlyStats(monthDate: today, dailyBreakdown: [], totalSessions: 0, totalMinutes: 0, totalCoins: 0)
        }

        let sessions = sessionManager.getSessionsForMonth(containing: today)
        let dailyBreakdown = getDailyBreakdown(for: sessions, in: monthInterval)

        let totalSessions = sessions.count
        let totalMinutes = sessions.reduce(0) { $0 + Int($1.duration) } / 60
        let totalCoins = sessions.reduce(0) { $0 + Int($1.coinsEarned) }

        return MonthlyStats(
            monthDate: monthInterval.start,
            dailyBreakdown: dailyBreakdown,
            totalSessions: totalSessions,
            totalMinutes: totalMinutes,
            totalCoins: totalCoins
        )
    }

    private func getDailyBreakdown(for sessions: [FocusSession], in interval: DateInterval) -> [DailyStats] {
        let calendar = Calendar.current
        var dailyStats: [Date: (sessions: Int, minutes: Int, coins: Int)] = [:]

        // Initialize all days in the interval
        var currentDate = interval.start
        while currentDate < interval.end {
            let dayStart = calendar.startOfDay(for: currentDate)
            dailyStats[dayStart] = (sessions: 0, minutes: 0, coins: 0)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? interval.end
        }

        // Populate with session data
        for session in sessions {
            guard let startTime = session.startTime else { continue }
            let dayStart = calendar.startOfDay(for: startTime)

            if var existing = dailyStats[dayStart] {
                existing.sessions += 1
                existing.minutes += Int(session.duration) / 60
                existing.coins += Int(session.coinsEarned)
                dailyStats[dayStart] = existing
            }
        }

        // Convert to array and sort
        return dailyStats.map { date, stats in
            DailyStats(date: date, sessionsCompleted: stats.sessions, totalMinutes: stats.minutes, coinsEarned: stats.coins)
        }.sorted { $0.date < $1.date }
    }

    private func calculateOverallStats() -> OverallStats {
        let sessions = sessionManager.getCompletedSessions()
        let totalSessions = sessions.count
        let totalMinutes = sessions.reduce(0) { $0 + Int($1.duration) } / 60
        let totalCoins = sessions.reduce(0) { $0 + Int($1.coinsEarned) }
        let averageMinutes = totalSessions > 0 ? Double(totalMinutes) / Double(totalSessions) : 0
        let firstDate = sessionManager.getFirstSessionDate()
        let streaks = calculateStreaks()

        return OverallStats(
            totalSessions: totalSessions,
            totalMinutes: totalMinutes,
            totalCoins: totalCoins,
            currentStreak: streaks.current,
            longestStreak: streaks.longest,
            averageSessionMinutes: averageMinutes,
            firstSessionDate: firstDate
        )
    }

    private func calculateStreaks() -> (current: Int, longest: Int) {
        let datesWithSessions = sessionManager.getDatesWithSessions()
        guard !datesWithSessions.isEmpty else { return (0, 0) }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let sortedDates = datesWithSessions.sorted(by: >)

        var currentStreak = 0
        var longestStreak = 0
        var tempStreak = 0
        var previousDate: Date?

        // Check if today or yesterday has a session (for current streak)
        let mostRecentSessionDate = sortedDates.first!
        let daysSinceLastSession = calendar.dateComponents([.day], from: mostRecentSessionDate, to: today).day ?? 0

        if daysSinceLastSession > 1 {
            // Streak is broken - no session today or yesterday
            currentStreak = 0
        }

        // Calculate streaks by iterating through dates
        for date in sortedDates {
            if let previous = previousDate {
                let daysBetween = calendar.dateComponents([.day], from: date, to: previous).day ?? 0

                if daysBetween == 1 {
                    // Consecutive day
                    tempStreak += 1
                } else {
                    // Streak broken
                    longestStreak = max(longestStreak, tempStreak)
                    tempStreak = 1
                }
            } else {
                // First date
                tempStreak = 1
            }
            previousDate = date
        }

        // Don't forget the last streak
        longestStreak = max(longestStreak, tempStreak)

        // Calculate current streak (counting backwards from today/yesterday)
        if daysSinceLastSession <= 1 {
            tempStreak = 1
            previousDate = mostRecentSessionDate

            for date in sortedDates.dropFirst() {
                guard let previous = previousDate else { break }
                let daysBetween = calendar.dateComponents([.day], from: date, to: previous).day ?? 0

                if daysBetween == 1 {
                    tempStreak += 1
                    previousDate = date
                } else {
                    break
                }
            }
            currentStreak = tempStreak
        }

        return (currentStreak, longestStreak)
    }

    // Get stats for a custom date range
    func getStatsForDateRange(from startDate: Date, to endDate: Date) -> [DailyStats] {
        let sessions = sessionManager.getSessions(from: startDate, to: endDate)
        let interval = DateInterval(start: startDate, end: endDate)
        return getDailyBreakdown(for: sessions, in: interval)
    }
}
