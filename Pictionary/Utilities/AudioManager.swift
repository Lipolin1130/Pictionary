//
//  Audio.swift
//  Pictionary
//
//  Created by 李柏霖 on 2024/10/15.
//

import AVFoundation
import Foundation

class AudioManager {
    static let shared = AudioManager()
    
    private var backgroundPlayer: AVAudioPlayer?
    private var soundEffectPlayer: AVAudioPlayer?
    
    var isBackgroundPlaying: Bool {
        return backgroundPlayer?.isPlaying ?? false
    }
    
    var isSoundEffectPlaying: Bool {
        return soundEffectPlayer?.isPlaying ?? false
    }
    private var backgroundPlaybackPosition: TimeInterval = 0
    
    private func playSound(named name: String, using player: inout AVAudioPlayer?) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Sound file not found")
            return
        }
        
        do {
            if player == nil || !(player?.isPlaying ?? false) {
                player = try AVAudioPlayer(contentsOf: url)
                player?.prepareToPlay()
                player?.play()
            } else {
                print("Sound \(name) is already playing")
            }
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    func playBackgroundSound(named name: String) {
        playSound(named: name, using: &backgroundPlayer)
    }
    
    func playSoundEffect(named name: String) {
        playSound(named: name, using: &soundEffectPlayer)
    }
    
    func stopBackgroundSound() {
        if let player = backgroundPlayer {
            backgroundPlaybackPosition = player.currentTime
            player.stop()
            backgroundPlayer = nil
        }
    }
    
    func clear() {
        backgroundPlaybackPosition = 0
    }
}
