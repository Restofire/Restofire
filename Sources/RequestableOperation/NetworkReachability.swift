//
//  NetworkReachability.swift
//  Restofire
//
//  Created by Rahul Katariya on 30/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

#if !os(watchOS)
    
struct NetworkReachability {
    
    let configurable: Configurable
    
    init(configurable: Configurable) {
        self.configurable = configurable
    }
    
    func setupListener() {
        configurable.networkReachabilityManager.listener = { status in
            switch status {
            case .reachable(_):
                self.configurable.eventuallyOperationQueue.isSuspended = false
            default:
                self.configurable.eventuallyOperationQueue.isSuspended = true
            }
        }
        configurable.networkReachabilityManager.startListening()
    }
}
    
#endif
