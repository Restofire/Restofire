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
    
    #if !os(watchOS)
    /// The waitsForConnectivity.
    var waitsForConnectivity: Bool { get }
    
    /// The eventually operation queue.
    var eventuallyOperationQueue: OperationQueue { get }
    
    /// The network reachability manager.
    var networkReachabilityManager: NetworkReachabilityManager { get }
    #endif
    
    /// The retry error codes.
    var retryErrorCodes: Set<URLError.Code> { get }
    
    /// The retry interval.
    var retryInterval: TimeInterval { get }
    
    /// The max retry attempts.
    var maxRetryAttempts: Int { get }
    
}

// MARK: - Default Implementation
extension Configurable {
    
    #if !os(watchOS)
    /// `Reachability.default.waitsForConnectivity`
    public var waitsForConnectivity: Bool {
        return reachability.waitsForConnectivity
    }
    
    /// `Reachability.default.eventuallyOperationQueue`
    public var eventuallyOperationQueue: OperationQueue {
        return reachability.eventuallyOperationQueue
    }
    
    /// `Reachability.default.networkReachabilityManager`
    public var networkReachabilityManager: NetworkReachabilityManager {
        return reachability.networkReachabilityManager
    }
    #endif
    
    /// `Retry.default.retryErrorCodes`
    public var retryErrorCodes: Set<URLError.Code> {
        return retry.retryErrorCodes
    }
    
    /// `Retry.default.retryInterval`
    public var retryInterval: TimeInterval {
        return retry.retryInterval
    }
    
    /// `Retry.default.maxRetryAttempts`
    public var maxRetryAttempts: Int {
        return retry.maxRetryAttempts
    }

}
