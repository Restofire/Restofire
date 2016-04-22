//
//  Requestable.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// Represents an HTTP Request that can be asynchronously executed. You must 
/// provide a `path`.
///
/// ### Creating a request.
/// ```swift
/// import Restofire
///
/// struct PersonPOSTService: Requestable {
///
///   let path: String
///   let method: Alamofire.Method = .POST
///   let parameters: AnyObject?
///
///   init(id: String, parameters: AnyObject? = nil) {
///     self.path = "person/\(id)"
///     self.parameters = parameters
///   }
///
/// }
/// ```
///
/// ### Consuming the request.
/// ```swift
/// import Restofire
///
/// class ViewController: UIViewController  {
///
///   var request: Request!
///   var person: AnyObject!
///
///   func createPerson() {
///     request = PersonPOSTService(id: "123456789", parameters: person).executeTask()
///   }
///
///   deinit {
///     request.cancel()
///   }
///
/// }
/// ```
public protocol Requestable: Configurable {
    
    /// The base URL. `configuration.BaseURL` by default.
    var baseURL: String { get }
    
    /// The path relative to base URL.
    var path: String { get }
    
    /// The HTTP Method. `configuration.method` by default.
    var method: Alamofire.Method { get }
    
    /// The request parameter encoding. `configuration.encoding` by default.
    var encoding: Alamofire.ParameterEncoding { get }
    
    /// The HTTP headers. `configuration.headers` by default.
    var headers: [String : String]? { get }
    
    /// The request parameters. `nil` by default.
    var parameters: AnyObject? { get }
    
    /// The credential. `configuration.credential` by default.
    var credential: NSURLCredential? { get }
    
    /// The Alamofire validation. `configuration.validation` by default.
    var validation: Request.Validation? { get }
    
    /// The acceptable status codes. `configuration.acceptableStatusCodes` by default.
    var acceptableStatusCodes: [Range<Int>]? { get }
    
    /// The acceptable content types. `configuration.acceptableContentTypes` by default.
    var acceptableContentTypes: [String]? { get }
    
    /// The logging. `configuration.logging` by default.
    var logging: Bool { get }
    
    /// The Alamofire Manager. `configuration.manager` by default.
    var manager: Alamofire.Manager { get }
    
    /// The retry error codes. `configuration.retryErrorCodes` by default.
    var retryErrorCodes: Set<Int> { get }
    
    /// The retry interval. `configuration.retryInterval` by default.
    var retryInterval: NSTimeInterval { get }
    
    /// The max retry attempts. `configuration.maxRetryAttempts` by default.
    var maxRetryAttempts: Int { get }
    
}

public extension Requestable {
    
    /// Creates a `RequestOperation` for the specified `Requestable` object and
    /// asynchronously executes it.
    ///
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `RequestOperation`.
    public func executeTask(completionHandler: (Response<AnyObject, NSError> -> Void)? = nil) -> RequestOperation {
        let rq = requestOperation(completionHandler)
        rq.start()
        return rq
    }
    
    /// Creates a `RequestOperation` for the specified `Requestable` object.
    ///
    /// - parameter completionHandler: A closure to be executed once the operation
    ///                                is started and the request has finished.
    ///                                `nil` by default.
    ///
    /// - returns: The created `RequestOperation`.
    public func requestOperation(completionHandler: (Response<AnyObject, NSError> -> Void)? = nil) -> RequestOperation {
        let requestOperation = RequestOperation(requestable: self, completionHandler: completionHandler)
        return requestOperation
    }
    
    #if !os(watchOS)
    
    /// Creates a `RequestEventuallyOperation` for the specified `Requestable`
    /// object and asynchronously executes it when internet is reachable.
    ///
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `RequestEventuallyOperation`.
    public func executeTaskEventually(completionHandler: (Response<AnyObject, NSError> -> Void)? = nil) -> RequestEventuallyOperation {
        let req = requestEventuallyOperation(completionHandler)
        Restofire.defaultRequestEventuallyQueue.addOperation(req)
        return req
    }
    
    /// Creates a `RequestEventuallyOperation` for the specified requestable object.
    ///
    /// - parameter completionHandler: A closure to be executed once the operation
    ///                                is started and the request has finished.
    ///                                `nil` by default.
    ///
    /// - returns: The created `RequestEventuallyOperation`.
    public func requestEventuallyOperation(completionHandler: (Response<AnyObject, NSError> -> Void)? = nil) -> RequestEventuallyOperation {
        let requestEventuallyOperation = RequestEventuallyOperation(requestable: self, completionHandler: completionHandler)
        return requestEventuallyOperation
    }
    
    #endif
    
}

// MARK: - Default Implementation
public extension Requestable {
    
    public var baseURL: String {
        return configuration.baseURL
    }
    
    public var method: Alamofire.Method {
        return configuration.method
    }
    
    public var encoding: Alamofire.ParameterEncoding {
        return configuration.encoding
    }
    
    public var headers: [String: String]? {
        return configuration.headers
    }
    
    public var parameters: AnyObject? {
        return nil
    }
    
    public var credential: NSURLCredential? {
        return configuration.credential
    }
    
    public var validation: Request.Validation? {
        return configuration.validation
    }
    
    public var acceptableStatusCodes: [Range<Int>]? {
        return configuration.acceptableStatusCodes
    }
    
    public var acceptableContentTypes: [String]? {
        return configuration.acceptableContentTypes
    }
    
    public var logging: Bool {
        return configuration.logging
    }
    
    public var manager: Alamofire.Manager {
        return configuration.manager
    }
    
    public var retryErrorCodes: Set<Int> {
        return configuration.retryErrorCodes
    }
    
    public var retryInterval: NSTimeInterval {
        return configuration.retryInterval
    }
    
    public var maxRetryAttempts: Int {
        return configuration.maxRetryAttempts
    }
    
}
