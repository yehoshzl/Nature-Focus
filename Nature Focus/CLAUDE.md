# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

```bash
# Build for macOS (Mac Catalyst)
cd "Nature Focus" && xcodebuild -project "Nature Focus.xcodeproj" -scheme "Nature Focus" -destination 'platform=macOS' build

# Build for iOS Simulator (requires simulator installed)
cd "Nature Focus" && xcodebuild -project "Nature Focus.xcodeproj" -scheme "Nature Focus" -destination 'platform=iOS Simulator,name=iPhone 15' build
```

No external dependencies - uses only built-in frameworks (SwiftUI, CoreData, AVFoundation, Combine).

## Architecture

**Pattern:** MVVM + Manager-based state management

### Managers (Business Logic)
- **FocusTimerManager** - Timer state machine (idle/running/paused/completed), duration adjustment, progress calculation
- **SessionManager** - Core Data CRUD operations for FocusSession entities
- **StatsManager** - Aggregates session data into daily/weekly/monthly/all-time statistics with streak calculations
- **IntroSequenceManager** - Coordinates forest intro animation timeline (tree spawning, text fades)
- **IntroAudioManager** - AVAudioPlayer pool for pop sounds, observes tree spawn notifications

### Data Flow
1. User actions trigger FocusTimerManager state changes
2. Views observe `@Published` properties via `@StateObject`/`@ObservedObject`
3. On session completion, ContentView calls SessionManager to persist
4. StatsManager recalculates aggregates from Core Data

### Core Data Model
Single entity `FocusSession` with: id (UUID), startTime, endTime, duration (Int32 seconds), coinsEarned (Int32), completed (Boolean)

## Theme System

Access via `Theme.colors`, `Theme.typography`, `Theme.spacing`:
- **Colors:** Nature palette (forestGreen, deepTeal, lightSage, grassGreen, etc.)
- **Spacing:** 8pt grid system (xs=4, sm=8, md=16, lg=24, xl=32, xxl=48)
- **Typography:** Semantic font styles (heroDisplay, pageTitle, body, caption, button)
- **IntroColors:** Separate palette for intro sequence dark green gradient

## Key Views

- **ContentView** - Main timer screen with circular progress, duration adjustment
- **ForestGridView** - Shows intro sequence first, then forest visualization with trees based on sessions
- **StatsView** - Dashboard with charts and summary cards
- **Views/Intro/** - Animated intro sequence components (FloatingPlatformView, IntroTreeView, IsometricGridHelper)

## Intro Sequence

Timeline: 0s platform appears → 2s trees spawn with bounce animation → 2.8s text fades in → 7.8s text fades out → 9.8s complete, transitions to forest view. Triple-tap toggles debug overlay showing isometric grid.
