//
//  Configurable.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// Represents a `Configurable` for Alamofire Services.
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
public protocol Configurable: _Configurable, Authenticable, Reachable, Retryable, SessionManagable, RequestDelegate, Queueable, Validatable {

    /// The credential.
    var credential: URLCredential? { get }
    
    /// The acceptable status codes.
    var acceptableStatusCodes: [Int]? { get }
    
    /// The acceptable content types.
    var acceptableContentTypes: [String]? { get }
    
    /// The request delegates.
    var delegates: [RequestDelegate] { get }
    
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
public extension Configurable {

    /// `nil`
    public var credential: URLCredential? {
        return authentication.credential
    }
    
    /// `nil`
    public var acceptableStatusCodes: [Int]? {
        return validation.acceptableStatusCodes
    }
    
    /// `nil`
    public var acceptableContentTypes: [String]? {
        return validation.acceptableContentTypes
    }

    /// `empty`
    public var delegates: [RequestDelegate] {
        return configuration.requestDelegates
    }
    
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

