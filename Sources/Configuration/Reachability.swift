//
//  Reachability.swift
//  Restofire
//
//  Created by Rahul Katariya on 30/01/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation

/// A Reachability for RESTful Services.
///
/// ```swift
/// var reachability = Reachability()
/// reachability.eventually = true
/// reachability.networkReachabilityManager = NetworkReachabilityManager()!
/// ```
public struct Reachability {
    
    /// The default reachability.
    public static var `default` = Reachability()
    
    #if !os(watchOS)
    /// The eventually.
    public var waitsForConnectivity = false
    
    /// The network reachability manager.
    public var networkReachabilityManager: NetworkReachabilityManager? = {
        return NetworkReachabilityManager()
    }()
    
    /// The eventually operation queue.
    public var eventuallyOperationQueue: OperationQueue = {
        let oq = OperationQueue()
        oq.maxConcurrentOperationCount = 1
        oq.qualityOfService = .utility
        return oq
    }()
    #endif
    
}
