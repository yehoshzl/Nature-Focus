//
//  ResumeButton.swift
//  Nature Focus
//
//  Created by Yosh on 14/01/2026.
//

import SwiftUI

struct ResumeButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "play.fill")
                    .font(.system(size: 18, weight: .semibold))
                Text("Resume")
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
    }
}

#Preview {
    ResumeButton(action: {})
        .padding()
}
