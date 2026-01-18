//
//  IntroTreeView.swift
//  Nature Focus
//
//  Created by Claude on 18/01/2026.
//

import SwiftUI

struct IntroTreeView: View {
    let treeType: IntroTreeType
    let size: CGFloat
    let platformSize: CGSize
    let gridX: Int
    let gridY: Int

    @State private var scale: CGFloat = 0
    @State private var rotation: Double = 0

    var body: some View {
        let position = IsometricGrid.gridToNormalized(gridX: gridX, gridY: gridY)

        Image(treeType.imageName)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .rotationEffect(.radians(rotation))
            .shadow(
                color: Color.black.opacity(0.3),
                radius: 10,
                x: 0,
                y: 5
            )
            .position(
                x: position.x * platformSize.width,
                y: position.y * platformSize.height
            )
            .onAppear {
                animateBounce()
            }
    }

    private func animateBounce() {
        // Phase 1: Explosive expansion (0-150ms)
        // Scale: 0 → 130%, slight rotation
        withAnimation(.easeOut(duration: 0.15)) {
            scale = 1.3
            rotation = 0.1
        }

        // Phase 2: Settle back (150-400ms)
        // Scale: 130% → 95%, counter-rotation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeInOut(duration: 0.25)) {
                scale = 0.95
                rotation = -0.02
            }
        }

        // Phase 3: Final rest (400-600ms)
        // Scale: 95% → 100%, rotation to 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeOut(duration: 0.2)) {
                scale = 1.0
                rotation = 0
            }
        }
    }
}
