//
//  PictionaryApp.swift
//  Pictionary
//


import SwiftUI

@main
struct PictionaryApp: App {
    @AppStorage("yourName") var yourName = ""
    @StateObject var gameService = GameService()
    
    var body: some Scene {
        WindowGroup {
            if yourName.isEmpty {
                NameView()
            } else {
                StartView(yourName: yourName)
                    .environmentObject(gameService)
            }
        }
    }
}
