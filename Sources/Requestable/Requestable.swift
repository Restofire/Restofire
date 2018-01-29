//
//  Requestable.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

public protocol Requestable: ARequestable, Configurable, DataResponseSerializable {

    func didStart(request: DataRequest)
    
    func didComplete(request: DataRequest, response: DataResponse<Response>)
    
}

public extension Requestable {
    
    /// `Does Nothing`
    func didStart(request: DataRequest) {}
    
    /// `Does Nothing`
    func didComplete(request: DataRequest, response: DataResponse<Response>) {}
    
}

public extension Requestable {
    
    /// Creates a `RequestableOperation` for the specified `Requestable` object and
    /// asynchronously executes it.
    ///
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `RequestableOperation`.
    @discardableResult
    public func response(_ completionHandler: ((DataResponse<Response>) -> Void)? = nil) -> RequestableOperation<Self> {
        let requestOperation = RequestableOperation(requestable: self, completionHandler: completionHandler)
        requestOperation.start()
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
    public func responseEventually(_ completionHandler: ((DataResponse<Response>) -> Void)? = nil) -> RequestableEventuallyOperation<Self> {
        let requestEventuallyOperation = RequestableEventuallyOperation(requestable: self, completionHandler: completionHandler)
        Restofire.defaultRequestEventuallyQueue.addOperation(requestEventuallyOperation)
        return requestEventuallyOperation
    }
    
    #endif
    
}
