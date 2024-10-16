//
//  GameOverView.swift
//  Pictionary
//
//TODO: change this Page UI

import SwiftUI

struct GameOverView: View {
    @EnvironmentObject var gameService: GameService
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Game\nOver")
                .font(.custom(customFont, size: 100))
                .foregroundStyle(.primaryYellow)
                .multilineTextAlignment(.center)
            
            Text("Score: \(gameService.score)")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(Color("primaryYellow"))
            
            Spacer()
            
            Button {
                gameService.connectionManager?.session.disconnect()
            } label: {
                Text("Menu")
                    .foregroundStyle(Color("menuBtn"))
                    .brightness(-0.4)
                    .font(.custom(customFont, size: 40))
                    .bold()
            }
            .padding()
            .padding(.horizontal, 50)
            .background(
                Capsule(style: .circular)
                    .fill(Color("menuBtn"))
            )
            
            Spacer()
        }
        .background(
            Image("gameOverBg")
                .resizable()
                .scaledToFill()
                .scaleEffect(1.2)
        )
    }
}

#Preview {
    GameOverView()
        .environmentObject(GameService())
}
