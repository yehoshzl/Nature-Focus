//
//  IntroAudioManager.swift
//  Nature Focus
//
//  Created by Claude on 18/01/2026.
//

import AVFoundation
import Combine

class IntroAudioManager: ObservableObject {
    private var audioPlayers: [AVAudioPlayer] = []
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupAudio()
        observeTreeSpawns()
    }

    deinit {
        cancellables.removeAll()
    }

    private func setupAudio() {
        // Try to load the pop sound file
        guard let url = Bundle.main.url(forResource: "pop", withExtension: "wav")
                ?? Bundle.main.url(forResource: "pop", withExtension: "mp3") else {
            print("Pop sound not found - audio will be disabled")
            return
        }

        // Create pool of audio players for overlapping sounds
        for _ in 0..<10 {
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                player.volume = 0.3
                audioPlayers.append(player)
            } catch {
                print("Failed to create audio player: \(error)")
            }
        }
    }

    private func observeTreeSpawns() {
        NotificationCenter.default.publisher(for: .treeSpawned)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.playPopSound()
            }
            .store(in: &cancellables)
    }

    private func playPopSound() {
        // Find an available player (not currently playing)
        guard let player = audioPlayers.first(where: { !$0.isPlaying }) else {
            // All players busy, reuse the first one
            if let firstPlayer = audioPlayers.first {
                firstPlayer.currentTime = 0
                firstPlayer.play()
            }
            return
        }

        player.currentTime = 0
        player.play()
    }
}
