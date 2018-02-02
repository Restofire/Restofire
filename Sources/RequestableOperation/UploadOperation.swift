//
//  UploadOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// An NSOperation that executes the `Uploadable` asynchronously
/// or when added to a NSOperationQueue
public class UploadOperation<R: Uploadable>: BaseOperation {
    
    let uploadable: R
    var retryAttempts = 0
    
    /// The underlying Alamofire.UploadRequest.
    public let request: UploadRequest
    let completionHandler: ((DataResponse<R.Response>) -> Void)?
    
    #if !os(watchOS)
    lazy var reachability: NetworkReachability = {
        return NetworkReachability(configurable: uploadable)
    }()
    #endif
    
    /// A boolean value `true` indicating the operation executes its task asynchronously.
    override public var isAsynchronous: Bool {
        return true
    }
    
    init(uploadable: R, request: UploadRequest, completionHandler: ((DataResponse<R.Response>) -> Void)?) {
        self.uploadable = uploadable
        self.retryAttempts = uploadable.maxRetryAttempts
        self.request = request
        self.completionHandler = completionHandler
        super.init()
        self.isReady = true
    }
    
    /// Starts the download.
    override public func main() {
        if isCancelled { return }
        executeUpload()
    }
    
    /// Cancels the download.
    override public func cancel() {
        super.cancel()
        request.cancel()
    }
    
    @objc func executeUpload() {
        request.downloadProgress {
            self.uploadable.request(self.request, didDownloadProgress: $0)
        }
        request.uploadProgress {
            self.uploadable.request(self.request, didUploadProgress: $0)
        }
        request.response(
            queue: uploadable.queue,
            responseSerializer: uploadable.responseSerializer
        ) { (response: DataResponse<R.Response>) in
            if response.error == nil {
                if let completionHandler = self.completionHandler {
                    completionHandler(response)
                }
                self.uploadable.request(self.request, didCompleteWithValue: response.value!)
                self.isFinished = true
            } else {
                self.handleErrorDownloadResponse(response)
            }
        }
        request.logIfNeeded()
    }
    
    func handleErrorDownloadResponse(_ response: DataResponse<R.Response>) {
        if let error = response.error as? URLError {
            if uploadable.waitsForConnectivity && error.code == .notConnectedToInternet {
                #if !os(watchOS)
                    uploadable.eventuallyOperationQueue.isSuspended = true
                    let eventuallyOperation = UploadOperation(
                        uploadable: uploadable,
                        request: request,
                        completionHandler: completionHandler
                    )
                    reachability.addOperation(operation: eventuallyOperation)
                    isFinished = true
                #else
                    uploadable.request(request, didFailWithError: response.error!)
                    completionHandler?(response)
                    isFinished = true
                #endif
            } else if retryAttempts > 0 && uploadable.retryErrorCodes.contains(error.code) {
                retryAttempts -= 1
                perform(
                    #selector(UploadOperation<R>.executeUpload),
                    with: nil,
                    afterDelay: uploadable.retryInterval
                )
            } else {
                uploadable.request(request, didFailWithError: response.error!)
                completionHandler?(response)
                isFinished = true
            }
        } else {
            uploadable.request(request, didFailWithError: response.error!)
            completionHandler?(response)
            isFinished = true
        }
    }
    
}
