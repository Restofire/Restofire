//
//  Requestable.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

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
public protocol Requestable: ARequestable, DataResponseSerializable {

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
    
}

public extension Requestable {
    
    /// Creates a `RequestOperation` for the specified `Requestable` object and
    /// asynchronously executes it.
    ///
    /// - parameter request: A data request instance
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `RequestOperation`.
    @discardableResult
    public func response(request: (() -> DataRequest)? = nil, completionHandler: ((DataResponse<Response>) -> Void)? = nil) -> RequestOperation<Self> {
        let req = request ?? { return self.request }
        let requestOperation = RequestOperation(requestable: self, request: req, completionHandler: completionHandler)
        requestOperation.start()
        return requestOperation
    }
    
}
