//
//  Requestable.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// Represents a `Requestable` for Restofire.
///
/// ### Create custom Requestable
/// ```swift
/// protocol HTTPBinGETService: Requestable {
///
///     var path: String? = "get"
///
/// }
/// ```
public protocol Requestable: ARequestable, Configurable, ResponseSerializable {

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
    
    /// `Does Nothing`
    func request(_ request: RequestOperation<Self>, didCompleteWithValue value: Response) {}
    
    /// `Does Nothing`
    func request(_ request: RequestOperation<Self>, didFailWithError error: Error) {}
    
    /// Creates a `RequestOperation` for the specified `Requestable` object.
    ///
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `RequestOperation`.
    @discardableResult
    public func operation(completionHandler: ((DataResponse<Response>) -> Void)? = nil) throws -> RequestOperation<Self> {
        let request = try self.request()
        return operation(request: request, completionHandler: completionHandler)
    }
    
    /// Creates a `RequestOperation` for the specified `Requestable` object.
    ///
    /// - parameter request: A data request instance
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `RequestOperation`.
    public func operation(request: @autoclosure @escaping () -> DataRequest, completionHandler: ((DataResponse<Response>) -> Void)? = nil) -> RequestOperation<Self> {
        let requestOperation = RequestOperation(requestable: self, request: request, completionHandler: completionHandler)
        requestOperation.queuePriority = priority
        return requestOperation
    }
    
    /// Creates a `RequestOperation` for the specified `Requestable` object and
    /// asynchronously executes it.
    ///
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `RequestOperation`.
    @discardableResult
    public func execute(completionHandler: ((DataResponse<Response>) -> Void)? = nil) throws -> RequestOperation<Self> {
        let request = try self.request()
        return execute(request: request, completionHandler: completionHandler)
    }
    
    /// Creates a `RequestOperation` for the specified `Requestable` object and
    /// asynchronously executes it.
    ///
    /// - parameter request: A data request instance
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `RequestOperation`.
    @discardableResult
    public func execute(request: @autoclosure @escaping () -> DataRequest, completionHandler: ((DataResponse<Response>) -> Void)? = nil) -> RequestOperation<Self> {
        let requestOperation = operation(request: request, completionHandler: completionHandler)
        requestQueue.addOperation(requestOperation)
        return requestOperation
    }
    
}
