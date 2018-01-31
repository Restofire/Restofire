//
//  Uploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 30/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// Represents a `Uploadable` for Restofire.
///
/// ```swift
/// protocol HTTPBinDownloadService: Uploadable {
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
public protocol Uploadable: _AUploadable, Configurable, DataResponseSerializable {
    
    /// Called when the Request updates with download progress.
    ///
    /// - parameter request: The Alamofire.UploadRequest
    /// - parameter progress: The Progress
    func request(_ request: UploadRequest, didDownloadProgress progress: Progress)
    
    /// Called when the Request updates with upload progress.
    ///
    /// - parameter request: The Alamofire.UploadRequest
    /// - parameter progress: The Progress
    func request(_ request: UploadRequest, didUploadProgress progress: Progress)
    
    /// Called when the Request succeeds.
    ///
    /// - parameter request: The Alamofire.UploadRequest
    /// - parameter value: The Response
    func request(_ request: UploadRequest, didCompleteWithValue value: Response)
    
    /// Called when the Request fails
    ///
    /// - parameter request: The Alamofire.UploadRequest
    /// - parameter error: The Error
    func request(_ request: UploadRequest, didFailWithError error: Error)
    
}

public extension Uploadable {
    
    /// `Does Nothing`
    func request(_ request: UploadRequest, didDownloadProgress progress: Progress) {}
    
    /// `Does Nothing`
    func request(_ request: UploadRequest, didUploadProgress progress: Progress) {}
    
    /// `Does Nothing`
    func request(_ request: UploadRequest, didCompleteWithValue value: Response) {}
    
    /// `Does Nothing`
    func request(_ request: UploadRequest, didFailWithError error: Error) {}
    
}

/// Represents a `FileUploadable` for Restofire.
public protocol FileUploadable: AFileUploadable, Uploadable {}

public extension FileUploadable {
    
    /// Creates a `UploadOperation` for the specified `Uploadable` object and
    /// asynchronously executes it.
    ///
    /// - parameter completionHandler: A closure to be executed once the download
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `UploadOperation`.
    @discardableResult
    public func response(_ completionHandler: ((DataResponse<Response>) -> Void)? = nil) -> UploadOperation<Self> {
        let uploadOperation = UploadOperation(uploadable: self, request: request(), completionHandler: completionHandler)
        uploadOperation.start()
        return uploadOperation
    }
    
}

/// Represents a `DataUploadable` for Restofire.
public protocol DataUploadable: ADataUploadable, Uploadable {}

public extension DataUploadable {
    
    /// Creates a `UploadOperation` for the specified `Uploadable` object and
    /// asynchronously executes it.
    ///
    /// - parameter completionHandler: A closure to be executed once the download
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `UploadOperation`.
    @discardableResult
    public func response(_ completionHandler: ((DataResponse<Response>) -> Void)? = nil) -> UploadOperation<Self> {
        let uploadOperation = UploadOperation(uploadable: self, request: request(), completionHandler: completionHandler)
        uploadOperation.start()
        return uploadOperation
    }
    
}

/// Represents a `StreamUploadable` for Restofire.
public protocol StreamUploadable: AStreamUploadable, Uploadable {}

public extension StreamUploadable {
    
    /// Creates a `UploadOperation` for the specified `Uploadable` object and
    /// asynchronously executes it.
    ///
    /// - parameter completionHandler: A closure to be executed once the download
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `UploadOperation`.
    @discardableResult
    public func response(_ completionHandler: ((DataResponse<Response>) -> Void)? = nil) -> UploadOperation<Self> {
        let uploadOperation = UploadOperation(uploadable: self, request: request(), completionHandler: completionHandler)
        uploadOperation.start()
        return uploadOperation
    }
    
}

/// Represents a `MultipartUploadable` for Restofire.
public protocol MultipartUploadable: AMultipartUploadable, Uploadable {}

public extension MultipartUploadable {
    
    /// Creates a `UploadOperation` for the specified `Uploadable` object and
    /// asynchronously executes it.
    ///
    /// - parameter completionHandler: A closure to be executed once the download
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `UploadOperation`.
    @discardableResult
    public func response(request: UploadRequest, completionHandler: ((DataResponse<Response>) -> Void)? = nil) -> UploadOperation<Self> {
        let uploadOperation = UploadOperation(uploadable: self, request: request, completionHandler: completionHandler)
        uploadOperation.start()
        return uploadOperation
    }
    
}

