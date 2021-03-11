//
//  Master.swift
//  SincProject
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 20/09/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public class LCMasterFacade {

    private let syncService: LCMasterService
    public var delegate: LCMasterFacadeDelegate?

    public required init() {
        self.syncService = LCMasterService()
        self.syncService.delegate = self
    }

    public func sendData(_ data: Data) throws {
        try syncService.sendDataToSlaves(data: data)
    }

    public func finishSession() {
        syncService.finishSession()
        syncService.delegate = nil
        delegate = nil
    }

}

extension LCMasterFacade: LCMasterServiceDelegate {
    func masterSyncService(_ sender: LCMasterService, didReceive data: Data, with peerId: MCPeerID) {
        self.delegate?.didReceiveData(data, fromPeer: peerId)
    }
}
