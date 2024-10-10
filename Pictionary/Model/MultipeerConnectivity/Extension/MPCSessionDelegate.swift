//
//  MPCSessionDelegate.swift
//  Pictionary
//


import MultipeerConnectivity
import PencilKit

extension MPConnectionManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            DispatchQueue.main.async {
                self.paired = false
                self.isAvailableToPlay = true
            }
        case .connected:
            DispatchQueue.main.async {
                self.paired = true
                self.isAvailableToPlay = false
            }
        default:
            DispatchQueue.main.async {
                self.paired = false
                self.isAvailableToPlay = true
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer fromPeerID: MCPeerID) {
        do {
            let receivedtransData: TransData = try TransData.decodePayload(from: data)
            switch receivedtransData.type {
            case .draw:
                let drawData: DrawData = try receivedtransData.decodedPayload()
                delegate?.didReceivedDrawData(drawData)
            case .guess:
                let guessData: GuessData = try receivedtransData.decodedPayload()
                delegate?.didReceivedGuessData(guessData)
            case .gameStart:
                delegate?.didReceivedGameStart()
            case .gameOver:
                delegate?.didReceiveGameOver()
            }
        } catch {
            print("Failed to decode TransData \(error)")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
        
    }
}
