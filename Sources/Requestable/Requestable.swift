//
//  Requestable.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

public protocol Requestable: ARequestable, Configurable {

    func didStart(request: DataRequest)
    
    func didComplete(request: DataRequest, with: DefaultDataResponse)
}

public extension Requestable {
    
    /// `Does Nothing`
    func didStart(request: DataRequest) {}
    
    /// `Does Nothing`
    func didComplete(request: DataRequest, with: DefaultDataResponse) {}
    
}

public protocol FileUploadable: AFileUploadable, Requestable {}
public protocol DataUploadable: ADataUploadable, Requestable {}
public protocol StreamUploadable: AStreamUploadable, Requestable {}
public protocol MultipartUploadable: AMultipartUploadable, Requestable {}

public extension Requestable {
    
    /// Creates a `RequestableOperation` for the specified `Requestable` object and
    /// asynchronously executes it.
    ///
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `RequestableOperation`.
    @discardableResult
    public func executeTask(_ completionHandler: ((DefaultDataResponse) -> Void)? = nil) -> RequestableOperation<Self> {
        let rq = requestOperation(completionHandler)
        rq.start()
        return rq
    }
    
    /// Creates a `RequestableOperation` for the specified `Requestable` object.
    ///
    /// - parameter completionHandler: A closure to be executed once the operation
    ///                                is started and the request has finished.
    ///                                `nil` by default.
    ///
    /// - returns: The created `RequestableOperation`.
    @discardableResult
    public func requestOperation(_ completionHandler: ((DefaultDataResponse) -> Void)? = nil) -> RequestableOperation<Self> {
        let requestOperation = RequestableOperation(requestable: self, completionHandler: completionHandler)
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
    public func executeTaskEventually(_ completionHandler: ((DefaultDataResponse) -> Void)? = nil) -> RequestableEventuallyOperation<Self> {
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
    public func requestEventuallyOperation(_ completionHandler: ((DefaultDataResponse) -> Void)? = nil) -> RequestableEventuallyOperation<Self> {
        let requestEventuallyOperation = RequestableEventuallyOperation(requestable: self, completionHandler: completionHandler)
        return requestEventuallyOperation
    }
    
    #endif
    
}
