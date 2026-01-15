//
//  AppTypography.swift
//  Nature Focus
//
//  Created by Yosh on 14/01/2026.
//

import SwiftUI

struct AppTypography {
    // Hero Display - 48-60pt, Light (300)
    static func heroDisplay(size: CGFloat = 60) -> Font {
        return .system(size: size, weight: .light, design: .default)
    }
    
    // Page Title - 28-32pt, Semibold (600)
    static func pageTitle(size: CGFloat = 32) -> Font {
        return .system(size: size, weight: .semibold, design: .default)
    }
    
    // Section Header - 20-24pt, Semibold (600)
    static func sectionHeader(size: CGFloat = 24) -> Font {
        return .system(size: size, weight: .semibold, design: .default)
    }
    
    // Body Large - 17-18pt, Regular (400)
    static func bodyLarge(size: CGFloat = 18) -> Font {
        return .system(size: size, weight: .regular, design: .default)
    }
    
    // Body - 15-16pt, Regular (400)
    static func body(size: CGFloat = 16) -> Font {
        return .system(size: size, weight: .regular, design: .default)
    }
    
    // Caption - 13-14pt, Regular (400)
    static func caption(size: CGFloat = 14) -> Font {
        return .system(size: size, weight: .regular, design: .default)
    }
    
    // Small/Fine Print - 11-12pt, Regular (400)
    static func small(size: CGFloat = 12) -> Font {
        return .system(size: size, weight: .regular, design: .default)
    }
    
    // Button Text - 16pt, Semibold
    static func button(size: CGFloat = 16) -> Font {
        return .system(size: size, weight: .semibold, design: .default)
    }
}
