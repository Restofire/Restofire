//
//  DownloadOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// An NSOperation that executes the `Downloadable` asynchronously
/// or when added to a NSOperationQueue
public class DownloadOperation<R: Downloadable>: BaseOperation {
    
    let downloadable: R
    var retryAttempts = 0
    
    /// The underlying Alamofire.DownloadRequest.
    public let request: DownloadRequest
    let completionHandler: ((DownloadResponse<R.Response>) -> Void)?
    
    #if !os(watchOS)
    lazy var reachability: NetworkReachability = {
        return NetworkReachability(configurable: downloadable)
    }()
    #endif
    
    /// A boolean value `true` indicating the operation executes its task asynchronously.
    override public var isAsynchronous: Bool {
        return true
    }
    
    init(downloadable: R, request: DownloadRequest, completionHandler: ((DownloadResponse<R.Response>) -> Void)?) {
        self.downloadable = downloadable
        self.retryAttempts = downloadable.maxRetryAttempts
        self.request = request
        self.completionHandler = completionHandler
        super.init()
        self.isReady = true
    }
    
    /// Starts the download.
    override public func main() {
        if isCancelled { return }
        executeDownload()
    }
    
    /// Cancels the download.
    override public func cancel() {
        super.cancel()
        request.cancel()
    }
    
    @objc func executeDownload() {
        request.downloadProgress {
            self.downloadable.request(self.request, didDownloadProgress: $0)
        }
        request.response(
            queue: downloadable.queue,
            responseSerializer: downloadable.responseSerializer
        ) { (response: DownloadResponse<R.Response>) in
            if response.error == nil {
                if let completionHandler = self.completionHandler {
                    completionHandler(response)
                }
                self.downloadable.request(self.request, didCompleteWithValue: response.value!)
                self.isFinished = true
            } else {
                self.handleErrorDownloadResponse(response)
            }
        }
        request.logIfNeeded()
    }
    
    func handleErrorDownloadResponse(_ response: DownloadResponse<R.Response>) {
        if let error = response.error as? URLError {
            if downloadable.waitsForConnectivity && error.code == .notConnectedToInternet {
                #if !os(watchOS)
                    downloadable.eventuallyOperationQueue.isSuspended = true
                    let eventuallyOperation = DownloadOperation(
                        downloadable: downloadable,
                        request: request,
                        completionHandler: completionHandler
                    )
                    reachability.addOperation(operation: eventuallyOperation)
                    isFinished = true
                #else
                    downloadable.request(request, didFailWithError: response.error!)
                    completionHandler?(response)
                    isFinished = true
                #endif
            } else if retryAttempts > 0 && downloadable.retryErrorCodes.contains(error.code) {
                retryAttempts -= 1
                perform(
                    #selector(DownloadOperation<R>.executeDownload),
                    with: nil,
                    afterDelay: downloadable.retryInterval
                )
            } else {
                downloadable.request(request, didFailWithError: response.error!)
                completionHandler?(response)
                isFinished = true
            }
        } else {
            downloadable.request(request, didFailWithError: response.error!)
            completionHandler?(response)
            isFinished = true
        }
    }
    
}

