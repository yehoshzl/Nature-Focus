//
//  StatsSummaryCard.swift
//  Nature Focus
//
//  Created by Claude on 15/01/2026.
//

import SwiftUI

struct StatsSummaryCard: View {
    let title: String
    let value: String
    let subtitle: String?
    let icon: String
    let iconColor: Color

    init(title: String, value: String, subtitle: String? = nil, icon: String, iconColor: Color) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
    }

    var body: some View {
        VStack(spacing: Theme.spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(iconColor)

            Text(value)
                .font(Theme.typography.pageTitle())
                .foregroundColor(Theme.colors.charcoal)

            Text(title)
                .font(Theme.typography.caption())
                .foregroundColor(Theme.colors.mediumGray)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(Theme.typography.small())
                    .foregroundColor(Theme.colors.mediumGray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(Theme.spacing.cardPadding)
        .background(Theme.colors.softCream)
        .cornerRadius(Theme.borderRadiusMedium)
    }
}

#Preview {
    HStack(spacing: Theme.spacing.md) {
        StatsSummaryCard(
            title: "Sessions",
            value: "12",
            icon: "tree.fill",
            iconColor: Theme.colors.forestGreen
        )

        StatsSummaryCard(
            title: "Minutes",
            value: "180",
            subtitle: "3 hours",
            icon: "clock.fill",
            iconColor: Theme.colors.deepTeal
        )
    }
    .padding()
    .background(Theme.colors.deepTeal)
}
