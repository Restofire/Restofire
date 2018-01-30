//
//  Configurable.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// Represents a `Configurable` that is associated with `_Requestable`.
/// `Restofire.defaultConfiguration()` by default.
#if !os(watchOS)
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

#else
public protocol Configurable: AConfigurable, Retryable, Queueable {
    
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

#endif
