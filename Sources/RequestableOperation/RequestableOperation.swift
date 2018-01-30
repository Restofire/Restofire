//
//  RequestableOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// An NSOperation that executes the `Requestable` asynchronously on `start()`
/// or when added to a NSOperationQueue
///
/// - Note: Auto Retry is available only in `DataRequestEventuallyOperation`.
open class RequestableOperation<R: Requestable>: BaseOperation {

    let requestable: R
    let completionHandler: ((DataResponse<R.Response>) -> Void)?
    
    lazy var request: DataRequest = { return self.requestable.request() }()
    var retryAttempts = 0
    
    init(requestable: R, completionHandler: ((DataResponse<R.Response>) -> Void)?) {
        self.requestable = requestable
        self.retryAttempts = requestable.maxRetryAttempts
        self.completionHandler = completionHandler
        super.init()
    }
    
    /// Starts the request.
    open override func start() {
        super.start()
        executeRequest()
    }
    
    /// Suspends the request.
    public func suspend() {
        request.suspend()
    }
    
    /// Resumes the request.
    public func resume() {
        request.resume()
    }
    
    /// Cancels the request.
    open override func cancel() {
        super.cancel()
        request.cancel()
    }
    
    @objc func executeRequest() {
        request.downloadProgress {
            self.requestable.request(self.request, didDownloadProgress: $0)
        }
        request.response(
            queue: requestable.queue,
            responseSerializer: requestable.responseSerializer
        ) { (response: DataResponse<R.Response>) in
            if response.error == nil {
                self._successful = true
                if let completionHandler = self.completionHandler { completionHandler(response) }
                self.requestable.request(self.request, didCompleteWithValue: response.value!)
            } else {
                self.handleErrorDataResponse(response)
            }
        }
        request.logIfNeeded()
    }
    
    func handleErrorDataResponse(_ response: DataResponse<R.Response>) {
        if let error = response.error as? URLError, retryAttempts > 0,
            requestable.retryErrorCodes.contains(error.code) {
                retryAttempts -= 1
                perform(#selector(RequestableOperation<R>.executeRequest), with: nil, afterDelay: requestable.retryInterval)
        } else {
            _failed = true
            requestable.request(request, didFailWithError: response.error!)
            completionHandler?(response)
        }
    }
    
}
