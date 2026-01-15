//
//  TimerView.swift
//  Nature Focus
//
//  Created by Yosh on 14/01/2026.
//

import SwiftUI

struct TimerView: View {
    let timeRemaining: TimeInterval
    let isActive: Bool
    
    var body: some View {
        Text(formattedTime())
            .font(Theme.typography.heroDisplay(size: 60))
            .foregroundColor(isActive ? Theme.colors.forestGreen : Theme.colors.mediumGray)
            .monospacedDigit()
    }
    
    private func formattedTime() -> String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    TimerView(timeRemaining: 900, isActive: true)
}
