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
    @State private var showStatsView = false

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
                // Navigation Buttons
                HStack(spacing: Theme.spacing.sm) {
                    Spacer()

                    Button(action: {
                        showStatsView = true
                    }) {
                        HStack(spacing: Theme.spacing.xs) {
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Stats")
                                .font(Theme.typography.body())
                        }
                        .foregroundColor(Theme.colors.charcoal)
                        .padding(.horizontal, Theme.spacing.md)
                        .padding(.vertical, Theme.spacing.sm)
                        .background(Theme.colors.softCream.opacity(0.9))
                        .cornerRadius(Theme.borderRadiusMedium)
                    }

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
                }
                .padding(.trailing, Theme.spacing.screenMargin)
                .padding(.top, Theme.spacing.md)
                
                Spacer()
                
                // Tree Visualization with Circular Progress Widget
                CircularProgressWidget(
                    duration: timerManager.adjustableDuration,
                    progress: timerManager.getProgress(),
                    isRunning: timerManager.isRunning
                ) {
                    Image("tree")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                }
                
                // Timer Display
                TimerView(
                    timeRemaining: timerManager.isIdle ? timerManager.adjustableDuration : timerManager.timeRemaining,
                    isActive: timerManager.isRunning
                )

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
                            Text("Great job!")
                                .font(Theme.typography.pageTitle())
                                .foregroundColor(Theme.colors.grassGreen)

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
            .navigationDestination(isPresented: $showStatsView) {
                StatsView()
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
            // Handle "r" key to cancel and return to idle
            if keyPress.characters == "r" || keyPress.characters == "R" {
                timerManager.stopSession()
                return .handled
            }
        }
        return .ignored
    }
}

#Preview {
    ContentView()
}
