//
//  ResponseSerializable.swift
//  Restofire
//
//  Created by Rahul Katariya on 23/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// Represents a `ResponseSerializable` that is associated with `Configurable`.
/// `configuration.responseSerializer` by default.
///
/// ### Create custom ResponseSerializable
/// ```swift
/// protocol HTTPBinResponseSerializable: ResponseSerializable { }
///
/// extension HTTPBinResponseSerializable {
///
///   var responseSerializer: Alamofire.DataResponseSerializer<Model> {
///     return Alamofire.Request.customResponseSerializer()
///   }
///
/// }
/// ```
///
/// ### Using the above ResponseSerializable
/// ```swift
/// class HTTPBinStringGETService: RequestableBase, HTTPBinResponseSerializable {
///
///   let path: String = "get"
///   let encoding: ParameterEncoding = .URLEncodedInURL
///   var parameters: Any?
///
///   init(parameters: Any?) {
///     self.parameters = parameters
///   }
///
/// }
/// ```
public protocol ResponseSerializable {
    
    /// The `responseSerializer`.
    var dataResponseSerializer: DataResponseSerializer<Any> { get }
    
}

extension ResponseSerializable where Self: Configurable  {
    
    /// `configuration.responseSerializer`
    public var dataResponseSerializer: DataResponseSerializer<Any> {
        return configuration.dataResponseSerializer
    }
    
}
