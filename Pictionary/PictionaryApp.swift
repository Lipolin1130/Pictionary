//
//  PictionaryApp.swift
//  Pictionary
//
//  Created by 李柏霖 on 2024/8/20.
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
