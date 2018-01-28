//
//  AConfigurable.swift
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
public protocol AConfigurable: _Configurable, Authenticable, SessionManagable, Validatable {
    
    /// The Alamofire Session Manager.
    var sessionManager: SessionManager { get }
    
    /// The credential.
    var credential: URLCredential? { get }
    
    /// The acceptable status codes.
    var acceptableStatusCodes: [Int]? { get }
    
    /// The acceptable content types.
    var acceptableContentTypes: [String]? { get }
    
}

// MARK: - Default Implementation
public extension AConfigurable {
    
    /// `configuration.sessionManager`
    public var sessionManager: SessionManager {
        return _sessionManager
    }
    
    /// `authentication.credential`
    public var credential: URLCredential? {
        return authentication.credential
    }
    
    /// `validation.acceptableStatusCodes`
    public var acceptableStatusCodes: [Int]? {
        return validation.acceptableStatusCodes
    }
    
    /// `validation.acceptableContentTypes`
    public var acceptableContentTypes: [String]? {
        return validation.acceptableContentTypes
    }
    
}

