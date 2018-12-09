//
//  Configurable.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

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
public protocol Configurable: Authenticable, Pollable, Reachable, Retryable, SessionManagable, Validatable, Queueable, QueuePriortizable {

    /// The `configuration`.
    var configuration: Configuration { get }
    
    /// The scheme.
    var scheme: String { get }
    
    /// The base URL.
    var host: String { get }
    
    /// The version.
    var version: String? { get }
    
    /// The url request parameters.
    var queryParameters: [String: Any]? { get }
    
    /// The HTTP Method.
    var method: HTTPMethod { get }
    
    /// The request parameter encoding.
    var encoding: ParameterEncoding { get }
    
    /// The HTTP headers.
    var headers: HTTPHeaders? { get }
    
    /// The request parameters.
    var parameters: Any? { get }
    
    /// The credential.
    var credential: URLCredential? { get }
    
    /// The acceptable status codes.
    var acceptableStatusCodes: [Int]? { get }
    
    /// The acceptable content types.
    var acceptableContentTypes: [String]? { get }
    
    /// The pollingInterval.
    var pollingInterval: TimeInterval { get }
    
    #if !os(watchOS)
    /// The waitsForConnectivity.
    var waitsForConnectivity: Bool { get }
    
    /// The eventually operation queue.
    var eventuallyOperationQueue: OperationQueue { get }
    
    /// The network reachability manager.
    var networkReachabilityManager: NetworkReachabilityManager? { get }
    #endif
    
    /// The retry error codes.
    var retryErrorCodes: Set<URLError.Code> { get }
    
    /// The retry interval.
    var retryInterval: TimeInterval { get }
    
    /// The max retry attempts.
    var maxRetryAttempts: Int { get }
    
    /// The request delegates.
    var delegates: [RequestDelegate] { get }

}

// MARK: - Default Implementation
public extension Configurable {

    /// `Configuration.default`
    public var configuration: Configuration {
        return Configuration.default
    }
    
    /// `Configuration.default.scheme`
    public var scheme: String {
        return configuration.scheme
    }
    
    /// `Configuration.default.host`
    public var host: String {
        return configuration.host
    }
    
    /// `Configuration.default.version`
    public var version: String? {
        return configuration.version
    }
    
    /// `nil`
    public var queryParameters: [String: Any]? {
        return nil
    }
    
    /// `Configuration.default.method`
    public var method: HTTPMethod {
        return configuration.method
    }
    
    /// `Configuration.default.encoding`
    public var encoding: ParameterEncoding {
        return configuration.encoding
    }
    
    /// `nil`
    public var headers: HTTPHeaders? {
        return nil
    }
    
    /// `nil`
    public var parameters: Any? {
        return nil
    }
    
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
    
    /// `Poll.default.pollingInterval`
    public var pollingInterval: TimeInterval {
        return poll.pollingInterval
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
    public var networkReachabilityManager: NetworkReachabilityManager? {
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

    /// `empty`
    public var delegates: [RequestDelegate] {
        return configuration.requestDelegates
    }
    
}

