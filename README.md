# Local Sync

Local Sync is a framework created for transfering the data locally, using [Multipeer Connectivity](https://developer.apple.com/documentation/multipeerconnectivity).

# Table of Contents

- [Local Sync](#local-sync)
- [Table of Contents](#table-of-contents)
- [How it Works](#how-it-works)
- [How to Use it](#how-to-use-it)
  - [Master](#master)
  - [Slave](#slave)
- [Tips](#tips)
# How it Works

The communication only happen between different types of devices, masters and slaves. In other words, masters can only transfer and receive data from slaves, and slaves can only transfer and receive data from masters.

![LocalSyncCommunication](https://i.imgur.com/N0bB5pq.png)

# How to Use it

## Master
 
To become a master, that is be able to transfer and send data to slaves, you need to do the steps above.

* **Import LocalSync:**

```swift
import LocalSync
```

* **Implement the Procotol `LCMasterFacadeDelegate`:**

It is through this method that you will receive the data from slaves.

```swift
class YourClass: LCMasterFacadeDelegate {

    func didReceiveData(_ data: Data, fromPeer peerID: MCPeerID) {

        // Handle the data that you received from slaves

    }

}
```

* **Create a master sync variable:**

It is through this variable that you will send the data to slaves.

```swift

let masterSync = LCMasterFacade()
masterSync.delegate = yourClassThatImplementedLCMasterFacadeDelegate

```

## Slave

To become a slave, that is be able to transfer and send data to masters, you need to do the steps above.

* **Import LocalSync:**

```swift
import LocalSync
```

* **Implement the Procotol `LCSlaveFacadeDelegate`:**

It is through this method that you will receive the data from masters.

```swift
class YourClass: LCSlaveFacadeDelegate {

    func didReceiveData(_ data: Data, fromPeer peerID: MCPeerID) {

        // Handle the data that you received from masters

    }

}
```

* **Create a slave sync variable:**

It is through this variable that you will send the data to masters.

```swift
let slaveSync = LCSlaveFacade()
slaveSync.delegate = yourClassThatImplementedLCSlaveFacadeDelegate

```

# Tips

* **Removing the identifier from master/slave names:**

The framework uses the display name of the [`MCPeerID`](https://developer.apple.com/documentation/multipeerconnectivity/mcpeerid) to identify masters and slaves. So the display name have a UUID attached to it. So if you want to show the name of the peerID that have sended you the data, it's a good practice to remove this UUID, by doing the following

```swift
// Removing the slave UUID
peerID.displayName.replacingOccurrences(of: LCConstants.slave, with: "")

// Removing the master UUID
peerID.displayName.replacingOccurrences(of: LCConstants.master, with: "")
```