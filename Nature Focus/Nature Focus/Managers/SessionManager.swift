//
//  SessionManager.swift
//  Nature Focus
//
//  Created by Yosh on 14/01/2026.
//

import CoreData
import Foundation
import Combine

class SessionManager: ObservableObject {
    private let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
    }
    
    func saveSession(
        startTime: Date,
        endTime: Date,
        duration: Int32,
        coinsEarned: Int32,
        completed: Bool
    ) {
        let context = persistenceController.container.viewContext
        
        let session = FocusSession(context: context)
        session.id = UUID()
        session.startTime = startTime
        session.endTime = endTime
        session.duration = duration
        session.coinsEarned = coinsEarned
        session.completed = completed
        
        persistenceController.save()
    }
    
    func getAllSessions() -> [FocusSession] {
        let context = persistenceController.container.viewContext
        let request: NSFetchRequest<FocusSession> = FocusSession.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FocusSession.startTime, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching sessions: \(error)")
            return []
        }
    }
    
    func getCompletedSessions() -> [FocusSession] {
        let context = persistenceController.container.viewContext
        let request: NSFetchRequest<FocusSession> = FocusSession.fetchRequest()
        request.predicate = NSPredicate(format: "completed == YES")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FocusSession.startTime, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching completed sessions: \(error)")
            return []
        }
    }
    
    func getTotalFocusTime() -> Int32 {
        let sessions = getCompletedSessions()
        return sessions.reduce(0) { $0 + $1.duration }
    }
    
    func getTotalCoins() -> Int32 {
        let sessions = getCompletedSessions()
        return sessions.reduce(0) { $0 + $1.coinsEarned }
    }
    
    func getSessionsToday() -> [FocusSession] {
        let context = persistenceController.container.viewContext
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        
        let request: NSFetchRequest<FocusSession> = FocusSession.fetchRequest()
        request.predicate = NSPredicate(format: "startTime >= %@ AND completed == YES", startOfDay as NSDate)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FocusSession.startTime, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching today's sessions: \(error)")
            return []
        }
    }
}
