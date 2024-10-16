//
//  MCPeersVIew.swift
//  Pictionary
//
//TODO: change this Page UI

import SwiftUI

struct MPPeersView: View {
    @EnvironmentObject var connectionManager: MPConnectionManager
    @EnvironmentObject var gameService: GameService
    @Binding var startGame: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 20){
                
                HStack {
                    Text("Hello")
                    
                    Text(connectionManager.myPeerId.displayName)
                        .foregroundStyle(.blue)
                }
                .font(.custom(customFont, size: 20))
                
                Text("Available Players")
                    .fontWeight(.semibold)
                    .font(.custom(customFont, size: 15))
                
                if connectionManager.availablePeers.isEmpty {
                    Image(systemName: "dot.radiowaves.left.and.right")
                        .font(.largeTitle)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.blue)
                        .symbolEffect(.variableColor.cumulative.dimInactiveLayers.nonReversing)
                }
                ForEach(connectionManager.availablePeers, id: \.self) {peer in
                    HStack {
                        
                        Image(systemName: "person.fill")
                        
                        Text(peer.displayName)
                        
                        Spacer()
                        
                        Button {
                            connectionManager.nearbyServiceBrowser.invitePeer(peer, to: connectionManager.session, withContext: nil, timeout: 15)
                            gameService.mainPlayer.name = connectionManager.myPeerId.displayName
                            gameService.otherPlayer.name = peer.displayName
                        } label: {
                            Text("Connect")
                                .padding(7)
                                .background(.cyan)
                                .foregroundStyle(.white)
                                .cornerRadius(5)
                        }
                    }
                    .font(.custom(customFont, size: 15))
                    .padding(.horizontal, 25)
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
