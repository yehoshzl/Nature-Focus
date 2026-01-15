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

    func getSessions(from startDate: Date, to endDate: Date) -> [FocusSession] {
        let context = persistenceController.container.viewContext
        let request: NSFetchRequest<FocusSession> = FocusSession.fetchRequest()
        request.predicate = NSPredicate(
            format: "startTime >= %@ AND startTime < %@ AND completed == YES",
            startDate as NSDate,
            endDate as NSDate
        )
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FocusSession.startTime, ascending: true)]

        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching sessions in range: \(error)")
            return []
        }
    }

    func getDatesWithSessions() -> [Date] {
        let sessions = getCompletedSessions()
        let calendar = Calendar.current
        let dates = sessions.compactMap { session -> Date? in
            guard let startTime = session.startTime else { return nil }
            return calendar.startOfDay(for: startTime)
        }
        return Array(Set(dates)).sorted()
    }

    func getFirstSessionDate() -> Date? {
        let context = persistenceController.container.viewContext
        let request: NSFetchRequest<FocusSession> = FocusSession.fetchRequest()
        request.predicate = NSPredicate(format: "completed == YES")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FocusSession.startTime, ascending: true)]
        request.fetchLimit = 1

        do {
            let sessions = try context.fetch(request)
            return sessions.first?.startTime
        } catch {
            print("Error fetching first session: \(error)")
            return nil
        }
    }

    func getSessionsForWeek(containing date: Date) -> [FocusSession] {
        let calendar = Calendar.current
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) else {
            return []
        }
        return getSessions(from: weekInterval.start, to: weekInterval.end)
    }

    func getSessionsForMonth(containing date: Date) -> [FocusSession] {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else {
            return []
        }
        return getSessions(from: monthInterval.start, to: monthInterval.end)
    }
}
