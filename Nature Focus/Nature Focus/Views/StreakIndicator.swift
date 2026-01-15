//
//  StreakIndicator.swift
//  Nature Focus
//
//  Created by Claude on 15/01/2026.
//

import SwiftUI

struct StreakIndicator: View {
    let currentStreak: Int
    let longestStreak: Int

    var body: some View {
        HStack(spacing: Theme.spacing.md) {
            // Flame icon
            Image(systemName: currentStreak > 0 ? "flame.fill" : "flame")
                .font(.system(size: 32, weight: .semibold))
                .foregroundColor(currentStreak > 0 ? Theme.colors.goldenYellow : Theme.colors.mediumGray)

            VStack(alignment: .leading, spacing: Theme.spacing.xs) {
                HStack(alignment: .firstTextBaseline, spacing: Theme.spacing.xs) {
                    Text("\(currentStreak)")
                        .font(Theme.typography.pageTitle())
                        .foregroundColor(Theme.colors.charcoal)

                    Text(currentStreak == 1 ? "day streak" : "day streak")
                        .font(Theme.typography.body())
                        .foregroundColor(Theme.colors.charcoal)
                }

                if longestStreak > 0 {
                    Text("Best: \(longestStreak) days")
                        .font(Theme.typography.caption())
                        .foregroundColor(Theme.colors.mediumGray)
                }
            }

            Spacer()
        }
        .padding(Theme.spacing.cardPadding)
        .background(Theme.colors.softCream)
        .cornerRadius(Theme.borderRadiusMedium)
    }
}

#Preview {
    VStack(spacing: Theme.spacing.md) {
        StreakIndicator(currentStreak: 5, longestStreak: 12)
        StreakIndicator(currentStreak: 0, longestStreak: 7)
    }
    .padding()
    .background(Theme.colors.deepTeal)
}
