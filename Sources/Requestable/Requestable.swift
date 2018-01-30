//
//  Requestable.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

public protocol Requestable: ARequestable, Configurable, DataResponseSerializable {
    
    func request(_ request: DataRequest, didDownloadProgress progress: Progress)

    func request(_ request: DataRequest, didCompleteWithValue value: Response)
    
    func request(_ request: DataRequest, didFailWithError error: Error)
    
}

public extension Requestable {
    
    /// `Does Nothing`
    func request(_ request: DataRequest, didDownloadProgress progress: Progress) {}

    /// `Does Nothing`
    func request(_ request: DataRequest, didCompleteWithValue value: Response) {}
    
    /// `Does Nothing`
    func request(_ request: DataRequest, didFailWithError error: Error) {}
    
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
    public func response(_ completionHandler: ((DataResponse<Response>) -> Void)? = nil) -> DataRequestOperation<Self> {
        let requestOperation = DataRequestOperation(requestable: self, completionHandler: completionHandler)
        requestOperation.start()
        return requestOperation
    }
    
}
