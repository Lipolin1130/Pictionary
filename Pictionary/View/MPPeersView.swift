//
//  MCPeersVIew.swift
//  Pictionary
//

import SwiftUI

struct MPPeersView: View {
    @EnvironmentObject var connectionManager: MPConnectionManager
    @EnvironmentObject var gameService: GameService
    @Binding var startGame: Bool
    
    var body: some View {
        VStack{
            Text("Available Players")
            
            Text("Your Name: \(connectionManager.myPeerId.displayName)")
            
            List(connectionManager.availablePeers, id: \.self) {peer in
                HStack {
                    Text(peer.displayName)
                    
                    Spacer()
                    
                    Button("Select") {
                        connectionManager.nearbyServiceBrowser.invitePeer(peer, to: connectionManager.session, withContext: nil, timeout: 15)
                        gameService.mainPlayer.name = connectionManager.myPeerId.displayName
                        gameService.otherPlayer.name = peer.displayName
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .alert("Received Invitation from \(connectionManager.receivedInviteFrom?.displayName ?? "Unknown")", isPresented: $connectionManager.receivedInvite) {
                Button("Accept", role: .destructive) {
                    if let invitationHandler = connectionManager.invitationHandler {
                        invitationHandler(true, connectionManager.session)
                        
                        gameService.mainPlayer.name = connectionManager.myPeerId.displayName
                        gameService.mainPlayer.gamePiece = GamePiece.draw
                        gameService.otherPlayer.name = connectionManager.receivedInviteFrom?.displayName ?? "Unknown"
                        gameService.otherPlayer.gamePiece = GamePiece.guess
                    }
                }
                
                Button("Reject", role: .cancel) {
                    if let invitationHandler = connectionManager.invitationHandler {
                        invitationHandler(false, nil)
                    }
                }
            }
        }
        .onAppear {
            connectionManager.isAvailableToPlay = true
            connectionManager.startBrowsing()
        }
        .onDisappear {
            connectionManager.stopBrowsing()
            connectionManager.stopAdvertising()
            connectionManager.isAvailableToPlay = false
        }
        .onChange(of: connectionManager.paired) {_, newValue in
            startGame = newValue
            gameService.setUpGame(connectionManager: connectionManager)
        }
    }
}

#Preview {
    MPPeersView(startGame: .constant(false))
        .environmentObject(MPConnectionManager(yourName: "Sample"))
        .environmentObject(GameService())
}
