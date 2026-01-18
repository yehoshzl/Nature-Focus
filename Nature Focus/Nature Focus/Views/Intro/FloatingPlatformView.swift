//
//  FloatingPlatformView.swift
//  Nature Focus
//
//  Created by Claude on 18/01/2026.
//

import SwiftUI

struct FloatingPlatformView: View {
    let platformScale: CGFloat = 0.536
    let treePlacements: [TreePlacement]
    let spawnedTreeIndices: Set<Int>
    @Binding var showDebugOverlay: Bool

    // Original image dimensions
    private let imageWidth: CGFloat = 1536
    private let imageHeight: CGFloat = 1024

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate

            // Floating offsets (8-second cycle)
            let verticalOffset = sin(time * .pi / 4) * 15
            let horizontalOffset = sin(time * .pi / 4 + .pi / 4) * 8

            GeometryReader { geometry in
                let scaledWidth = imageWidth * platformScale
                let scaledHeight = imageHeight * platformScale

                ZStack {
                    // Platform image with shadow
                    Image("background_grid")
                        .resizable()
                        .scaledToFit()
                        .frame(width: scaledWidth, height: scaledHeight)
                        .shadow(
                            color: IntroColors.platformShadow,
                            radius: 30,
                            x: 0,
                            y: 15
                        )

                    // Trees on platform
                    ForEach(Array(treePlacements.enumerated()), id: \.element.id) { index, placement in
                        if spawnedTreeIndices.contains(index) {
                            IntroTreeView(
                                treeType: placement.treeType,
                                size: placement.size,
                                platformSize: CGSize(width: scaledWidth, height: scaledHeight),
                                gridX: placement.gridX,
                                gridY: placement.gridY
                            )
                        }
                    }

                    // Debug overlay
                    if showDebugOverlay {
                        IsometricDebugOverlay(
                            treePlacements: treePlacements,
                            platformSize: CGSize(width: scaledWidth, height: scaledHeight)
                        )
                        .frame(width: scaledWidth, height: scaledHeight)
                    }
                }
                .frame(width: scaledWidth, height: scaledHeight)
                .position(
                    x: geometry.size.width / 2 + horizontalOffset,
                    y: geometry.size.height / 2 + verticalOffset
                )
            }
        }
    }
}
