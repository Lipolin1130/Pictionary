//
//  Audio.swift
//  Pictionary
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
    
    private var backgroundPlaybackPosition: TimeInterval = 0 // 回傳背景播到哪里
    
    private func playSound(named name: String, using player: inout AVAudioPlayer?) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Sound file not found")
            return
        }// ignore 忽略
        
        do {
            if player == nil || !(player?.isPlaying ?? false) {
                player = try AVAudioPlayer(contentsOf: url)
                player?.enableRate = true // 讓速度可以被調整
                player?.rate = 1.0 // 速度
                player?.prepareToPlay()
                player?.play() // 播放
            } else {
                print("Sound \(name) is already playing")
            }
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    func adjustBackgroundSoundRate(to rate: Float) {// 調整播放速度
        if let player = backgroundPlayer {
            print("adjustBackgroundSoundRate: \(rate)")
            player.enableRate = true //here
            player.rate = rate //here
        } else {
            
        }
    }
    
    func playBackgroundSound(named name: String) {//背景音效
        playSound(named: name, using: &backgroundPlayer)
    }
    
    func playSoundEffect(named name: String) {// 答對音效
        playSound(named: name, using: &soundEffectPlayer)
    }
    
    func stopBackgroundSound() {// 暫停背景音效
        if let player = backgroundPlayer {
            backgroundPlaybackPosition = player.currentTime
            player.stop()
            backgroundPlayer = nil
        }
    }
    
    func clear() {//清除背景紀錄
        backgroundPlaybackPosition = 0
    }
}
