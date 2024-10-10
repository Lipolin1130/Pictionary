//
//  Player.swift
//  Pictionary
//


import MultipeerConnectivity

class Player {
    var gamePiece: GamePiece //draw or guess
    var name: String // dislplay name
    
    var currentlyDrawing: Bool {
        if gamePiece.rawValue == "guess" {
            return false
        } else {
            return true
        }
    }
    init(gamePiece: GamePiece, name: String) {
        self.gamePiece = gamePiece
        self.name = name
    }
    
    func changeType() {
        if gamePiece == GamePiece.draw {
            gamePiece = GamePiece.guess
        } else {
            gamePiece = GamePiece.draw
        }
    }
}

enum GamePiece: String {
    case guess, draw
}
