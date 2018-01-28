//
//  Configurable.swift
//  Restofire
//
//  Created by Rahul Katariya on 15/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
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
public protocol _Configurable {
    
    /// The `configuration`.
    var configuration: Configuration { get }
    
    /// The scheme.
    var scheme: String { get }
    
    /// The base URL.
    var baseURL: String { get }
    
    /// The version.
    var version: String? { get }
    
    /// The url request parameters.
    var queryParameters: [String: Any]? { get }
    
    /// The HTTP Method.
    var method: HTTPMethod { get }
    
    /// The request parameter encoding.
    var encoding: ParameterEncoding { get }
    
    /// The HTTP headers.
    var headers: [String : String]? { get }
    
    /// The request parameters.
    var parameters: Any? { get }
    
}

// MARK: - Default Implementation
public extension _Configurable {
    
    /// `Configuration.default`
    public var configuration: Configuration {
        return Configuration.default
    }
    
    /// `configuration.scheme`
    public var scheme: String {
        return configuration.scheme
    }
    
    /// `configuration.BaseURL`
    public var baseURL: String {
        return configuration.baseURL
    }
    
    /// `configuration.version`
    public var version: String? {
        return configuration.version
    }
    
    /// `nil`
    public var queryParameters: [String: Any]? {
        return nil
    }
    
    /// `configuration.method`
    public var method: HTTPMethod {
        return configuration.method
    }
    
    /// `configuration.encoding`
    public var encoding: ParameterEncoding {
        return configuration.encoding
    }
    
    /// `nil`
    public var headers: [String: String]? {
        return nil
    }
    
    /// `nil`
    public var parameters: Any? {
        return nil
    }
    
}
