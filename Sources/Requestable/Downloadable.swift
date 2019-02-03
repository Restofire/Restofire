//
//  Downloadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 30/01/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation
import Alamofire

/// Represents a `Downloadable` for Restofire.
///
/// ```swift
/// protocol HTTPBinDownloadService: Downloadable {
///
///     typealias Response = Data
///
///     var path: String? = "bytes/\(4 * 1024 * 1024)"
///     var destination: DownloadFileDestination?
///
///     init(destination: @escaping DownloadFileDestination) {
///         self.destination = destination
///     }
///
/// }
/// ```
public protocol Downloadable: _Requestable {
    
    /// The resume data.
    var resumeData: Data? { get }
    
    /// The download file destination.
    var destination: DownloadRequest.Destination? { get }
    
    /// The Alamofire data request validation.
    var validationBlock: DownloadRequest.Validation? { get }
    
    /// Called when the Request succeeds.
    ///
    /// - parameter request: The Alamofire.DownloadRequest
    /// - parameter value: The Response
    func request(_ request: DownloadOperation<Self>, didCompleteWithValue value: Response)
    
    /// Called when the Request fails
    ///
    /// - parameter request: The Alamofire.DownloadRequest
    /// - parameter error: The Error
    func request(_ request: DownloadOperation<Self>, didFailWithError error: Error)
    
}

public extension Downloadable {
    
    /// `nil`
    public var resumeData: Data? {
        return nil
    }
    
    /// `nil`
    public var destination: DownloadRequest.Destination? {
        return nil
    }
    
    /// `Validation.default.downloadValidation`
    public var validationBlock: DownloadRequest.Validation? {
        return validation.downloadValidation
    }
    
    /// `Does Nothing`
    func request(_ request: DownloadOperation<Self>, didCompleteWithValue value: Response) {}
    
    /// `Does Nothing`
    func request(_ request: DownloadOperation<Self>, didFailWithError error: Error) {}
    
}

public extension Downloadable {
    
    /// Creates a `DownloadRequest` to retrieve the contents of a URL based on the specified `Requestable`
    ///
    /// - returns: The created `DownloadRequest`.
    func asRequest() throws -> DownloadRequest {
        return RestofireRequest.downloadRequest(
            fromRequestable: self,
            withUrlRequest: try asUrlRequest()
        )
    }
    
}

public extension Downloadable {
    
    /// Creates a `DownloadOperation` for the specified `Requestable` object.
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
        completionHandler: ((DownloadResponse<Response>) -> Void)? = nil
    ) throws -> DownloadOperation<Self> {
        let request = try self.asRequest()
        return operation(
            request: request,
            downloadProgressHandler: downloadProgressHandler,
            completionHandler: completionHandler
        )
    }
    
    /// Creates a `DownloadOperation` for the specified `Requestable` object.
    ///
    /// - parameter request: A data request instance
    /// - parameter downloadProgressHandler: A closure to be executed once the
    ///                                      download progresses. `nil` by default.
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `RequestOperation`.
    public func operation(
        request: @autoclosure @escaping () -> DownloadRequest,
        downloadProgressHandler: ((Progress) -> Void)? = nil,
        completionHandler: ((DownloadResponse<Response>) -> Void)? = nil
    ) -> DownloadOperation<Self> {
        let downloadOperation = DownloadOperation(
            downloadable: self,
            request: request,
            downloadProgressHandler: downloadProgressHandler,
            completionHandler: completionHandler
        )
        return downloadOperation
    }
    
    /// Creates a `DownloadOperation` for the specified `Requestable` object and
    /// asynchronously executes it.
    ///
    /// - parameter downloadProgressHandler: A closure to be executed once the
    ///                                      download progresses. `nil` by default.
    /// - parameter completionHandler: A closure to be executed once the download
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `DownloadOperation`.
    @discardableResult
    public func execute(
        downloadProgressHandler: ((Progress) -> Void)? = nil,
        completionHandler: ((DownloadResponse<Response>) -> Void)? = nil
    ) throws -> DownloadOperation<Self> {
        let request = try self.asRequest()
        return execute(
            request: request,
            downloadProgressHandler: downloadProgressHandler,
            completionHandler: completionHandler
        )
    }
    
    /// Creates a `DownloadOperation` for the specified `Requestable` object and
    /// asynchronously executes it.
    ///
    /// - parameter request: A download request instance
    /// - parameter downloadProgressHandler: A closure to be executed once the
    ///                                      download progresses. `nil` by default.
    /// - parameter completionHandler: A closure to be executed once the download
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `DownloadOperation`.
    @discardableResult
    public func execute(
        request: @autoclosure @escaping () -> DownloadRequest,
        downloadProgressHandler: ((Progress) -> Void)? = nil,
        completionHandler: ((DownloadResponse<Response>) -> Void)? = nil
    ) -> DownloadOperation<Self> {
        let downloadOperation = operation(
            request: request,
            downloadProgressHandler: downloadProgressHandler,
            completionHandler: completionHandler
        )
        downloadQueue.addOperation(downloadOperation)
        return downloadOperation
    }
    
}
