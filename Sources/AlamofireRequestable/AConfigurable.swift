//
//  AConfigurable.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// Represents a `AConfigurable` for Alamofire Services.
/// `Configuration.default` by default.
///
/// ### Create custom AConfigurable
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

    /// The credential.
    var credential: URLCredential? { get }
    
    /// The acceptable status codes.
    var acceptableStatusCodes: [Int]? { get }
    
    /// The acceptable content types.
    var acceptableContentTypes: [String]? { get }
    
}

// MARK: - Default Implementation
public extension AConfigurable {

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
    
}

