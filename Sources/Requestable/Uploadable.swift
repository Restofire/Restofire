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
public protocol Uploadable: _AUploadable, DataResponseSerializable {
    
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
    
    /// Creates a `UploadOperation` for the specified `Uploadable` object and
    /// asynchronously executes it.
    ///
    /// - parameter completionHandler: A closure to be executed once the download
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `UploadOperation`.
    @discardableResult
    public func response(_ completionHandler: ((DataResponse<Response>) -> Void)? = nil) -> UploadOperation<Self> {
        let uploadOperation = UploadOperation(uploadable: self, request: request, completionHandler: completionHandler)
        uploadOperation.start()
        return uploadOperation
    }
    
}
