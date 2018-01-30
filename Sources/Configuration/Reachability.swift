//
//  Reachability.swift
//  Restofire
//
//  Created by Rahul Katariya on 30/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

#if !os(watchOS)
    
import Foundation

public struct Reachability {
    
    /// The default reachability.
    public static var `default` = Reachability()
    
    /// The eventually.
    public var eventually = false
    
    /// The network reachability manager.
    public var networkReachabilityManager: NetworkReachabilityManager = {
        return NetworkReachabilityManager()!
    }()
    
    /// The eventually operation queue.
    public var eventuallyOperationQueue: OperationQueue = {
        let oq = OperationQueue()
        if #available(OSX 10.10, *) { oq.qualityOfService = .utility }
        return oq
    }()
    
}

#endif
