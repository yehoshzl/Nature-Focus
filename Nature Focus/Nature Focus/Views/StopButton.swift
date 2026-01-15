//
//  StopButton.swift
//  Nature Focus
//
//  Created by Yosh on 14/01/2026.
//

import SwiftUI

struct StopButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Stop")
                .font(Theme.typography.button())
                .foregroundColor(Theme.colors.coralRed)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Theme.spacing.buttonPaddingV)
                .padding(.horizontal, Theme.spacing.buttonPaddingH)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.borderRadiusMedium)
                        .stroke(Theme.colors.coralRed, lineWidth: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    StopButton(action: {})
        .padding()
}
