//
//  NetworkReachability.swift
//  Restofire
//
//  Created by Rahul Katariya on 30/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

#if !os(watchOS)
import Foundation

struct NetworkReachability {
    
    let configurable: Configurable
    
    init(configurable: Configurable) {
        self.configurable = configurable
        configurable.networkReachabilityManager.listener = { status in
            switch status {
            case .reachable(_):
                configurable.eventuallyOperationQueue.isSuspended = false
            default:
                configurable.eventuallyOperationQueue.isSuspended = true
            }
        }
        configurable.networkReachabilityManager.startListening()
    }
    
    func addOperation(operation: Operation) {
        configurable.eventuallyOperationQueue.addOperation(operation)
    }
}
#endif
