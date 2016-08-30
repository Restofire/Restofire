//
//  ResponseSerializable.swift
//  Restofire
//
//  Created by Rahul Katariya on 23/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// Represents a `ResponseSerializable` that is associated with `Requestable`.
/// `CustomJSONResponseSerializer()` by default.
///
/// ### Create custom response serializable
/// ```swift
/// protocol HTTPBinResponseSerializable: ResponseSerializable { }
///
/// extension HTTPBinResponseSerializable {
///
///   var responseSerializer: ResponseSerializer<Model> {
///     return Alamofire.Request.stringResponseSerializer()
///   }
///
/// }
/// ```
///
/// ### Using the above configurable
/// ```swift
/// class HTTPBinStringGETService: Requestable, HTTPBinResponseSerializable {
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
    
    /// The type of object returned in response.
    associatedtype Model
    
    /// The `Alamofire.ResponseSerializer`.
    var responseSerializer: ResponseSerializer<Model> { get }
    
}

extension ResponseSerializable {
    
    /// `CustomJSONResponseSerializer`
    public var responseSerializer: ResponseSerializer<Model> {
        return AlamofireUtils.JSONResponseSerializer()
    }
    
}
