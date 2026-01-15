//
//  TreeGridItem.swift
//  Nature Focus
//
//  Created by Yosh on 14/01/2026.
//

import SwiftUI
import CoreData

struct TreeGridItem: View {
    let session: FocusSession?
    let isEmpty: Bool
    
    var body: some View {
        ZStack {
            // Container background
            RoundedRectangle(cornerRadius: 8)
                .fill(Theme.colors.softCream.opacity(0.5))
                .frame(width: 80, height: 80)
            
            if isEmpty {
                // Empty slot - show seedling placeholder
                EmptySeedlingView()
            } else if let session = session {
                // Real tree based on session duration
                TreeView(
                    progress: 1.0, // Always show fully grown
                    isActive: false
                )
                .scaleEffect(treeScale(for: session.duration))
            }
        }
    }
    
    private func treeScale(for duration: Int32) -> CGFloat {
        let minutes = Double(duration) / 60.0
        switch minutes {
        case 0..<6:
            return 0.3 // Small seedling
        case 6..<16:
            return 0.5 // Medium sapling
        case 16..<31:
            return 0.7 // Large tree
        default:
            return 1.0 // Mature tree
        }
    }
}

struct EmptySeedlingView: View {
    var body: some View {
        ZStack {
            // Ground/Soil
            RoundedRectangle(cornerRadius: 4)
                .fill(Theme.colors.soilBrown.opacity(0.6))
                .frame(width: 40, height: 8)
                .offset(y: 15)
            
            // Small seedling
            Circle()
                .fill(Theme.colors.grassGreen.opacity(0.5))
                .frame(width: 12, height: 12)
                .offset(y: 5)
            
            // Tiny stem
            RoundedRectangle(cornerRadius: 1)
                .fill(Theme.colors.soilBrown.opacity(0.4))
                .frame(width: 2, height: 8)
                .offset(y: 10)
        }
        .frame(width: 40, height: 40)
    }
}

#Preview {
    HStack {
        // Empty slot
        TreeGridItem(session: nil, isEmpty: true)
        
        // Small tree (5 min)
        TreeGridItem(session: nil, isEmpty: false)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
    .padding()
}
