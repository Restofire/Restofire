//
//  Validatable.swift
//  Restofire
//
//  Created by Rahul Katariya on 23/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// Represents a `Validation` that is associated with `Configurable`.
/// `configuration.validation` by default.
///
/// ### Create custom Validatable
/// ```swift
/// protocol HTTPBinValidatable: Validatable { }
///
/// extension HTTPBinValidatable {
///
///   var validation: Validation {
///     var validation = Validation()
///     validation.acceptableStatusCodes = [200..<300]
///     validation.acceptableContentTypes = ["application/json"]
///     return validation
///   }
///
/// }
/// ```
///
/// ### Using the above Validatable
/// ```swift
/// class HTTPBinStringGETService: _Requestable, HTTPBinValidatable {
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
public protocol Validatable {
    
    /// The `validation`.
    var validation: Validation { get }
    
}

extension Validatable where Self: Configurable {
    
    /// `configuration.validation`
    public var validation: Validation {
        return configuration.validation
    }
        
}
