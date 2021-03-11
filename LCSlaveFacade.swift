//
//  SlaveSyncWrapper.swift
//  SincProject
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 20/09/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public class LCSlaveFacade {

    private let syncService: LCSlaveService
    public var delegate: LCSlaveFacadeDelegate?

    public required init() {
        self.syncService = LCSlaveService()
        self.syncService.delegate = self
    }

    public func sendData(_ data: Data) throws {
        try syncService.sendDataToMasters(data: data)
    }

    public func finishConnection() {
        syncService.finishConnection()
        syncService.delegate = nil
        delegate = nil
    }
}

extension LCSlaveFacade: LCSlaveServiceDelegate {
    func slaveSyncService(_ sender: LCSlaveService, didReceiveDataFromMaster data: Data, with peerId: MCPeerID) {
        self.delegate?.didReceiveData(data, fromPeer: peerId)
    }
}
