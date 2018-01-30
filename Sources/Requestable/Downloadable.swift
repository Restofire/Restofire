//
//  Downloadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 30/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public protocol Downloadable: ADownloadable, Configurable, DownloadResponseSerializable {
    
    func request(_ request: DownloadRequest, didDownloadProgress progress: Progress)
    
    func request(_ request: DownloadRequest, didCompleteWithValue value: Response)
    
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
