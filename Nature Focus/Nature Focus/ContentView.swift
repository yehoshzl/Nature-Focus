//
//  ContentView.swift
//  Nature Focus
//
//  Created by Yosh on 14/01/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var timerManager = FocusTimerManager()
    @StateObject private var sessionManager = SessionManager()
    @FocusState private var isFocused: Bool
    @State private var showForestView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
            // Background with fallback
            Theme.colors.deepTeal
                .ignoresSafeArea()
                .overlay(
                    // Background Image (will show if available, otherwise just the color shows)
                    Image("forest_background")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                )
                .overlay(
                    // Dark overlay for better text readability
                    Theme.colors.deepTeal.opacity(0.3)
                        .ignoresSafeArea()
                )
            
            VStack(spacing: Theme.spacing.xxl) {
                // Forest View Button
                HStack {
                    Spacer()
                    Button(action: {
                        showForestView = true
                    }) {
                        HStack(spacing: Theme.spacing.xs) {
                            Image(systemName: "tree.fill")
                                .font(.system(size: 16, weight: .semibold))
                            Text("My Forest")
                                .font(Theme.typography.body())
                        }
                        .foregroundColor(Theme.colors.charcoal)
                        .padding(.horizontal, Theme.spacing.md)
                        .padding(.vertical, Theme.spacing.sm)
                        .background(Theme.colors.softCream.opacity(0.9))
                        .cornerRadius(Theme.borderRadiusMedium)
                    }
                    .padding(.trailing, Theme.spacing.screenMargin)
                    .padding(.top, Theme.spacing.md)
                }
                
                Spacer()
                
                // Tree Visualization with Circular Progress Widget
                CircularProgressWidget(
                    duration: timerManager.adjustableDuration,
                    progress: timerManager.getProgress()
                ) {
                    TreeView(
                        progress: timerManager.getProgress(),
                        isActive: timerManager.isRunning
                    )
                }
                
                // Timer Display
                TimerView(
                    timeRemaining: timerManager.isIdle ? timerManager.adjustableDuration : timerManager.timeRemaining,
                    isActive: timerManager.isRunning
                )
                
                // Duration Display (when idle)
                if timerManager.isIdle {
                    VStack(spacing: Theme.spacing.sm) {
                        HStack(spacing: Theme.spacing.md) {
                            Image(systemName: "arrow.up")
                                .foregroundColor(Theme.colors.lightSage)
                            Text("\(Int(timerManager.adjustableDuration / 60)) min")
                                .font(Theme.typography.bodyLarge())
                                .foregroundColor(Theme.colors.charcoal)
                            Image(systemName: "arrow.down")
                                .foregroundColor(Theme.colors.lightSage)
                        }
                        .padding()
                        .background(Theme.colors.softCream.opacity(0.9))
                        .cornerRadius(Theme.borderRadiusMedium)
                        
                        Text("↑↓ to adjust, Enter to start")
                            .font(Theme.typography.caption())
                            .foregroundColor(Theme.colors.mediumGray)
                    }
                }
                
                // Control Buttons
                VStack(spacing: Theme.spacing.md) {
                    if timerManager.isIdle {
                        PlantButton(action: {
                            timerManager.startSession()
                        }, isActive: false)
                    } else if timerManager.isRunning {
                        VStack(spacing: Theme.spacing.md) {
                            PlantButton(action: {
                                timerManager.pauseSession()
                            }, isActive: true)
                            StopButton(action: {
                                timerManager.stopSession()
                            })
                        }
                    } else if timerManager.isPaused {
                        VStack(spacing: Theme.spacing.md) {
                            ResumeButton(action: {
                                timerManager.resumeSession()
                            })
                            StopButton(action: {
                                timerManager.stopSession()
                            })
                        }
                    } else if timerManager.state == .completed {
                        VStack(spacing: Theme.spacing.lg) {
                            Text("Great job! 🌳")
                                .font(Theme.typography.pageTitle())
                                .foregroundColor(Theme.colors.grassGreen)
                            
                            HStack(spacing: Theme.spacing.sm) {
                                Image(systemName: "bitcoinsign.circle.fill")
                                    .foregroundColor(Theme.colors.goldenYellow)
                                Text("\(timerManager.coinsEarned) coins earned!")
                                    .font(Theme.typography.bodyLarge())
                                    .foregroundColor(Theme.colors.charcoal)
                            }
                            .padding()
                            .background(Theme.colors.softCream)
                            .cornerRadius(Theme.borderRadiusLarge)
                            
                            PlantButton(action: {
                                timerManager.stopSession()
                            }, isActive: false)
                        }
                    }
                }
                .padding(.horizontal, Theme.spacing.screenMargin)
                
                Spacer()
            }
            }
            .focusable()
            .focused($isFocused)
            .onAppear {
                isFocused = true
            }
            .onKeyPress { keyPress in
                return handleKeyPress(keyPress)
            }
            .onChange(of: timerManager.state) { newState in
                if newState == .completed {
                    // Save session to Core Data
                    if let startTime = timerManager.startTime {
                        let endTime = Date()
                        let duration = Int32(timerManager.duration - timerManager.timeRemaining)
                        sessionManager.saveSession(
                            startTime: startTime,
                            endTime: endTime,
                            duration: duration,
                            coinsEarned: timerManager.coinsEarned,
                            completed: true
                        )
                    }
                }
            }
            .navigationDestination(isPresented: $showForestView) {
                ForestGridView()
            }
        }
    }
    
    private func handleKeyPress(_ keyPress: KeyPress) -> KeyPress.Result {
        switch keyPress.key {
        case .upArrow:
            if timerManager.isIdle {
                timerManager.increaseDuration()
                return .handled
            }
        case .downArrow:
            if timerManager.isIdle {
                timerManager.decreaseDuration()
                return .handled
            }
        case .return:
            if timerManager.isIdle {
                timerManager.startSession()
                return .handled
            } else if timerManager.isPaused {
                timerManager.resumeSession()
                return .handled
            }
        default:
            // Handle "r" key for restart
            if keyPress.characters == "r" || keyPress.characters == "R" {
                timerManager.restartSession()
                return .handled
            }
        }
        return .ignored
    }
}

#Preview {
    ContentView()
}
