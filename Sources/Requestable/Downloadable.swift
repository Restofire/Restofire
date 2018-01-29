//
//  Downloadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public protocol Downloadable: ADownloadable, Configurable, DownloadResponseSerializable {
    
    func didStart(request: DownloadRequest)
    
    func didComplete(request: DownloadRequest, withResponse: DownloadResponse<Response>)
}

public extension Downloadable {
    
    /// `Does Nothing`
    func didStart(request: DownloadRequest) {}
    
    /// `Does Nothing`
    func didComplete(request: DownloadRequest, withResponse: DownloadResponse<Response>) {}
    
}

public extension Downloadable {
    
    /// Creates a `DownloadableOperation` for the specified `Downloadable` object and
    /// asynchronously executes it.
    ///
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `DownloadableOperation`.
    @discardableResult
    public func executeTask(_ completionHandler: ((DownloadResponse<Response>) -> Void)? = nil) -> DownloadableOperation<Self> {
        let rq = requestOperation(completionHandler)
        rq.start()
        return rq
    }
    
    /// Creates a `DownloadableOperation` for the specified `Downloadable` object.
    ///
    /// - parameter completionHandler: A closure to be executed once the operation
    ///                                is started and the request has finished.
    ///                                `nil` by default.
    ///
    /// - returns: The created `DownloadableOperation`.
    @discardableResult
    public func requestOperation(_ completionHandler: ((DownloadResponse<Response>) -> Void)? = nil) -> DownloadableOperation<Self> {
        let requestOperation = DownloadableOperation(downloadable: self, completionHandler: completionHandler)
        return requestOperation
    }
    
    #if !os(watchOS)
    
    /// Creates a `DataRequestEventuallyOperation` for the specified `Downloadable`
    /// object and asynchronously executes it when internet is reachable.
    ///
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `DataRequestEventuallyOperation`.
    @discardableResult
    public func executeTaskEventually(_ completionHandler: ((DownloadResponse<Response>) -> Void)? = nil) -> DownloadableEventuallyOperation<Self> {
        let req = requestEventuallyOperation(completionHandler)
        Restofire.defaultRequestEventuallyQueue.addOperation(req)
        return req
    }
    
    /// Creates a `DataRequestEventuallyOperation` for the specified Downloadable object.
    ///
    /// - parameter completionHandler: A closure to be executed once the operation
    ///                                is started and the request has finished.
    ///                                `nil` by default.
    ///
    /// - returns: The created `DataRequestEventuallyOperation`.
    @discardableResult
    public func requestEventuallyOperation(_ completionHandler: ((DownloadResponse<Response>) -> Void)? = nil) -> DownloadableEventuallyOperation<Self> {
        let requestEventuallyOperation = DownloadableEventuallyOperation(downloadable: self, completionHandler: completionHandler)
        return requestEventuallyOperation
    }
    
    #endif
    
}
