//
//  IsometricGridHelper.swift
//  Nature Focus
//
//  Created by Claude on 18/01/2026.
//

import SwiftUI

struct IsometricGrid {
    // Diamond vertices in normalized coordinates (0-1)
    // Based on 1536x1024 background_grid.png measurements
    static let leftCorner = CGPoint(x: 0.144, y: 0.379)    // (221/1536, 388/1024)
    static let topCorner = CGPoint(x: 0.502, y: 0.141)     // (771/1536, 144/1024)
    static let rightCorner = CGPoint(x: 0.866, y: 0.386)   // (1330/1536, 395/1024)
    static let bottomCorner = CGPoint(x: 0.504, y: 0.625)  // (775/1536, 640/1024)

    static let gridSize = 40

    /// Convert grid coordinates (0-39, 0-39) to normalized position (0-1, 0-1)
    /// Uses bilinear interpolation across the diamond shape
    static func gridToNormalized(gridX: Int, gridY: Int) -> CGPoint {
        let u = CGFloat(gridX) / CGFloat(gridSize - 1)
        let v = CGFloat(gridY) / CGFloat(gridSize - 1)

        // Bilinear interpolation across the diamond quadrilateral
        let x = leftCorner.x * (1 - u) * (1 - v) +
                topCorner.x * u * (1 - v) +
                bottomCorner.x * (1 - u) * v +
                rightCorner.x * u * v

        let y = leftCorner.y * (1 - u) * (1 - v) +
                topCorner.y * u * (1 - v) +
                bottomCorner.y * (1 - u) * v +
                rightCorner.y * u * v

        return CGPoint(x: x, y: y)
    }

    /// Convert grid coordinates to screen position within a given size
    static func gridToScreen(gridX: Int, gridY: Int, in size: CGSize) -> CGPoint {
        let normalized = gridToNormalized(gridX: gridX, gridY: gridY)
        return CGPoint(
            x: normalized.x * size.width,
            y: normalized.y * size.height
        )
    }
}

// MARK: - Tree Placement

enum IntroTreeType: CaseIterable {
    case tree1_1
    // TODO: Add more tree types when assets are available
    // case tree1
    // case tree3

    var imageName: String {
        switch self {
        case .tree1_1: return "tree1_1"
        }
    }
}

struct TreePlacement: Identifiable {
    let id = UUID()
    let gridX: Int
    let gridY: Int
    let treeType: IntroTreeType
    let size: CGFloat
    let spawnDelay: Double

    static func generateRandom(count: Int) -> [TreePlacement] {
        var placements: [TreePlacement] = []
        var usedPositions: Set<String> = []

        let treeCount = max(3, min(count, 10))

        for i in 0..<treeCount {
            var gridX: Int
            var gridY: Int

            // Find unique position (avoid edges)
            repeat {
                gridX = Int.random(in: 5...34)
                gridY = Int.random(in: 5...34)
            } while usedPositions.contains("\(gridX),\(gridY)")

            usedPositions.insert("\(gridX),\(gridY)")

            placements.append(TreePlacement(
                gridX: gridX,
                gridY: gridY,
                treeType: IntroTreeType.allCases.randomElement()!,
                size: CGFloat.random(in: 60...100),
                spawnDelay: Double(i) * 0.05
            ))
        }

        // Sort by Y for depth ordering (back to front)
        return placements.sorted { $0.gridY < $1.gridY }
    }
}

// MARK: - Debug Overlay View

struct IsometricDebugOverlay: View {
    let treePlacements: [TreePlacement]
    let platformSize: CGSize

    var body: some View {
        Canvas { context, size in
            // Scale factor to match platform
            let scaleX = size.width / platformSize.width
            let scaleY = size.height / platformSize.height

            // Draw diamond outline
            var diamondPath = Path()
            let corners = [
                IsometricGrid.leftCorner,
                IsometricGrid.topCorner,
                IsometricGrid.rightCorner,
                IsometricGrid.bottomCorner
            ].map { CGPoint(x: $0.x * platformSize.width * scaleX, y: $0.y * platformSize.height * scaleY) }

            diamondPath.move(to: corners[0])
            for corner in corners.dropFirst() {
                diamondPath.addLine(to: corner)
            }
            diamondPath.closeSubpath()

            context.stroke(diamondPath, with: .color(IntroColors.debugDiamondOutline), lineWidth: 2)

            // Draw grid lines
            for i in stride(from: 0, to: IsometricGrid.gridSize, by: 4) {
                // Horizontal lines
                var hPath = Path()
                let hStart = IsometricGrid.gridToNormalized(gridX: 0, gridY: i)
                let hEnd = IsometricGrid.gridToNormalized(gridX: IsometricGrid.gridSize - 1, gridY: i)
                hPath.move(to: CGPoint(x: hStart.x * platformSize.width * scaleX, y: hStart.y * platformSize.height * scaleY))
                hPath.addLine(to: CGPoint(x: hEnd.x * platformSize.width * scaleX, y: hEnd.y * platformSize.height * scaleY))
                context.stroke(hPath, with: .color(IntroColors.debugGridLine), lineWidth: 0.5)

                // Vertical lines
                var vPath = Path()
                let vStart = IsometricGrid.gridToNormalized(gridX: i, gridY: 0)
                let vEnd = IsometricGrid.gridToNormalized(gridX: i, gridY: IsometricGrid.gridSize - 1)
                vPath.move(to: CGPoint(x: vStart.x * platformSize.width * scaleX, y: vStart.y * platformSize.height * scaleY))
                vPath.addLine(to: CGPoint(x: vEnd.x * platformSize.width * scaleX, y: vEnd.y * platformSize.height * scaleY))
                context.stroke(vPath, with: .color(IntroColors.debugGridLine), lineWidth: 0.5)
            }

            // Draw tree positions
            for (index, placement) in treePlacements.enumerated() {
                let pos = IsometricGrid.gridToNormalized(gridX: placement.gridX, gridY: placement.gridY)
                let screenPos = CGPoint(
                    x: pos.x * platformSize.width * scaleX,
                    y: pos.y * platformSize.height * scaleY
                )

                // Tree marker circle
                let markerRect = CGRect(x: screenPos.x - 5, y: screenPos.y - 5, width: 10, height: 10)
                context.fill(Path(ellipseIn: markerRect), with: .color(IntroColors.debugTreeMarker))

                // Index label
                context.draw(
                    Text("\(index)")
                        .font(.caption2)
                        .foregroundColor(.white),
                    at: CGPoint(x: screenPos.x, y: screenPos.y - 15)
                )
            }
        }
    }
}
