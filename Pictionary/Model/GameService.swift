//
//  GameService.swift
//  Pictionary
//
//  Created by 李柏霖 on 2024/8/20.
//

import SwiftUI
import PencilKit

@MainActor
class GameService: ObservableObject, MPConnectingManagerDelegate {
    @Published var inGame: Bool = false //TODO: After trans start game it will be true
    @Published var isGameOver: Bool = false // Game over
    @Published var isTimeKeeper: Bool = false // Start count down
    
    @Published var mainPlayer: Player = Player(gamePiece: .guess, name: "Player 1")
    @Published var otherPlayer: Player = Player(gamePiece: .draw, name: "Player 2")
    
    @Published var currentlyDrawing: Bool = false // For mainPlayer
    @Published var drawPrompt: String = "" //Guess word MARK: not use in other device
    @Published var pastGuesses: [GuessData] = [GuessData]() // Store all Guess History
    
    @Published var score = 0 // Score
    @Published var remainingTime = maxTimeRemaing { // remain Time after countdown
        willSet {
//            if isTimeKeeper { } /* sendString() */
            if newValue < 0 { gameOver() }
        }
    }
    @Published var lastReceivedDrawing = PKDrawing()
    var connectionManager: MPConnectionManager?
    
    func setUpGame(connectionManager: MPConnectionManager) {
        self.connectionManager = connectionManager
        self.connectionManager?.delegate = self
        self.inGame = true
        self.isGameOver = false
        self.drawPrompt = everydayObjects.randomElement()!
        let transData = TransData(type: .gameStart, payload: Data(), sender: mainPlayer.name)
        connectionManager.send(transData: transData)
        self.isTimeKeeper = true
    }
    
    func swapRoles() {
        score += 1
        self.mainPlayer.changeType()
        
        drawPrompt = everydayObjects.randomElement()!
    }
    
    func gameOver() {
        isGameOver = true
    }
    
    nonisolated func didReceivedGameStart() {
        DispatchQueue.main.async {
            print("get game start")
            self.isTimeKeeper = true
        }
    }
    
    nonisolated func didReceiveGameOver() {
        DispatchQueue.main.async {
            print("get game over")
        }
    }
    
    nonisolated func didReceivedDrawData(_ drawData: DrawData) {
        DispatchQueue.main.async {
            if let drawing = try? PKDrawing(data: drawData.drawing) {
                self.lastReceivedDrawing = drawing
            } else {
                print("Failed to decode drawing data")
            }
        }
    }
    
    nonisolated func didReceivedGuessData(_ guessData: GuessData) {
        DispatchQueue.main.async {
            do {
                
                if let status = guessData.isCorrect {// Check answer
                    if status {
                        self.swapRoles()
                    }
                    self.pastGuesses.append(guessData)
                    
                    if let index = everydayObjects.firstIndex(where: {$0 == self.drawPrompt}) {
                        everydayObjects.remove(at: index)
                    }
                } else { // Need to send the response to other device
                    let isCorrect = guessData.message.lowercased() == self.drawPrompt.lowercased()
                    let responseData: GuessData = GuessData(message: guessData.message, isCorrect: isCorrect)
                    
                    if isCorrect {
                        if let index = everydayObjects.firstIndex(where: {$0 == self.drawPrompt}) {
                            everydayObjects.remove(at: index)
                        }
                    }
                    
                    if let encodedGuessData = try? JSONEncoder().encode(responseData) {
                        self.connectionManager?.send(transData: TransData(
                            type: .guess,
                            payload: encodedGuessData,
                            sender: self.mainPlayer.name))
                        print("send response")
                    }
                    
                    self.pastGuesses.append(guessData)
                    
                    if isCorrect {
                        self.swapRoles()
                    }
                }
            } catch {
                print("Error processing guess data: \(error)")
            }
        }
    }
}
