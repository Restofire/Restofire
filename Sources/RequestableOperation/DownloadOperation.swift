//
//  DownloadOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// An NSOperation that executes the `Downloadable` asynchronously.
public class DownloadOperation<R: Downloadable>: AOperation<R> {
    
    let downloadable: R
    let downloadRequest: () -> DownloadRequest
    let completionHandler: ((DownloadResponse<R.Response>) -> Void)?
    
    /// Intializes an download operation.
    ///
    /// - Parameters:
    ///   - downloadable: The `Downloadable`.
    ///   - request: The request closure.
    ///   - completionHandler: The async completion handler called
    ///     when the request is completed
    public init(downloadable: R, request: @escaping (() -> DownloadRequest), completionHandler: ((DownloadResponse<R.Response>) -> Void)?) {
        self.downloadable = downloadable
        self.downloadRequest = request
        self.completionHandler = completionHandler
        super.init(configurable: downloadable, request: request)
    }
    
    override func handleDownloadResponse(_ response: DefaultDownloadResponse) {
        let request = self.request as! DownloadRequest
        request.response(
            queue: downloadable.queue,
            responseSerializer: downloadable.responseSerializer
        ) { ( response: (DownloadResponse<R.Response>)) in
            self.completionHandler?(response)
            if let error = response.error {
                self.downloadable.request(self, didFailWithError: error)
                self.isFinished = true
            } else {
                self.downloadable.request(self, didCompleteWithValue: response.value!)
                self.isFinished = true
            }
        }
    }
    
    /// Creates a copy of self
    open override func copy() -> AOperation<R> {
        return DownloadOperation(
            downloadable: downloadable,
            request: downloadRequest,
            completionHandler: completionHandler
        )
    }
    
}
