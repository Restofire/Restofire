//
//  Requestable.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

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
///   let method: HTTPMethod = .post
///   let parameters: Any?
///
///   init(id: String, parameters: Any? = nil) {
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
///   var request: PersonPOSTService!
///   var person: Any!
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
public protocol Requestable: Authenticable, Configurable, ResponseSerializable, Retryable, SessionManagable, Validatable, Queueable {
    
    /// The response type.
    associatedtype Response
    
    /// The scheme.
    var scheme: String { get }
    
    /// The base URL.
    var baseURL: String { get }
    
    /// The version.
    var version: String? { get }
    
    /// The path relative to base URL.
    var path: String { get }
    
    /// The url request parameters.
    var queryParameters: [String: Any]? { get }
    
    /// The HTTP Method.
    var method: HTTPMethod { get }
    
    /// The request parameter encoding.
    var encoding: ParameterEncoding { get }
    
    /// The HTTP headers.
    var headers: [String : String]? { get }
    
    /// The request parameters.
    var parameters: Any? { get }
    
    /// The Alamofire Session Manager.
    var sessionManager: SessionManager { get }
    
    /// The queue on which reponse will be delivered.
    var queue: DispatchQueue? { get }
    
    /// The credential.
    var credential: URLCredential? { get }
    
    /// The Alamofire validation.
    var validationBlock: DataRequest.Validation? { get }
    
    /// The acceptable status codes.
    var acceptableStatusCodes: [Int]? { get }
    
    /// The acceptable content types.
    var acceptableContentTypes: [String]? { get }
    
    /// The retry error codes.
    var retryErrorCodes: Set<URLError.Code> { get }
    
    /// The retry interval.
    var retryInterval: TimeInterval { get }
    
    /// The max retry attempts.
    var maxRetryAttempts: Int { get }
    
    /// Called when the Request starts.
    func didStartRequest()
    
    /// Called when the Request succeeds.
    ///
    /// - parameter response: The Alamofire Response
    func didCompleteRequestWithDataResponse(_ dataResponse: DataResponse<Self.Response>)
    
}

public extension Requestable {
    
    /// Creates a `DataRequestOperation` for the specified `Requestable` object and
    /// asynchronously executes it.
    ///
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `DataRequestOperation`.
    @discardableResult
    public func executeTask(_ completionHandler: ((DataResponse<Self.Response>) -> Void)? = nil) -> DataRequestOperation<Self> {
        let rq = requestOperation(completionHandler)
        rq.start()
        return rq
    }
    
    /// Creates a `DataRequestOperation` for the specified `Requestable` object.
    ///
    /// - parameter completionHandler: A closure to be executed once the operation
    ///                                is started and the request has finished.
    ///                                `nil` by default.
    ///
    /// - returns: The created `DataRequestOperation`.
    @discardableResult
    public func requestOperation(_ completionHandler: ((DataResponse<Self.Response>) -> Void)? = nil) -> DataRequestOperation<Self> {
        let requestOperation = DataRequestOperation(requestable: self, completionHandler: completionHandler)
        return requestOperation
    }
    
    #if !os(watchOS)
    
    /// Creates a `DataRequestEventuallyOperation` for the specified `Requestable`
    /// object and asynchronously executes it when internet is reachable.
    ///
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `DataRequestEventuallyOperation`.
    @discardableResult
    public func executeTaskEventually(_ completionHandler: ((DataResponse<Self.Response>) -> Void)? = nil) -> DataRequestEventuallyOperation<Self> {
        let req = requestEventuallyOperation(completionHandler)
        Restofire.defaultRequestEventuallyQueue.addOperation(req)
        return req
    }
    
    /// Creates a `DataRequestEventuallyOperation` for the specified requestable object.
    ///
    /// - parameter completionHandler: A closure to be executed once the operation
    ///                                is started and the request has finished.
    ///                                `nil` by default.
    ///
    /// - returns: The created `DataRequestEventuallyOperation`.
    @discardableResult
    public func requestEventuallyOperation(_ completionHandler: ((DataResponse<Self.Response>) -> Void)? = nil) -> DataRequestEventuallyOperation<Self> {
        let requestEventuallyOperation = DataRequestEventuallyOperation(requestable: self, completionHandler: completionHandler)
        return requestEventuallyOperation
    }
    
    #endif
    
}

// MARK: - Default Implementation
public extension Requestable {
    
    /// `configuration.scheme`
    public var scheme: String {
        return configuration.scheme
    }
    
    /// `configuration.BaseURL`
    public var baseURL: String {
        return configuration.baseURL
    }
    
    /// `configuration.version`
    public var version: String? {
        return configuration.version
    }
    
    /// `nil`
    public var queryParameters: [String: Any]? {
        return nil
    }
    
    /// `configuration.method`
    public var method: HTTPMethod {
        return configuration.method
    }
    
    /// `configuration.encoding`
    public var encoding: ParameterEncoding {
        return configuration.encoding
    }
    
    /// `nil`
    public var headers: [String: String]? {
        return nil
    }
    
    /// `nil`
    public var parameters: Any? {
        return nil
    }
    
    /// `configuration.sessionManager`
    public var sessionManager: SessionManager {
        return configuration.sessionManager
    }
    
    /// `configuration.queue`
    public var queue: DispatchQueue? {
        return configuration.queue
    }
    
    /// `authentication.credential`
    public var credential: URLCredential? {
        return authentication.credential
    }
    
    /// `validation.validation`
    public var validationBlock: DataRequest.Validation? {
        return validation.validationBlock
    }
    
    /// `validation.acceptableStatusCodes`
    public var acceptableStatusCodes: [Int]? {
        return validation.acceptableStatusCodes
    }
    
    /// `validation.acceptableContentTypes`
    public var acceptableContentTypes: [String]? {
        return validation.acceptableContentTypes
    }
    
    /// `retry.retryErrorCodes`
    public var retryErrorCodes: Set<URLError.Code> {
        return retry.retryErrorCodes
    }
    
    /// `retry.retryInterval`
    public var retryInterval: TimeInterval {
        return retry.retryInterval
    }
    
    /// `retry.maxRetryAttempts`
    public var maxRetryAttempts: Int {
        return retry.maxRetryAttempts
    }
    
    /// Does nothing.
    public func didStartRequest() { }
    
    /// Does nothing.
    public func didCompleteRequestWithDataResponse(_ dataResponse: DataResponse<Self.Response>) { }
    
}
