//
//  SlaveSyncService.swift
//  SyncProject
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 11/09/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class LCSlaveService: NSObject {

    var delegate: LCSlaveServiceDelegate?
    lazy var session: MCSession = {

        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self

        return session
    }()
    fileprivate let myPeerId = MCPeerID(displayName: "\(UIDevice.current.name) \(LCConstants.slave)")
    fileprivate let serviceBrowser: MCNearbyServiceBrowser

    override init() {
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: LCConstants.serviceType)

        super.init()

        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }

    func finishConnection() {
        session.disconnect()
        stopBrowsing()
    }

    private func stopBrowsing() {
        serviceBrowser.stopBrowsingForPeers()
    }
}

extension LCSlaveService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {

        if info?[LCConstants.discoverySyncTypeId] == LCConstants.discoveryMasterId {
            serviceBrowser.invitePeer(peerID, to: session, withContext: myPeerId.displayName.data(using: .utf8), timeout: 10)
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost peer")
    }

}

extension LCSlaveService: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected")
        case .notConnected:
            print("Not Connected")
        case .connecting:
            print("Connecting")
        @unknown default:
            fatalError()
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        delegate?.slaveSyncService(self, didReceiveDataFromMaster: data, with: peerID)
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }


}

extension LCSlaveService {

    func sendDataToMasters(data: Data) throws {
        try session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }

}
