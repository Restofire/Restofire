//
//  Validation.swift
//  Restofire
//
//  Created by Rahul Katariya on 23/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// A Validation for RESTful Services.
///
/// ```swift
/// var validation = Validation()
/// validation.acceptableStatusCodes = Array(200..<300)
/// validation.acceptableContentTypes = ["application/json"]
/// ```
public struct Validation {
    
    /// The default validation.
    public static var `default` = Validation()

    /// The acceptable status codes. `nil` by default.
    public var acceptableStatusCodes: [Int]?
    
    /// The acceptable content types. `nil` by default.
    public var acceptableContentTypes: [String]?
    
    /// The `Data Validation Block`.
    public var dataValidation: DataRequest.Validation?
    
    /// The `Download Validation Block`.
    public var downloadValidation: DownloadRequest.Validation?
    
    /// `Validation` Intializer
    ///
    /// - returns: new `Validation` object
    public init() {}

}
