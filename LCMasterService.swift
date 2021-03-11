//
//  MasterSyncService.swift
//  SyncProject
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 11/09/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class LCMasterService: NSObject {

    var sessions: [MCSession] = []
    var peerUUIDs: [MCPeerID: String] = [:]
    var delegate: LCMasterServiceDelegate?
    fileprivate let myPeerId = MCPeerID(displayName: "\(UIDevice.current.name) \(LCConstants.master)")
    fileprivate var serviceAdvertiser: MCNearbyServiceAdvertiser

    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId,
                                                           discoveryInfo: [LCConstants.discoverySyncTypeId : LCConstants.discoveryMasterId],
                                                           serviceType: LCConstants.serviceType)
        super.init()

        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
    }

    func finishSession() {
        sessions.forEach({ $0.disconnect() })
        stopAdvertising()
    }

    private func stopAdvertising() {
        serviceAdvertiser.stopAdvertisingPeer()
    }
}

extension LCMasterService: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {

        if serviceAdvertiser.discoveryInfo?[LCConstants.discoverySyncTypeId] == LCConstants.discoveryMasterId {

            let session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
            session.delegate = self

            sessions.append(session)

            if let context = context,
                let id = String(data: context, encoding: .utf8) {
                peerUUIDs[peerID] = id
            }

            invitationHandler(true, session)

        }
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(error.localizedDescription)
    }

}

extension LCMasterService: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {

        switch state {
        case .connected:
            print("Connected")
        case .notConnected:
            if let index = sessions.firstIndex(of: session) {
                sessions.remove(at: index)
                session.disconnect()
            }
            peerUUIDs[peerID] = nil
            print("Not Connected")
        case .connecting:
            print("Connecting")
        @unknown default:
            fatalError()
        }

    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {

        if let _ = sessions.firstIndex(of: session) {
            self.delegate?.masterSyncService(self, didReceive: data, with: peerID)
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }

}

extension LCMasterService {

    func sendDataToSlaves(data: Data) throws {

        try sessions.forEach({ session in

            if !session.connectedPeers.isEmpty {
                try session.send(data, toPeers: session.connectedPeers.filter({ $0.displayName.contains(LCConstants.slave) }), with: .reliable)
            }

        })
    }
}
