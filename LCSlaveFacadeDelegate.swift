//
//  LCSlaveWrapperDelegate.swift
//  LocalSync
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 23/09/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public protocol LCSlaveFacadeDelegate {
    func didReceiveData(_ data: Data, fromPeer peerID: MCPeerID)
}
