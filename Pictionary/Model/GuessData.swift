//
//  PastGuess.swift
//  Pictionary
//


import Foundation

struct GuessData: Identifiable, Codable { // store guess data (guess, correct)
    var id = UUID()
    var message: String
    var isCorrect: Bool?
}
