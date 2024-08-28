//
//  PastGuess.swift
//  Pictionary
//
//  Created by 李柏霖 on 2024/8/21.
//

import Foundation

struct GuessData: Identifiable, Codable { // store guess data (guess, correct)
    var id = UUID()
    var message: String
    var isCorrect: Bool?
}
