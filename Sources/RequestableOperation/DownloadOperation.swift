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
    let completionHandler: ((DownloadResponse<R.Response>) -> Void)?
    
    lazy var reachability: NetworkReachability = {
        return NetworkReachability(configurable: downloadable)
    }()
    
    var retryAttempts = 0
    
    /// The underlying Alamofire.DownloadRequest.
    public lazy var download: DownloadRequest = { return downloadable.request() }()
    
    /// A boolean value `true` indicating the operation executes its task asynchronously.
    override public var isAsynchronous: Bool {
        return true
    }
    
    init(downloadable: R, completionHandler: ((DownloadResponse<R.Response>) -> Void)?) {
        self.downloadable = downloadable
        self.retryAttempts = downloadable.maxRetryAttempts
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
        download.cancel()
    }
    
    @objc func executeDownload() {
        download.downloadProgress {
            self.downloadable.request(self.download, didDownloadProgress: $0)
        }
        download.response(
            queue: downloadable.queue,
            responseSerializer: downloadable.responseSerializer
        ) { (response: DownloadResponse<R.Response>) in
            if response.error == nil {
                if let completionHandler = self.completionHandler {
                    completionHandler(response)
                }
                self.downloadable.request(self.download, didCompleteWithValue: response.value!)
                self.isFinished = true
            } else {
                self.handleErrorDownloadResponse(response)
            }
        }
    }
    
    func handleErrorDownloadResponse(_ response: DownloadResponse<R.Response>) {
        if let error = response.error as? URLError {
            if downloadable.eventually && error.code == .notConnectedToInternet {
                downloadable.eventuallyOperationQueue.isSuspended = true
                let eventuallyOperation = DownloadOperation(
                    downloadable: downloadable,
                    completionHandler: completionHandler
                )
                reachability.addOperation(operation: eventuallyOperation)
                isFinished = true
            } else if retryAttempts > 0 && downloadable.retryErrorCodes.contains(error.code) {
                retryAttempts -= 1
                perform(
                    #selector(DownloadOperation<R>.executeDownload),
                    with: nil,
                    afterDelay: downloadable.retryInterval
                )
            } else {
                downloadable.request(download, didFailWithError: response.error!)
                completionHandler?(response)
                isFinished = true
            }
        } else {
            downloadable.request(download, didFailWithError: response.error!)
            completionHandler?(response)
            isFinished = true
        }
    }
    
}

