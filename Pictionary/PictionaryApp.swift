//
//  PictionaryApp.swift
//  Pictionary
//


import SwiftUI

@main
struct PictionaryApp: App {
    @AppStorage("yourName") var yourName = "" // apple local disk , not ram
    @StateObject var gameService = GameService()
    
    var body: some Scene {
        WindowGroup {
            StartView(yourName: yourName)
                .environmentObject(gameService)
        }
    }
}
