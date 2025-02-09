//
//  MPConnectingManager.swift
//  Pictionary
//


import MultipeerConnectivity

extension String {
    static var serviceName = "Pictionary"
}

protocol MPConnectingManagerDelegate: AnyObject {
    func didReceivedDrawData(_ drawData: DrawData)
    func didReceivedGuessData(_ guessData: GuessData)
    func didReceivedGameStart()
    func didReceiveGameOver()
}

class MPConnectionManager: NSObject, ObservableObject {
    weak var delegate: MPConnectingManagerDelegate?
    let serviceType = String.serviceName
    let session: MCSession
    let myPeerId: MCPeerID
    let nearbyServiceAdvertiser: MCNearbyServiceAdvertiser
    let nearbyServiceBrowser: MCNearbyServiceBrowser
    
    @Published var availablePeers = [MCPeerID]() // 可以連線的對象
    @Published var receivedInvite: Bool = false // 是否邀請連線
    @Published var receivedInviteFrom: MCPeerID? // 誰邀請
    @Published var invitationHandler: ((Bool, MCSession?) -> Void)? //建立連線
    @Published var paired: Bool = false //是否連線
    
    var isAvailableToPlay: Bool = false {
        didSet {
            if isAvailableToPlay {
                startAdvertising()
            } else {
                stopAdvertising()
            }
        }
    }
    
    init(yourName: String) {
        myPeerId = MCPeerID(displayName: yourName)
        session = MCSession(peer: myPeerId)
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        nearbyServiceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        super.init()
        session.delegate = self
        nearbyServiceAdvertiser.delegate = self
        nearbyServiceBrowser.delegate = self
    }
    
    deinit {
        stopBrowsing()
        stopAdvertising()
    }
    
    func startAdvertising() {
        nearbyServiceAdvertiser.startAdvertisingPeer()
    }
    
    func stopAdvertising() {
        nearbyServiceAdvertiser.stopAdvertisingPeer()
    }
    
    func startBrowsing() {
        nearbyServiceBrowser.startBrowsingForPeers()
    }
    
    func stopBrowsing() {
        nearbyServiceBrowser.stopBrowsingForPeers()
        availablePeers.removeAll()
    }
    
    func send(transData: TransData) {
        if !session.connectedPeers.isEmpty {
            do {
                let jsonData = try transData.toJSONData()
                try session.send(jsonData, toPeers: session.connectedPeers, with: .reliable)
                
            } catch {
                print("error sending \(error.localizedDescription)")
            }
        }
    }
}
