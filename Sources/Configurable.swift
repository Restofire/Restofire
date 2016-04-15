//
//  Configurable.swift
//  Restofire
//
//  Created by Rahul Katariya on 15/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// Configurable represents a configuration that can be used by multiple
/// `requestable` objects
///
/// ### Create custom configurable
/// ```swift
/// protocol HTTPBinConfigurable: Configurable { }
///
/// extension HTTPBinConfigurable {
///
///     var configuration: Configuration {
///         var config = Configuration()
///         config.baseURL = "https://httpbin.org/"
///         config.logging = true
///         return config
///     }
///
/// }
/// ```
///
/// ### Using the above configurable
/// ```swift
/// class HTTPBinStringGETService: Requestable, HTTPBinConfigurable {
///
///     let path: String = "get"
///     var rootKeyPath: String? = "args"
///     let encoding: ParameterEncoding = .URLEncodedInURL
///     var parameters: AnyObject?
///
///     init(parameters: AnyObject?) {
///         self.parameters = parameters
///     }
///
/// }
/// ```
public protocol Configurable {
    
    /// The Restofire configuration. `Restofire.defaultConfiguration` by default.
    var configuration: Configuration { get }

}

public extension Configurable {
    
    public var configuration: Configuration {
        get { return Restofire.defaultConfiguration }
    }
    
}