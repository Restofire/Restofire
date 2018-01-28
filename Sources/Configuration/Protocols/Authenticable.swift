//
//  Authenticable.swift
//  Restofire
//
//  Created by Rahul Katariya on 23/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// Represents an `Authenticable` that is associated with `Configurable`.
/// `configuration.authentication` by default.
///
/// ### Create custom Authenticable
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
/// ### Using the above Authenticable
/// ```swift
/// class HTTPBinStringGETService: _Requestable, HTTPBinAuthenticable {
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
    
    /// The `authentication`.
    var authentication: Authentication { get }
    
}

extension Authenticable where Self: AConfigurable {
    
    /// `Authentication.default`
    public var authentication: Authentication {
        return Authentication.default
    }
    
}
