//
//  IntroSequenceManager.swift
//  Nature Focus
//
//  Created by Claude on 18/01/2026.
//

import Foundation
import Combine

class IntroSequenceManager: ObservableObject {
    // MARK: - Published State
    @Published var phase: IntroPhase = .idle
    @Published var elapsedTime: TimeInterval = 0
    @Published var textOpacity: Double = 0
    @Published var treePlacements: [TreePlacement] = []
    @Published var spawnedTreeIndices: Set<Int> = []
    @Published var isComplete: Bool = false

    // MARK: - Configuration
    private let treeSpawnStartTime: TimeInterval = 2.0
    private let textFadeInTime: TimeInterval = 2.8
    private let textFadeInDuration: TimeInterval = 0.5
    private let textVisibleDuration: TimeInterval = 5.0
    private let textFadeOutDuration: TimeInterval = 2.0
    private let introCompleteTime: TimeInterval = 9.8

    // MARK: - Internal
    private var startTime: Date?
    private var cancellables = Set<AnyCancellable>()

    enum IntroPhase {
        case idle
        case platformFloating
        case treesSpawning
        case textVisible
        case textFadingOut
        case complete
    }

    // MARK: - Public Methods

    func startIntro(treeCount: Int) {
        treePlacements = TreePlacement.generateRandom(count: treeCount)
        phase = .platformFloating
        startTime = Date()
        spawnedTreeIndices = []
        isComplete = false
        startUpdateLoop()
    }

    func stop() {
        cancellables.removeAll()
        startTime = nil
    }

    // MARK: - Private Methods

    private func startUpdateLoop() {
        Timer.publish(every: 1.0 / 60.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.update()
            }
            .store(in: &cancellables)
    }

    private func update() {
        guard let start = startTime else { return }
        elapsedTime = Date().timeIntervalSince(start)

        updatePhase()
        updateTextOpacity()
        spawnTreesIfNeeded()

        if elapsedTime >= introCompleteTime && !isComplete {
            isComplete = true
            phase = .complete
        }
    }

    private func updatePhase() {
        switch elapsedTime {
        case 0..<2.0:
            phase = .platformFloating
        case 2.0..<2.8:
            phase = .treesSpawning
        case 2.8..<7.8:
            phase = .textVisible
        case 7.8..<9.8:
            phase = .textFadingOut
        default:
            phase = .complete
        }
    }

    private func updateTextOpacity() {
        if elapsedTime < textFadeInTime {
            textOpacity = 0
        } else if elapsedTime < textFadeInTime + textFadeInDuration {
            // Fade in
            let progress = (elapsedTime - textFadeInTime) / textFadeInDuration
            textOpacity = progress
        } else if elapsedTime < textFadeInTime + textFadeInDuration + textVisibleDuration {
            textOpacity = 1.0
        } else if elapsedTime < introCompleteTime {
            // Fade out
            let fadeStartTime = textFadeInTime + textFadeInDuration + textVisibleDuration
            let progress = (elapsedTime - fadeStartTime) / textFadeOutDuration
            textOpacity = max(0, 1.0 - progress)
        } else {
            textOpacity = 0
        }
    }

    private func spawnTreesIfNeeded() {
        guard elapsedTime >= treeSpawnStartTime else { return }

        let timeSinceSpawnStart = elapsedTime - treeSpawnStartTime

        for (index, tree) in treePlacements.enumerated() {
            if timeSinceSpawnStart >= tree.spawnDelay && !spawnedTreeIndices.contains(index) {
                spawnedTreeIndices.insert(index)
                NotificationCenter.default.post(name: .treeSpawned, object: index)
            }
        }
    }
}

// MARK: - Notifications

extension Notification.Name {
    static let treeSpawned = Notification.Name("treeSpawned")
}
