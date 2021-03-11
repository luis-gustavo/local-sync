//
//  MasterSyncServiceDelegate.swift
//  SyncProject
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 12/09/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol LCMasterServiceDelegate {
    func masterSyncService(_ sender: LCMasterService, didReceive data: Data, with peerId: MCPeerID)
}
