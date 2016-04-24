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
/// ### Create custom validatable
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
/// ### Using the above validatable
/// ```swift
/// class HTTPBinStringGETService: Requestable, HTTPBinValidatable {
///
///   let path: String = "get"
///   let encoding: ParameterEncoding = .URLEncodedInURL
///   var parameters: AnyObject?
///
///   init(parameters: AnyObject?) {
///     self.parameters = parameters
///   }
///
/// }
/// ```
public protocol Validatable {
    
    /// The `Validation`.
    var validation: Validation { get }
    
}

extension Validatable where Self: Configurable {
    
    /// `configuration.validation`
    public var validation: Validation {
        return configuration.validation
    }
        
}