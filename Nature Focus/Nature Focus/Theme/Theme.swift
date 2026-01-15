//
//  Theme.swift
//  Nature Focus
//
//  Created by Yosh on 14/01/2026.
//

import SwiftUI

struct Theme {
    static let colors = AppColors.self
    static let typography = AppTypography.self
    static let spacing = AppSpacing.self
    
    // Border Radius
    static let borderRadiusSmall: CGFloat = 8
    static let borderRadiusMedium: CGFloat = 12
    static let borderRadiusLarge: CGFloat = 16
    static let borderRadiusXLarge: CGFloat = 20
    
    // Shadows
    static func cardShadow() -> some View {
        Color.black.opacity(0.08)
            .blur(radius: 16)
            .offset(y: 4)
    }
    
    static func buttonShadow() -> some View {
        Color.black.opacity(0.15)
            .blur(radius: 8)
            .offset(y: 2)
    }
    
    static func floatingCardShadow() -> some View {
        Color.black.opacity(0.12)
            .blur(radius: 24)
            .offset(y: 8)
    }
}
