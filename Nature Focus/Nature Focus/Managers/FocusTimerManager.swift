//
//  FocusTimerManager.swift
//  Nature Focus
//
//  Created by Yosh on 14/01/2026.
//

import Foundation
import Combine

enum TimerState {
    case idle
    case running
    case paused
    case completed
}

class FocusTimerManager: ObservableObject {
    @Published var timeRemaining: TimeInterval = 0
    @Published var state: TimerState = .idle
    @Published var coinsEarned: Int32 = 0
    @Published var startTime: Date?
    @Published var adjustableDuration: TimeInterval = 15 * 60 // 15 minutes default
    
    private var timer: Timer?
    private var pausedTimeRemaining: TimeInterval = 0
    
    var duration: TimeInterval {
        return adjustableDuration
    }
    
    var isRunning: Bool {
        return state == .running
    }
    
    var isPaused: Bool {
        return state == .paused
    }
    
    var isIdle: Bool {
        return state == .idle
    }
    
    func startSession(duration: TimeInterval? = nil) {
        let sessionDuration = duration ?? adjustableDuration
        
        if state == .paused {
            // Resume from paused state
            timeRemaining = pausedTimeRemaining
        } else {
            // Start new session
            timeRemaining = sessionDuration
            startTime = Date()
        }
        
        state = .running
        startTimer()
    }
    
    func pauseSession() {
        guard state == .running else { return }
        
        timer?.invalidate()
        timer = nil
        pausedTimeRemaining = timeRemaining
        state = .paused
    }
    
    func resumeSession() {
        guard state == .paused else { return }
        
        state = .running
        startTimer()
    }
    
    func stopSession() {
        timer?.invalidate()
        timer = nil
        state = .idle
        timeRemaining = 0
        pausedTimeRemaining = 0
        startTime = nil
        coinsEarned = 0
    }
    
    func completeSession() {
        timer?.invalidate()
        timer = nil
        
        // Calculate coins earned (1 coin per minute)
        let minutesCompleted = Int32((duration - timeRemaining) / 60)
        coinsEarned = max(1, minutesCompleted) // At least 1 coin
        
        state = .completed
    }
    
    private func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.completeSession()
            }
        }
    }
    
    func formattedTime() -> String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func getProgress() -> Double {
        guard duration > 0 else { return 0 }
        return 1.0 - (timeRemaining / duration)
    }
    
    func increaseDuration() {
        guard state == .idle else { return }
        let newDuration = adjustableDuration + 60 // Add 1 minute
        if newDuration <= 60 * 60 { // Max 60 minutes
            adjustableDuration = newDuration
        }
    }
    
    func decreaseDuration() {
        guard state == .idle else { return }
        let newDuration = adjustableDuration - 60 // Subtract 1 minute
        if newDuration >= 60 { // Min 1 minute
            adjustableDuration = newDuration
        }
    }
    
    func restartSession() {
        // Stop current timer if running
        timer?.invalidate()
        timer = nil
        
        // Reset to adjustable duration and start immediately
        timeRemaining = adjustableDuration
        startTime = Date()
        pausedTimeRemaining = 0
        coinsEarned = 0
        state = .running
        startTimer()
    }
}
