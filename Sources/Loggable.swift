//
//  Loggable.swift
//  Restofire
//
//  Created by Rahul Katariya on 23/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// Represents an `Loggable` that is associated with `Configurable`.
/// `true` by default.
///
/// ```swift
/// class HTTPBinStringGETService: Requestable, Loggable {
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
public protocol Loggable {
    
    /// The `logging`.
    var logging: Bool { get }
    
}

extension Loggable where Self: Configurable {
    
    /// `true`
    public var logging: Bool {
        return true
    }
    
}

/// Represents an `NotLoggable` that is associated with `Configurable`.
/// `false` by default.
///
/// ```swift
/// class HTTPBinStringGETService: Requestable, NotLoggable {
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
public protocol NotLoggable: Loggable { }

extension NotLoggable where Self: Configurable {
    
    /// `false`
    public var logging: Bool {
        return false
    }
    
}
