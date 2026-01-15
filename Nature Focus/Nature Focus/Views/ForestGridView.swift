//
//  ForestGridView.swift
//  Nature Focus
//
//  Created by Yosh on 14/01/2026.
//

import SwiftUI
import CoreData

struct ForestGridView: View {
    @StateObject private var sessionManager = SessionManager()
    @State private var completedSessions: [FocusSession] = []
    
    // Grid configuration
    private let columns = [
        GridItem(.adaptive(minimum: 80), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(gridItems, id: \.id) { item in
                    TreeGridItem(
                        session: item.session,
                        isEmpty: item.isEmpty
                    )
                }
            }
            .padding(Theme.spacing.screenMargin)
        }
        .background(Theme.colors.softCream)
        .navigationTitle("My Forest")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
        .onAppear {
            loadSessions()
        }
        .refreshable {
            loadSessions()
        }
    }
    
    private var gridItems: [GridItemData] {
        var items: [GridItemData] = []
        
        // Add completed sessions
        for session in completedSessions {
            items.append(GridItemData(id: session.id?.uuidString ?? UUID().uuidString, session: session, isEmpty: false))
        }
        
        // Add empty slots (seedlings) - ensure minimum grid size
        let totalSlots = max(completedSessions.count, 20) // Minimum 20 slots
        let emptySlotsNeeded = totalSlots - completedSessions.count
        
        for _ in 0..<emptySlotsNeeded {
            items.append(GridItemData(id: UUID().uuidString, session: nil, isEmpty: true))
        }
        
        // Randomize the order
        return items.shuffled()
    }
    
    private func loadSessions() {
        completedSessions = sessionManager.getCompletedSessions()
    }
}

struct GridItemData {
    let id: String
    let session: FocusSession?
    let isEmpty: Bool
}

#Preview {
    ForestGridView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
