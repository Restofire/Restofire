//
//  NetworkReachability.swift
//  Restofire
//
//  Created by Rahul Katariya on 30/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

#if !os(watchOS)
    
class NetworkReachability {
    
    let configurable: Configurable
    
    init(configurable: Configurable) {
        self.configurable = configurable
    }
    
    func setupListener() {
        guard let networkReachabilityManager = configurable.networkReachabilityManager else {
            assertionFailure("NetworkReachabilityManager should not be nil")
            return
        }
        networkReachabilityManager.listener = { [unowned self] status in
            switch status {
            case .reachable(_):
                self.configurable.eventuallyOperationQueue.isSuspended = false
            default:
                self.configurable.eventuallyOperationQueue.isSuspended = true
            }
        }
        networkReachabilityManager.startListening()
    }
}
    
#endif
