//
//  Downloadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 30/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// Represents a `Downloadable` for Restofire.
///
/// ```swift
/// protocol HTTPBinDownloadService: Downloadable {
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
public protocol Downloadable: ADownloadable, Configurable, DownloadResponseSerializable {
    
    /// Called when the Request updates with download progress.
    ///
    /// - parameter request: The Alamofire.DownloadRequest
    /// - parameter progress: The Progress
    func request(_ request: DownloadRequest, didDownloadProgress progress: Progress)
    
    /// Called when the Request succeeds.
    ///
    /// - parameter request: The Alamofire.DownloadRequest
    /// - parameter value: The Response
    func request(_ request: DownloadRequest, didCompleteWithValue value: Response)
    
    /// Called when the Request fails
    ///
    /// - parameter request: The Alamofire.DownloadRequest
    /// - parameter error: The Error
    func request(_ request: DownloadRequest, didFailWithError error: Error)
    
}

public extension Downloadable {
    
    /// `Does Nothing`
    func request(_ request: DownloadRequest, didDownloadProgress progress: Progress) {}
    
    /// `Does Nothing`
    func request(_ request: DownloadRequest, didCompleteWithValue value: Response) {}
    
    /// `Does Nothing`
    func request(_ request: DownloadRequest, didFailWithError error: Error) {}
    
}

public extension Downloadable {
    
    /// Creates a `DownloadOperation` for the specified `Requestable` object and
    /// asynchronously executes it.
    ///
    /// - parameter completionHandler: A closure to be executed once the download
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `DownloadOperation`.
    @discardableResult
    public func response(_ completionHandler: ((DownloadResponse<Response>) -> Void)? = nil) -> DownloadOperation<Self> {
        let downloadOperation = DownloadOperation(downloadable: self, completionHandler: completionHandler)
        downloadOperation.start()
        return downloadOperation
    }
    
}
