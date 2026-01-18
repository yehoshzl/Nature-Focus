//
//  PoeticTextOverlay.swift
//  Nature Focus
//
//  Created by Claude on 18/01/2026.
//

import SwiftUI

struct PoeticTextOverlay: View {
    let opacity: Double
    let verticalOffset: CGFloat

    private let poeticText = """
    You arrive at a quiet clearing,
    suspended between sky and silence.
    """

    var body: some View {
        VStack {
            Text(poeticText)
                .font(.custom("PlayfairDisplay-LightItalic", size: 32))
                .fontWeight(.light)
                .italic()
                .foregroundColor(IntroColors.poeticText)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .tracking(1)
                .shadow(color: IntroColors.textShadow, radius: 20, x: 0, y: 2)
                .frame(maxWidth: 600)
                .opacity(opacity)
                .offset(y: -80 + verticalOffset)

            Spacer()
        }
        .padding(.top, 100)
    }
}

// Fallback for systems without Playfair Display
extension Font {
    static func poeticFont(size: CGFloat) -> Font {
        // Try custom font first, fall back to system serif
        // Note: Custom fonts need to be added to the app bundle
        return .system(size: size, weight: .light, design: .serif).italic()
    }
}
