//
//  Configuration.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// A Configuration of RESTful Services. You must provide a `baseURL`.
///
/// ```swift
/// var configuration = Configuration()
/// configuration.baseURL = "http://www.mocky.io/v2/"
/// configuration.headers = ["Content-Type": "application/json"]
/// configuration.authentication.credential = NSURLCredential(user: "user", password: "password", persistence: .ForSession)
/// configuration.validation.acceptableStatusCodes = [200..<300]
/// configuration.validation.acceptableContentTypes = ["application/json"]
/// configuration.logging = true
/// configuration.retry.retryErrorCodes = [NSURLErrorTimedOut,NSURLErrorNetworkConnectionLost]
/// configuration.retry.retryInterval = 20
/// configuration.retry.maxRetryAttempts = 10
/// let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
/// sessionConfiguration.timeoutIntervalForRequest = 7
/// sessionConfiguration.timeoutIntervalForResource = 7
/// sessionConfiguration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
/// configuration.manager = Alamofire.Manager(configuration: sessionConfiguration)
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

    /// The `Authentication`.
    public var authentication = Authentication()
    
    /// The `Validation`.
    public var validation = Validation()
    
    /// The `Retry`.
    public var retry = Retry()
    
    /// The logging, if enabled prints the debug textual representation of the 
    /// request when the response is recieved. `false` by default.
    public var logging: Bool = false
    
    /// The Alamofire Manager. `Alamofire.Manager.sharedInstance` by default.
    public var manager = Alamofire.Manager.sharedInstance
    
    /// The queue on which reponse will be delivered. `dispatch_get_main_queue()`
    /// by default.
    public var queue: dispatch_queue_t? = dispatch_get_main_queue()
    
    
}
