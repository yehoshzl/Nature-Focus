//
//  ForestGridView.swift
//  Nature Focus
//
//  Created by Yosh on 14/01/2026.
//

import SwiftUI
import CoreData

struct TreePosition: Identifiable {
    let id: Int
    let x: CGFloat
    let y: CGFloat
    let depthScale: CGFloat
}

struct ForestGridView: View {
    @StateObject private var sessionManager = SessionManager()
    @State private var todaySessions: [FocusSession] = []
    @State private var showTrees = false

    // Predefined tree positions in the meadow area (relative coordinates 0-1)
    // Positions are arranged to look natural, with depth-based scaling
    private let treePositions: [TreePosition] = {
        var positions: [TreePosition] = []

        // Row 1 - Back (smaller trees for depth) y: 0.45-0.52
        let backRow = [
            (0.25, 0.47), (0.35, 0.49), (0.50, 0.46), (0.65, 0.48), (0.75, 0.47),
            (0.30, 0.51), (0.45, 0.50), (0.58, 0.52), (0.70, 0.51)
        ]
        for (i, pos) in backRow.enumerated() {
            positions.append(TreePosition(id: i, x: pos.0, y: pos.1, depthScale: 0.4))
        }

        // Row 2 - Mid-back y: 0.53-0.62
        let midBackRow = [
            (0.20, 0.55), (0.32, 0.58), (0.42, 0.56), (0.55, 0.59), (0.68, 0.57),
            (0.80, 0.56), (0.27, 0.61), (0.48, 0.62), (0.62, 0.60), (0.73, 0.61)
        ]
        for (i, pos) in midBackRow.enumerated() {
            positions.append(TreePosition(id: backRow.count + i, x: pos.0, y: pos.1, depthScale: 0.55))
        }

        // Row 3 - Middle y: 0.63-0.72
        let middleRow = [
            (0.18, 0.65), (0.30, 0.68), (0.40, 0.66), (0.52, 0.69), (0.63, 0.67),
            (0.75, 0.65), (0.82, 0.68), (0.35, 0.71), (0.55, 0.72), (0.70, 0.70)
        ]
        for (i, pos) in middleRow.enumerated() {
            positions.append(TreePosition(id: backRow.count + midBackRow.count + i, x: pos.0, y: pos.1, depthScale: 0.7))
        }

        // Row 4 - Front y: 0.73-0.85
        let frontRow = [
            (0.22, 0.75), (0.35, 0.78), (0.45, 0.76), (0.58, 0.79), (0.70, 0.77),
            (0.80, 0.75), (0.28, 0.82), (0.42, 0.84), (0.55, 0.83), (0.68, 0.85),
            (0.78, 0.82)
        ]
        for (i, pos) in frontRow.enumerated() {
            positions.append(TreePosition(id: backRow.count + midBackRow.count + middleRow.count + i, x: pos.0, y: pos.1, depthScale: 0.85))
        }

        return positions
    }()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Full-screen forest background
                Image("forest_background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .ignoresSafeArea()

                // Trees overlay
                ForEach(treesToDisplay) { treeData in
                    Image("tree")
                        .resizable()
                        .scaledToFit()
                        .frame(width: treeSize(for: treeData).width, height: treeSize(for: treeData).height)
                        .position(
                            x: treeData.position.x * geometry.size.width,
                            y: treeData.position.y * geometry.size.height
                        )
                        .opacity(showTrees ? 1 : 0)
                        .scaleEffect(showTrees ? 1 : 0.8)
                        .animation(
                            .easeOut(duration: 0.6).delay(Double(treeData.index) * 0.05),
                            value: showTrees
                        )
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            loadTodaySessions()
            withAnimation {
                showTrees = true
            }
        }
    }

    // MARK: - Tree Data

    private struct TreeDisplayData: Identifiable {
        let id: Int
        let index: Int
        let position: TreePosition
        let sessionDuration: Int32
    }

    private var treesToDisplay: [TreeDisplayData] {
        var trees: [TreeDisplayData] = []

        // 1 tree per completed session (not per 15 minutes)
        let treesToShow = min(treePositions.count, todaySessions.count)

        // Sort positions by Y (back to front) for natural filling
        let sortedPositions = treePositions.sorted { $0.y < $1.y }

        for (index, session) in todaySessions.prefix(treesToShow).enumerated() {
            if index < sortedPositions.count {
                trees.append(TreeDisplayData(
                    id: index,
                    index: index,
                    position: sortedPositions[index],
                    sessionDuration: session.duration
                ))
            }
        }

        return trees
    }

    // MARK: - Tree Sizing

    private func treeSize(for treeData: TreeDisplayData) -> CGSize {
        let baseSize: CGFloat = 80
        let durationMinutes = Int(treeData.sessionDuration) / 60

        // Duration-based scale
        let durationScale: CGFloat
        switch durationMinutes {
        case 0..<11:
            durationScale = 0.5  // Small sapling
        case 11..<26:
            durationScale = 0.7  // Medium tree
        case 26..<46:
            durationScale = 0.9  // Large tree
        default:
            durationScale = 1.0  // Full mature tree
        }

        // Combine with depth scale
        let finalScale = durationScale * treeData.position.depthScale
        let size = baseSize * finalScale

        return CGSize(width: size, height: size)
    }

    // MARK: - Data Loading

    private func loadTodaySessions() {
        todaySessions = sessionManager.getSessionsToday()
    }
}

#Preview {
    ForestGridView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
