//
//  PlantButton.swift
//  Nature Focus
//
//  Created by Yosh on 14/01/2026.
//

import SwiftUI

struct PlantButton: View {
    let action: () -> Void
    let isActive: Bool
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isActive ? "pause.fill" : "leaf.fill")
                    .font(.system(size: 18, weight: .semibold))
                Text(isActive ? "Pause" : "Plant")
                    .font(Theme.typography.button())
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Theme.spacing.buttonPaddingV)
            .padding(.horizontal, Theme.spacing.buttonPaddingH)
            .background(Theme.colors.forestGreen)
            .cornerRadius(Theme.borderRadiusMedium)
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isActive ? 1.0 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isActive)
    }
}

#Preview {
    VStack(spacing: 20) {
        PlantButton(action: {}, isActive: false)
        PlantButton(action: {}, isActive: true)
    }
    .padding()
}
