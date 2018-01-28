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
///
/// ### Create custom Configurable
/// ```swift
/// protocol HTTPBinConfigurable: Configurable { }
///
/// extension HTTPBinConfigurable {
///
///   var configuration: Configuration {
///     var config = Configuration()
///     config.baseURL = "https://httpbin.org/"
///     config.logging = Restofire.defaultConfiguration.logging
///     return config
///   }
///
/// }
/// ```
///
/// ### Using the above Configurable
/// ```swift
/// class HTTPBinStringGETService: _Requestable, HTTPBinConfigurable {
///
///   let path: String = "get"
///   let encoding: ParameterEncoding = URLEncoding.default
///   var parameters: Any?
///
///   init(parameters: Any?) {
///     self.parameters = parameters
///   }
///
/// }
/// ```
public protocol Configurable: AConfigurable, Retryable, Queueable {
    
    associatedtype Response
    
    /// The queue on which reponse will be delivered.
    var queue: DispatchQueue? { get }
    
    /// The retry error codes.
    var retryErrorCodes: Set<URLError.Code> { get }
    
    /// The retry interval.
    var retryInterval: TimeInterval { get }
    
    /// The max retry attempts.
    var maxRetryAttempts: Int { get }
    
}

// MARK: - Default Implementation
public extension Configurable {
    
    /// `Queueable.queue`
    public var queue: DispatchQueue? {
        return _queue
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
    
}

