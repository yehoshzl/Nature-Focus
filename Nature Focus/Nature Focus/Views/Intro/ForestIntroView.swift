//
//  ForestIntroView.swift
//  Nature Focus
//
//  Created by Claude on 18/01/2026.
//

import SwiftUI

struct ForestIntroView: View {
    @ObservedObject var introManager: IntroSequenceManager
    @StateObject private var audioManager = IntroAudioManager()
    @Binding var showDebugOverlay: Bool
    let onComplete: () -> Void

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let verticalOffset = sin(time * .pi / 4) * 15

            ZStack {
                // Dark green gradient background
                LinearGradient(
                    colors: [IntroColors.backgroundTop, IntroColors.backgroundBottom],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                // Floating platform with trees
                FloatingPlatformView(
                    treePlacements: introManager.treePlacements,
                    spawnedTreeIndices: introManager.spawnedTreeIndices,
                    showDebugOverlay: $showDebugOverlay
                )

                // Poetic text overlay
                PoeticTextOverlay(
                    opacity: introManager.textOpacity,
                    verticalOffset: verticalOffset
                )

                // Debug info overlay
                if showDebugOverlay {
                    VStack {
                        Spacer()
                        debugInfoView
                    }
                    .padding()
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(count: 3) {
            showDebugOverlay.toggle()
        }
        .onChange(of: introManager.isComplete) { _, isComplete in
            if isComplete {
                onComplete()
            }
        }
    }

    private var debugInfoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("DEBUG MODE (triple-tap to toggle)")
                .font(.caption)
                .fontWeight(.bold)
            Text("Trees: \(introManager.spawnedTreeIndices.count)/\(introManager.treePlacements.count)")
                .font(.caption)
            Text("Grid: 40x40 isometric")
                .font(.caption)
            Text("Phase: \(String(describing: introManager.phase))")
                .font(.caption)
            Text("Time: \(String(format: "%.1f", introManager.elapsedTime))s")
                .font(.caption)
        }
        .padding(8)
        .background(Color.black.opacity(0.7))
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}
