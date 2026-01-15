//
//  Nature_FocusApp.swift
//  Nature Focus
//
//  Created by Yosh on 14/01/2026.
//

import SwiftUI

@main
struct Nature_FocusApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
