//
//  Configurable.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// Represents a `Configurable` for Restofire.
/// `Configuration.default` by default.
///
/// ### Create custom Configurable
/// ```swift
/// protocol HTTPBinConfigurable: Configurable { }
///
/// extension HTTPBinConfigurable {
///
///   var configuration: Configuration {
///     var config = Configuration()
///     config.host = "httpbin.org"
///     return config
///   }
///
/// }
/// ```
public protocol Configurable: AConfigurable, Reachable, Retryable, Queueable {
    
    /// The eventually.
    var eventually: Bool { get }
    
    /// The eventually operation queue.
    var eventuallyOperationQueue: OperationQueue { get }
    
    /// The network reachability manager.
    var networkReachabilityManager: NetworkReachabilityManager { get }
    
    /// The retry error codes.
    var retryErrorCodes: Set<URLError.Code> { get }
    
    /// The retry interval.
    var retryInterval: TimeInterval { get }
    
    /// The max retry attempts.
    var maxRetryAttempts: Int { get }
    
    /// The queue on which reponse will be delivered.
    var queue: DispatchQueue? { get }
    
}

// MARK: - Default Implementation
public extension Configurable {
    
    /// `reachability.eventually`
    public var eventually: Bool {
        return reachability.eventually
    }
    
    /// `reachability.eventuallyOperationQueue`
    public var eventuallyOperationQueue: OperationQueue {
        return reachability.eventuallyOperationQueue
    }
    
    /// `reachability.networkReachabilityManager`
    public var networkReachabilityManager: NetworkReachabilityManager {
        return reachability.networkReachabilityManager
    }
    
    /// `retry.retryErrorCodes`
    public var retryErrorCodes: Set<URLError.Code> {
        return retry.retryErrorCodes
    }
    
    /// `retry.retryInterval`
    public var retryInterval: TimeInterval {
        return retry.retryInterval
    }
    
    /// `retry.maxRetryAttempts`
    public var maxRetryAttempts: Int {
        return retry.maxRetryAttempts
    }
    
    /// `Queueable.queue`
    public var queue: DispatchQueue? {
        return _queue
    }
    
}
