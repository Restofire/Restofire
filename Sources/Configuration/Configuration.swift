//
//  Configuration.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// A Configuration of RESTful Services. You must provide a `baseURL`.
///
/// ```swift
/// var configuration = Configuration()
/// configuration.baseURL = "www.mocky.io"
/// configuration.version = "/v2/"
/// configuration.headers = ["Content-Type": "application/json"]
/// configuration.authentication.credential = URLCredential(user: "user", password: "password", persistence: .forSession)
/// configuration.validation.acceptableStatusCodes = Array(200..<300)
/// configuration.validation.acceptableContentTypes = ["application/json"]
/// configuration.logging = true
/// configuration.retry.retryErrorCodes = [.timedOut,.networkConnectionLost]
/// configuration.retry.retryInterval = 20
/// configuration.retry.maxRetryAttempts = 10
/// let sessionConfiguration = URLSessionConfiguration.default
/// sessionConfiguration.timeoutIntervalForRequest = 7
/// sessionConfiguration.timeoutIntervalForResource = 7
/// sessionConfiguration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
/// configuration.manager = Alamofire.SessionManager(configuration: sessionConfiguration)
/// ```
public struct Configuration {
    
    /// The default configuration.
    public static var `default` = Configuration()
    
    /// The scheme. `http://` by default.
    public var scheme: String = "https://"
    
    /// The base URL. `nil` by default.
    public var baseURL: String!
    
    /// The version. `nil` by default.
    public var version: String?
    
    /// The url request parameters. `nil` by default.
    public var queryParameters: [String: Any]?
    
    /// The HTTP Method. `.GET` by default.
    public var method: HTTPMethod = .get
    
    /// The request parameter encoding. `.JSON` by default.
    public var encoding: ParameterEncoding = JSONEncoding.default
    
    /// The HTTP headers. `nil` by default.
    public var headers: [String : String] = [:]
    
    /// `Configuration` Intializer
    ///
    /// - returns: new `Configuration` object
    public init() {}
}
