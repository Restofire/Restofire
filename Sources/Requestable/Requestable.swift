//
//  Requestable.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 Restofire. All rights reserved.
//

import Foundation

/// Represents a `Requestable` for Restofire.
///
/// ### Create custom Requestable
/// ```swift
/// protocol HTTPBinGETService: Requestable {
///
///     typealias Response = Data
///     var path: String? = "get"
///
/// }
/// ```
public protocol Requestable: BaseRequestable {

    /// The Alamofire data request validation.
    var validationBlock: DataRequest.Validation? { get }
    
    /// Called when the Request succeeds.
    ///
    /// - parameter request: The Alamofire.DataRequest
    /// - parameter error: The Response
    func request(_ request: RequestOperation<Self>, didCompleteWithValue value: Response)
    
    /// Called when the Request fails.
    ///
    /// - parameter request: The Alamofire.DataRequest
    /// - parameter error: The Error
    func request(_ request: RequestOperation<Self>, didFailWithError error: Error)
    
}

extension Requestable {
    
    /// `Validation.default.dataValidation`
    public var validationBlock: DataRequest.Validation? {
        return validation.dataValidation
    }
    
    /// `Does Nothing`
    func request(_ request: RequestOperation<Self>, didCompleteWithValue value: Response) {}
    
    /// `Does Nothing`
    func request(_ request: RequestOperation<Self>, didFailWithError error: Error) {}
    
}

extension Requestable {
    
    /// Creates a `DataRequest` to retrieve the contents of a URL based on the specified `Requestable`
    ///
    /// - returns: The created `DataRequest`.
    func asRequest<T: Encodable>(
        parametersType: ParametersType<T>
    ) throws -> () -> DataRequest {
        let urlRequest = try asUrlRequest(parametersType: parametersType)
        return {
            RestofireRequest.dataRequest(
                fromRequestable: self,
                withUrlRequest: urlRequest
            )
        }
    }
    
}

extension Requestable {
    
    /// Creates a `RequestOperation` for the specified `Requestable` object.
    ///
    /// - parameter downloadProgressHandler: A closure to be executed once the
    ///                                      download progresses. `nil` by default.
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `RequestOperation`.
    @discardableResult
    func operation<T: Encodable>(
        parametersType: ParametersType<T>,
        downloadProgressHandler: (((Progress) -> Void), queue: DispatchQueue?)? = nil,
        completionQueue: DispatchQueue = .main,
        completionHandler: ((DataResponse<Response>) -> Void)? = nil
    ) throws -> RequestOperation<Self> {
        let request = try self.asRequest(parametersType: parametersType)
        let requestOperation = RequestOperation(
            requestable: self,
            request: request,
            downloadProgressHandler: downloadProgressHandler,
            completionQueue: completionQueue,
            completionHandler: completionHandler
        )
        return requestOperation
    }
    
    /// Creates a `RequestOperation` for the specified `Requestable` object and
    /// asynchronously executes it.
    ///
    /// - parameter downloadProgressHandler: A closure to be executed once the
    ///                                      download progresses. `nil` by default.
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `Cancellable`.
    @discardableResult
    func enqueue<T: Encodable>(
        parametersType: ParametersType<T>,
        downloadProgressHandler: (((Progress) -> Void), queue: DispatchQueue?)? = nil,
        completionQueue: DispatchQueue = .main,
        completionHandler: ((DataResponse<Response>) -> Void)? = nil
    ) throws -> Cancellable {
        let requestOperation = try operation(
            parametersType: parametersType,
            downloadProgressHandler: downloadProgressHandler,
            completionQueue: completionQueue,
            completionHandler: completionHandler
        )
        requestQueue.addOperation(requestOperation)
        return requestOperation
    }
}

extension Requestable {
    
    /// Creates a `RequestOperation` for the specified `Requestable` object.
    ///
    /// - parameter downloadProgressHandler: A closure to be executed once the
    ///                                      download progresses. `nil` by default.
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `RequestOperation`.
    @discardableResult
    public func operation(
        parameters: Any? = nil,
        downloadProgressHandler: (((Progress) -> Void), queue: DispatchQueue?)? = nil,
        completionQueue: DispatchQueue = .main,
        completionHandler: ((DataResponse<Response>) -> Void)? = nil
    ) throws -> RequestOperation<Self> {
        let parametersType = ParametersType<EmptyCodable>.any(parameters)
        return try operation(
            parametersType: parametersType,
            downloadProgressHandler: downloadProgressHandler,
            completionQueue: completionQueue,
            completionHandler: completionHandler
        )
    }
    
    /// Creates a `RequestOperation` for the specified `Requestable` object and
    /// asynchronously executes it.
    ///
    /// - parameter downloadProgressHandler: A closure to be executed once the
    ///                                      download progresses. `nil` by default.
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `Cancellable`.
    @discardableResult
    public func enqueue(
        parameters: Any? = nil,
        downloadProgressHandler: (((Progress) -> Void), queue: DispatchQueue?)? = nil,
        completionQueue: DispatchQueue = .main,
        completionHandler: ((DataResponse<Response>) -> Void)? = nil
    ) throws -> Cancellable {
        let parametersType = ParametersType<EmptyCodable>.any(parameters)
        return try enqueue(
            parametersType: parametersType,
            downloadProgressHandler: downloadProgressHandler,
            completionQueue: completionQueue,
            completionHandler: completionHandler
        )
    }
    
}

extension Requestable {
    
    /// Creates a `RequestOperation` for the specified `Requestable` object.
    ///
    /// - parameter downloadProgressHandler: A closure to be executed once the
    ///                                      download progresses. `nil` by default.
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `RequestOperation`.
    @discardableResult
    public func operation<T: Encodable>(
        parameters: T,
        downloadProgressHandler: (((Progress) -> Void), queue: DispatchQueue?)? = nil,
        completionQueue: DispatchQueue = .main,
        completionHandler: ((DataResponse<Response>) -> Void)? = nil
    ) throws -> RequestOperation<Self> {
        let parametersType = ParametersType<T>.encodable(parameters)
        return try operation(
            parametersType: parametersType,
            downloadProgressHandler: downloadProgressHandler,
            completionQueue: completionQueue,
            completionHandler: completionHandler
        )
    }
    
    /// Creates a `RequestOperation` for the specified `Requestable` object and
    /// asynchronously executes it.
    ///
    /// - parameter downloadProgressHandler: A closure to be executed once the
    ///                                      download progresses. `nil` by default.
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `Cancellable`.
    @discardableResult
    public func enqueue<T: Encodable>(
        parameters: T,
        downloadProgressHandler: (((Progress) -> Void), queue: DispatchQueue?)? = nil,
        completionQueue: DispatchQueue = .main,
        completionHandler: ((DataResponse<Response>) -> Void)? = nil
    ) throws -> Cancellable {
        let parametersType = ParametersType<T>.encodable(parameters)
        return try enqueue(
            parametersType: parametersType,
            downloadProgressHandler: downloadProgressHandler,
            completionQueue: completionQueue,
            completionHandler: completionHandler
        )
    }
    
}
