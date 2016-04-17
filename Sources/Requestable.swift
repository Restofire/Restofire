//
//  Requestable.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// Requestable represents an HTTP request that can be asynchronously executed.
/// 
/// ### Creating a request.
/// ```swift
/// import Restofire
///
/// struct PersonPOSTService: Requestable {
///
///     let path: String
///     let method: Alamofire.Method = .POST
///     let parameters: AnyObject?
///
///     init(id: String, parameters: AnyObject? = nil) {
///         self.path = "person/\(id)"
///         self.parameters = parameters
///     }
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
///     var request: Request!
///     var person: AnyObject!
///
///     func createPerson() {
///         request = PersonPOSTService(id: "123456789", parameters: person).executeTask()
///     }
///
///     deinit {
///         request.cancel()
///     }
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
    var validation: Alamofire.Request.Validation? { get }
    
    /// The acceptable status codes. `configuration.acceptableStatusCodes` by default.
    var acceptableStatusCodes: [Range<Int>]? { get }
    
    /// The acceptable content types. `configuration.acceptableContentTypes` by default.
    var acceptableContentTypes: [String]? { get }
    
    /// The root keypath. `configuration.rootKeyPath` by default.
    var rootKeyPath: String? { get }
    
    /// The logging. `configuration.logging` by default.
    var logging: Bool { get }
    
    /// The Alamofire Manager. `configuration.manager` by default.
    var manager: Alamofire.Manager { get }
    
}

public extension Requestable {
    
    /// Creates a request for the specified requestable object and
    /// asynchronously executes it.
    ///
    /// - parameter completionHandler: A closure to be executed once the request 
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created Alamofire request.
    public func executeTask(completionHandler: (Response<AnyObject, NSError> -> Void)? = nil) -> Alamofire.Request {
        let request = Request(requestable: self)
        request.executeTask { (response: Response<AnyObject, NSError>) in
            if let completionHandler = completionHandler {
                completionHandler(response)
            }
        }
        return request.request
    }
    
    /// Creates a request operation for the specified requestable object.
    ///
    /// - parameter completionHandler: A closure to be executed once the operation
    ///                                is started and the request has finished.
    ///                                `nil` by default.
    ///
    /// - returns: The created RequestOperation object.
    public func requestOperation(completionHandler: (Response<AnyObject, NSError> -> Void)? = nil) -> RequestOperation {
        let requestOperation = RequestOperation(requestable: self, completionHandler: completionHandler)
        return requestOperation
    }
    
}

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
    
    public var validation: Alamofire.Request.Validation? {
        return configuration.validation
    }
    
    public var acceptableStatusCodes: [Range<Int>]? {
        return configuration.acceptableStatusCodes
    }
    
    public var acceptableContentTypes: [String]? {
        return configuration.acceptableContentTypes
    }
    
    public var rootKeyPath: String? {
        return configuration.rootKeyPath
    }
    
    public var logging: Bool {
        return configuration.logging
    }
    
    public var manager: Alamofire.Manager {
        return configuration.manager
    }
    
    public var request: Alamofire.Request {
        
        var request: Alamofire.Request!
        
        request = manager.request(method, baseURL + path, parameters: parameters as? [String: AnyObject], encoding: encoding, headers: headers)
        
        if let parameters = parameters as? [AnyObject] {
            switch method {
            case .GET:
                // FIXME: Check for other methods that don't support array as request parameters.
                break
            default:
                let encodedURLRequest = Request.encodeURLRequest(request.request!, parameters: parameters, encoding: encoding).0
                request = Alamofire.request(encodedURLRequest)
            }
        }
        
        return request
        
    }
    
}
