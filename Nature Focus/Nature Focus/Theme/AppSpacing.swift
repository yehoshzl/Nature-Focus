//
//  AppSpacing.swift
//  Nature Focus
//
//  Created by Yosh on 14/01/2026.
//

import SwiftUI

struct AppSpacing {
    // 8pt Grid System
    static let xs: CGFloat = 4      // Minimum spacing, tight groupings
    static let sm: CGFloat = 8      // Default spacing between related elements
    static let md: CGFloat = 16     // Spacing between sections within a card
    static let lg: CGFloat = 24     // Spacing between unrelated groups
    static let xl: CGFloat = 32     // Spacing between major sections
    static let xxl: CGFloat = 48    // Large breathing room, screen margins
    
    // Component-specific spacing
    static let cardPadding: CGFloat = 20      // Card internal padding
    static let buttonPaddingV: CGFloat = 14  // Button vertical padding
    static let buttonPaddingH: CGFloat = 32  // Button horizontal padding
    static let screenMargin: CGFloat = 20     // Screen edge margins
}
