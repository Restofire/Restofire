//
//  Validation.swift
//  Restofire
//
//  Created by Rahul Katariya on 23/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// A Validation of RESTful Services.
///
/// ```swift
/// var validation = Validation()
/// validation.acceptableStatusCodes = Array(200..<300)
/// validation.acceptableContentTypes = ["application/json"]
/// ```
public struct Validation {

    /// The acceptable status codes. `nil` by default.
    public var acceptableStatusCodes: [Int]?
    
    /// The acceptable content types. `nil` by default.
    public var acceptableContentTypes: [String]?
    
    /// `Validation` Intializer
    ///
    /// - returns: new `Validation` object
    public init() {}

}
