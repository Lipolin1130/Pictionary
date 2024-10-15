//
//  StartView.swift
//  Pictionary
//
//TODO: change this Page UI

import SwiftUI

struct StartView: View {
    @EnvironmentObject var gameService: GameService
    @StateObject var connectionManager: MPConnectionManager
    @AppStorage("yourName") var yourName = ""
    
    @State private var startGame: Bool = false
    @State private var startSearching = false
    
    init(yourName: String) {
        _connectionManager = StateObject(wrappedValue: MPConnectionManager(yourName: yourName))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
            
                HStack {
                    Image(systemName: "pencil.and.scribble")
                        .font(.system(size: 35))
                    
                    Text("Buddy Battle")
                        .font(.custom(customFont, size: 35))
                }
                
                if startSearching {
                    MPPeersView(startGame: $startGame)
                        .environmentObject(connectionManager)
                        .environmentObject(gameService)
                        .frame(width: 350)
                }
                
                Spacer()
                
                Button {
                    startSearching.toggle()
                } label: {
                    Text(startSearching ? "Cancle" : "Searching Opponent")
                }
                .buttonStyle(.borderedProminent)
                
                if !startSearching {
                    Text("Searching other device use network...")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Color("primaryYellow"))
                }
            }
            .padding()
        }
        .fullScreenCover(isPresented: $startGame) {
            GameView()
                .environmentObject(connectionManager)
        }
    }
}

#Preview {
    NavigationStack {
        StartView(yourName: "Sample")
            .environmentObject(GameService())
    }
}
