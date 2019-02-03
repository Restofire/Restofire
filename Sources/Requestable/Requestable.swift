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
public protocol Requestable: _Requestable {

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

public extension Requestable {
    
    /// `Validation.default.dataValidation`
    public var validationBlock: DataRequest.Validation? {
        return validation.dataValidation
    }
    
    /// `Does Nothing`
    func request(_ request: RequestOperation<Self>, didCompleteWithValue value: Response) {}
    
    /// `Does Nothing`
    func request(_ request: RequestOperation<Self>, didFailWithError error: Error) {}
    
}

public extension Requestable {
    
    /// Creates a `DataRequest` to retrieve the contents of a URL based on the specified `Requestable`
    ///
    /// - returns: The created `DataRequest`.
    func asRequest() throws -> DataRequest {
        return RestofireRequest.dataRequest(
            fromRequestable: self,
            withUrlRequest: try asUrlRequest()
        )
    }
    
}

public extension Requestable {
    
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
        downloadProgressHandler: ((Progress) -> Void)? = nil,
        completionHandler: ((DataResponse<Response>) -> Void)? = nil
    ) throws -> RequestOperation<Self> {
        let request = try self.asRequest()
        return operation(
            request: request,
            downloadProgressHandler: downloadProgressHandler,
            completionHandler: completionHandler
        )
    }
    
    /// Creates a `RequestOperation` for the specified `Requestable` object.
    ///
    /// - parameter request: A data request instance
    /// - parameter downloadProgressHandler: A closure to be executed once the
    ///                                      download progresses. `nil` by default.
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `RequestOperation`.
    public func operation(
        request: @autoclosure @escaping () -> DataRequest,
        downloadProgressHandler: ((Progress) -> Void)? = nil,
        completionHandler: ((DataResponse<Response>) -> Void)? = nil
    ) -> RequestOperation<Self> {
        let requestOperation = RequestOperation(
            requestable: self,
            request: request,
            downloadProgressHandler: downloadProgressHandler,
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
    /// - returns: The created `RequestOperation`.
    @discardableResult
    public func execute(
        downloadProgressHandler: ((Progress) -> Void)? = nil,
        completionHandler: ((DataResponse<Response>) -> Void)? = nil
    ) throws -> RequestOperation<Self> {
        let request = try self.asRequest()
        return execute(
            request: request,
            downloadProgressHandler: downloadProgressHandler,
            completionHandler: completionHandler
        )
    }
    
    /// Creates a `RequestOperation` for the specified `Requestable` object and
    /// asynchronously executes it.
    ///
    /// - parameter request: A data request instance
    /// - parameter downloadProgressHandler: A closure to be executed once the
    ///                                      download progresses. `nil` by default.
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `RequestOperation`.
    @discardableResult
    public func execute(
        request: @autoclosure @escaping () -> DataRequest,
        downloadProgressHandler: ((Progress) -> Void)? = nil,
        completionHandler: ((DataResponse<Response>) -> Void)? = nil
    ) -> RequestOperation<Self> {
        let requestOperation = operation(
            request: request,
            downloadProgressHandler: downloadProgressHandler,
            completionHandler: completionHandler
        )
        requestQueue.addOperation(requestOperation)
        return requestOperation
    }
    
}
