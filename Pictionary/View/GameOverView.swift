//
//  GameOverView.swift
//  Pictionary
//
//  Created by 李柏霖 on 2024/8/20.
//

import SwiftUI

struct GameOverView: View {
    @EnvironmentObject var gameService: GameService
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("gameOver")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 70)
                .padding(.vertical)
            
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
                    .font(.largeTitle)
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
