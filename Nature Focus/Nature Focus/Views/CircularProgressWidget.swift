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
    let content: Content
    
    @State private var animatedProgress: Double = 0
    
    init(duration: TimeInterval, progress: Double, @ViewBuilder content: () -> Content) {
        self.duration = duration
        self.progress = progress
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Content (TreeView)
            content
            
            // Circular progress ring
            Circle()
                .stroke(
                    Theme.colors.lightSage.opacity(0.3),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 200, height: 200)
            
            // Active duration arc (shows how much of 60 minutes is set)
            Circle()
                .trim(from: 0, to: durationArc)
                .stroke(
                    Theme.colors.forestGreen.opacity(0.5),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(-90)) // Start from top
            
            // Progress fill (fills the active portion as timer runs)
            if progress > 0 {
                Circle()
                    .trim(from: 0, to: progressArc)
                    .stroke(
                        Theme.colors.grassGreen,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90)) // Start from top
                    .animation(.linear(duration: 1.0), value: animatedProgress)
            }
        }
        .onChange(of: progress) { newValue in
            animatedProgress = newValue
        }
        .onAppear {
            animatedProgress = progress
        }
    }
    
    // Calculate the arc for the duration setting (out of 60 minutes)
    private var durationArc: CGFloat {
        let minutes = duration / 60.0
        return min(CGFloat(minutes / 60.0), 1.0) // Max 1.0 (full circle)
    }
    
    // Calculate the progress arc (fills the active duration portion)
    private var progressArc: CGFloat {
        return durationArc * CGFloat(progress)
    }
}

#Preview {
    CircularProgressWidget(duration: 15 * 60, progress: 0.5) {
        TreeView(progress: 0.5, isActive: true)
    }
    .padding()
}
