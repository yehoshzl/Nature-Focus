//
//  CircularProgressWidget.swift
//  Nature Focus
//
//  Created by Yosh on 14/01/2026.
//

import SwiftUI

struct CircularProgressWidget<Content: View>: View {
    let duration: TimeInterval // Current timer duration setting (in seconds)
    let progress: Double // Progress through current session (0.0 to 1.0)
    let isRunning: Bool // Whether timer is actively running
    let content: Content

    @State private var animatedProgress: Double = 0

    init(duration: TimeInterval, progress: Double, isRunning: Bool, @ViewBuilder content: () -> Content) {
        self.duration = duration
        self.progress = progress
        self.isRunning = isRunning
        self.content = content()
    }

    var body: some View {
        ZStack {
            // Content (Tree image)
            content

            // Background ring (unfilled portion)
            Circle()
                .stroke(
                    Theme.colors.lightSage.opacity(0.3),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 200, height: 200)

            // Progress ring
            Circle()
                .trim(from: 0, to: displayProgress)
                .stroke(
                    Theme.colors.grassGreen,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(-90)) // Start from top
                .animation(.linear(duration: 0.3), value: displayProgress)
        }
        .onChange(of: progress) { newValue in
            if isRunning {
                animatedProgress = newValue
            }
        }
        .onChange(of: isRunning) { newValue in
            if newValue {
                // Session started - reset to track progress
                animatedProgress = progress
            }
        }
        .onAppear {
            animatedProgress = progress
        }
    }

    // Before session: show duration as fraction of 60 min
    // During session: show session progress (0→1)
    private var displayProgress: Double {
        if isRunning || progress > 0 {
            // During/after session: show actual progress
            return animatedProgress
        } else {
            // Before session (idle): show duration as fraction of 60 minutes
            let minutes = duration / 60.0
            return min(minutes / 60.0, 1.0)
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        // Idle state - shows 15 min as quarter circle
        CircularProgressWidget(duration: 15 * 60, progress: 0, isRunning: false) {
            Image("tree")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
        }

        // Running state - shows progress
        CircularProgressWidget(duration: 15 * 60, progress: 0.5, isRunning: true) {
            Image("tree")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
        }
    }
    .padding()
}
