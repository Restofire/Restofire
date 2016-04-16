//
//  Configuration.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// A Configuration object represents a configuration that will be used by 
/// requestable objects.
///
/// ```swift
/// var configuration = Configuration()
/// configuration.baseURL = "http://www.mocky.io/v2/"
/// configuration.headers = ["Content-Type": "application/json"]
/// configuration.logging = true
/// configuration.sessionConfiguration.timeoutIntervalForRequest = 5
/// configuration.sessionConfiguration.timeoutIntervalForResource = 5
/// ```
public struct Configuration {
    
    /// The base URL. `nil` by default.
    public var baseURL: String!
    
    /// The HTTP Method. `.GET` by default.
    public var method: Alamofire.Method = .GET
    
    /// The request parameter encoding. `.JSON` by default.
    public var encoding: Alamofire.ParameterEncoding = .JSON
    
    /// The HTTP headers. `nil` by default.
    public var headers: [String : String]?

    /// The Alamofire validation. `nil` by default.
    public var validation: Alamofire.Request.Validation?
    
    /// The acceptable status codes. `nil` by default.
    public var acceptableStatusCodes: [Range<Int>]?
    
    /// The acceptable content types. `nil` by default.
    public var acceptableContentTypes: [String]?
    
    /// The root keypath. `nil` by default.
    public var rootKeyPath: String?
    
    /// The logging, if enabled prints the debug textual representation of the 
    /// request when the response is recieved. `false` by default.
    public var logging: Bool = false
    
    /// The NSURL session configuration. 
    /// `NSURLSessionConfiguration.defaultSessionConfiguration()` by default.
    public var sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    
}
