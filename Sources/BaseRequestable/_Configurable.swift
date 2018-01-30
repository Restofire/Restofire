//
//  Configurable.swift
//  Restofire
//
//  Created by Rahul Katariya on 15/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// Represents a `Configurable` for URLSession.
/// `Configuration.default` by default.
///
/// ### Create custom Configurable
/// ```swift
/// protocol HTTPBinConfigurable: _Configurable { }
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
public protocol _Configurable {
    
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
    public var headers: [String: String]? {
        return nil
    }
    
    /// `nil`
    public var parameters: Any? {
        return nil
    }
    
}
