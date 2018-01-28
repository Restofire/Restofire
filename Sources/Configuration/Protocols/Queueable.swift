//
//  Queueable.swift
//  Restofire
//
//  Created by Rahul Katariya on 15/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// Represents a `Queueable` that is associated with `Configurable`.
/// `configuration.queue` by default.
///
/// ### Create custom Queueable
/// ```swift
/// protocol HTTPBinQueueable: Queueable { }
///
/// extension HTTPBinQueueable {
///
///   var queue: DispatchQueue {
///       return DispatchQueue.main
///   }
///
/// }
/// ```
///
/// ### Using the above Queueable
/// ```swift
/// class HTTPBinStringGETService: _Requestable, HTTPBinQueueable {
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
public protocol Queueable {
    
    /// The `queue`.
    var _queue: DispatchQueue { get }
    
}

public extension Queueable where Self: AConfigurable {
    
    /// `DispatchQueue.main`
    public var _queue: DispatchQueue {
        return DispatchQueue.main
    }
    
}
