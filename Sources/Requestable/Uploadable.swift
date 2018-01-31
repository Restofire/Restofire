//
//  Uploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 30/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// Represents an abstract `Uploadable` for Restofire.
///
/// Instead implement FileUploadable, DataUploadable, StreamUploadable,
/// MultipartUplodable protocols.
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
///
/// ### Create custom FileUploadable
/// ```swift
/// protocol HTTPBinUploadService: FileUploadable {
///
///     var path: String? = "post"
///     let url: URL = FileManager.url(forResource: "rainbow", withExtension: "jpg")
///
/// }
/// ```
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
///
/// ### Create custom DataUploadable
/// ```swift
/// protocol HTTPBinUploadService: DataUploadable {
///
///     var path: String? = "post"
///     var data: Data = {
///         return "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
///            .data(using: .utf8, allowLossyConversion: false)!
///     }()
///
/// }
/// ```
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
///
/// ### Create custom StreamUploadable
/// ```swift
/// protocol HTTPBinUploadService: StreamUploadable {
///
///     var path: String? = "post"
///     var stream: InputStream = InputStream(url: FileManager.imageURL)!
///
/// }
/// ```
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
///
/// ### Create custom MultipartUploadable
/// ```swift
/// protocol HTTPBinUploadService: MultipartUploadable {
///
///     var path: String? = "post"
///     var multipartFormData: (MultipartFormData) -> Void = { multipartFormData in
///         multipartFormData.append("français".data(using: .utf8)!, withName: "french")
///         multipartFormData.append("日本語".data(using: .utf8)!, withName: "japanese")
///     }
///
/// }
/// ```
public protocol MultipartUploadable: AMultipartUploadable, Uploadable {}

public extension MultipartUploadable {
    
    /// Creates a `UploadOperation` for the specified `Uploadable` object and
    /// asynchronously executes it.
    ///
    /// - parameter request: An `Alamofire.UploadRequest`.
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

