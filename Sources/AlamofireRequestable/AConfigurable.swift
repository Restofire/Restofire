//
//  AConfigurable.swift
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
/// protocol HTTPBinConfigurable: AConfigurable { }
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
    
    /// `Session.default.sessionManager`
    public var sessionManager: SessionManager {
        return _sessionManager
    }
    
    /// `Authentication.default.credential`
    public var credential: URLCredential? {
        return authentication.credential
    }
    
    /// `Validation.default.acceptableStatusCodes`
    public var acceptableStatusCodes: [Int]? {
        return validation.acceptableStatusCodes
    }
    
    /// `Validation.default.acceptableContentTypes`
    public var acceptableContentTypes: [String]? {
        return validation.acceptableContentTypes
    }
    
}

