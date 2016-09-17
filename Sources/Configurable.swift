//
//  Configurable.swift
//  Restofire
//
//  Created by Rahul Katariya on 15/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// Represents a `Configurable` that is associated with `Requestable`.
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
/// class HTTPBinStringGETService: Requestable, HTTPBinConfigurable {
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
public protocol Configurable {
    
    /// The `configuration`.
    var configuration: Configuration { get }

}

public extension Configurable where Self: Requestable {
    
    /// `Restofire.defaultConfiguration`
    public var configuration: Configuration {
        return Restofire.defaultConfiguration
    }
    
}
