//  Created by iOS on 11.02.2019.
//

import Foundation
import Alamofire

class ConnectivityManager: NSObject {

    static let shared = ConnectivityManager()

    private let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    var currentStatus: NetworkReachabilityManager.NetworkReachabilityStatus = .notReachable

    var isConnected: Bool {
        return reachabilityManager?.isReachable ?? false
    }

    func startNetworkReachabilityObserver() {
        reachabilityManager?.listener = { status in
            self.currentStatus = status
            switch status {
            case .notReachable:
                NotificationCenter.default.post(name: GlobalStrings.internetDisconnectedNotification, object: nil)
            case .unknown :
                print("It is unknown whether the network is reachable")
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
            }
        }
        reachabilityManager?.startListening()
    }
}
