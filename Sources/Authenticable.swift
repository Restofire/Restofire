//
//  Authenticable.swift
//  Restofire
//
//  Created by Rahul Katariya on 23/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// Represents an `Authentication` that is associated with `Configurable`.
/// `configuration.authentication` by default.
///
/// ### Create custom authenticable
/// ```swift
/// protocol HTTPBinAuthenticable: Authenticable { }
///
/// extension HTTPBinAuthenticable {
///
///   var configuration: Configuration {
///     var authentication = Authentication()
///     authentication.credential = URLCredential(user: "user", password: "password", persistence: .forSession)
///     return authentication
///   }
///
/// }
/// ```
///
/// ### Using the above authenticable
/// ```swift
/// class HTTPBinStringGETService: Requestable, HTTPBinAuthenticable {
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
public protocol Authenticable {
    
    /// The `Authentication`.
    var authentication: Authentication { get }
    
}

extension Authenticable where Self: Configurable {
    
    /// `configuration.authentication`
    public var authentication: Authentication {
        return configuration.authentication
    }
    
}
