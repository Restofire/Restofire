//
//  BaseOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 30/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// An NSOperation base class for all request operations
open class AOperation<R: _Requestable>: Operation {
    
    let _requestable: R
    let requestClosure: () -> Request
    let downloadProgressHandler: ((Progress) -> Void)?
    let uploadProgressHandler: ((Progress) -> Void)?
    
    /// The underlying respect respective to requestable.
    public private(set) var request: Request!
    var retryAttempts = 0
    
    enum RequestType {
        case data
        case download
        case upload
        
        init(request: Request) {
            if let _ = request as? UploadRequest {
                self = .upload
            } else if let _ = request as? DownloadRequest {
                self = .download
            } else {
                self = .data
            }
        }
    }
    lazy var requestType: RequestType = {
        RequestType(request: request)
    }()
    
    #if !os(watchOS)
    lazy var reachability: NetworkReachability = {
        return NetworkReachability(configurable: _requestable)
    }()
    #endif
    
    public init(
        requestable: R,
        request: @escaping (() -> Request),
        downloadProgressHandler: ((Progress) -> Void)? = nil,
        uploadProgressHandler: ((Progress) -> Void)? = nil
    ) {
        self._requestable = requestable
        self.requestClosure = request
        self.retryAttempts = requestable.maxRetryAttempts
        self.downloadProgressHandler = downloadProgressHandler
        self.uploadProgressHandler = uploadProgressHandler
        super.init()
        self.isReady = true
    }
    
    /// Starts the request.
    override open func main() {
        if isCancelled { return }
        executeRequest()
    }
    
    /// Cancels the request.
    override open func cancel() {
        super.cancel()
        request.cancel()
    }
    
    @objc func executeRequest() {
        request = requestClosure()
        switch requestType {
        case .data, .upload:
            let request = self.request as! DataRequest
            request
                .downloadProgress(queue: _requestable.downloadProgressQueue) { [unowned self] progress in
                    self._requestable.didProgressDownload(request, requestable: self._requestable, progress: progress)
                    self.downloadProgressHandler?(progress)
                }
                .uploadProgress(queue: _requestable.uploadProgressQueue) { [unowned self] progress in
                    self._requestable.didProgressUpload(request, requestable: self._requestable, progress: progress)
                    self.uploadProgressHandler?(progress)
                }
                .response { [unowned self] in
                    if $0.error != nil {
                        self.handleDataRequestError($0)
                    } else {
                        self.handleDataResponseIfNeeded($0)
                    }
                }
        case .download:
            let request = self.request as! DownloadRequest
            request
                .downloadProgress(queue: _requestable.downloadProgressQueue) { [unowned self] progress in
                    self._requestable.didProgressDownload(request, requestable: self._requestable, progress: progress)
                    self.downloadProgressHandler?(progress)
                }
                .uploadProgress(queue: _requestable.uploadProgressQueue) { [unowned self] progress in
                    self._requestable.didProgressUpload(request, requestable: self._requestable, progress: progress)
                    self.uploadProgressHandler?(progress)
                }
                .response { [unowned self] in
                    if $0.error != nil {
                        self.handleDownloadRequestError($0)
                    } else {
                        self.handleDownloadResponseIfNeeded($0)
                    }
                }
        }
        request.logIfNeeded()
    }
    
    open func copy() -> AOperation {
        fatalError("override me")
    }
    
    func retry(afterDelay: TimeInterval = 0.0) {
        perform(
            #selector(AOperation<R>.executeRequest),
            with: nil,
            afterDelay: afterDelay
        )
    }
    
    // MARK:- Data Response
    func handleDataResponseIfNeeded(_ response: DataResponse<Data?>) {
        let response = dataResponseResult(response: response)
        if response.error != nil {
            handleDataResponse(response)
        } else if _requestable.shouldPoll(request, requestable: _requestable, response: response) {
            retry(afterDelay: _requestable.pollingInterval)
        } else {
            handleDataResponse(response)
        }
    }
    
    func handleDataResponse(_ response: DataResponse<R.Response>) {
        fatalError("override me")
    }
    
    func handleDataRequestError(_ response: DataResponse<Data?>) {
        if !handleRequestError(response.error!) {
            handleDataResponseIfNeeded(response)
        } else {
            isFinished = true
        }
    }
    
    func dataResponseResult(response: DataResponse<Data?>) -> DataResponse<R.Response> {
        fatalError("override me")
    }
    
    // MARK: - Download Response
    func handleDownloadResponseIfNeeded(_ response: DownloadResponse<URL?>) {
        let response = downloadResponseResult(response: response)
        if response.error != nil {
            handleDownloadResponse(response)
        } else if _requestable.shouldPoll(request, requestable: _requestable, response: response) {
            retry(afterDelay: _requestable.pollingInterval)
        } else {
            handleDownloadResponse(response)
        }
    }
    
    func handleDownloadResponse(_ response: DownloadResponse<R.Response>) {
        fatalError("override me")
    }
    
    func handleDownloadRequestError(_ response: DownloadResponse<URL?>) {
        if !handleRequestError(response.error!) {
            handleDownloadResponseIfNeeded(response)
        } else {
            isFinished = true
        }
    }
    
    func downloadResponseResult(response: DownloadResponse<URL?>) -> DownloadResponse<R.Response> {
        fatalError("override me")
    }
    
    // MARK: - Request Error
    func handleRequestError(_ error: Error) -> Bool {
        var handledError = true
        var isConnectivityError = false
        #if !os(watchOS)
            if let error = error as? URLError, _requestable.waitsForConnectivity &&
                error.code == .notConnectedToInternet {
                isConnectivityError = true
                _requestable.eventuallyOperationQueue.isSuspended = true
                let eventuallyOperation: AOperation = self.copy()
                reachability.setupListener()
                _requestable.eventuallyOperationQueue.addOperation(eventuallyOperation)
            }
        #endif
        if isConnectivityError {
           // No-op
        } else if let error = error as? URLError, retryAttempts > 0 &&
            _requestable.retryErrorCodes.contains(error.code) {
            retryAttempts -= 1
            retry(afterDelay: _requestable.retryInterval)
        } else {
            handledError = false
        }
        return handledError
    }
    
    // MARK: - KVO overrides
    var _ready: Bool = false
    /// A Boolean value indicating whether the operation can be performed now. (read-only)
    open override internal(set) var isReady: Bool {
        get {
            return _ready
        }
        set (newValue) {
            willChangeValue(forKey: "isReady")
            _ready = newValue
            didChangeValue(forKey: "isReady")
        }
    }
    
    var _executing: Bool = false
    /// A Boolean value indicating whether the operation is currently executing. (read-only)
    open override internal(set) var isExecuting: Bool {
        get {
            return _executing
        }
        set (newValue) {
            willChangeValue(forKey: "isExecuting")
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    var _cancelled: Bool = false
    /// A Boolean value indicating whether the operation has been cancelled. (read-only)
    open override internal(set) var isCancelled: Bool {
        get {
            return _cancelled
        }
        set (newValue) {
            willChangeValue(forKey: "isCancelled")
            _cancelled = newValue
            didChangeValue(forKey: "isCancelled")
        }
    }
    
    var _finished: Bool = false
    /// A Boolean value indicating whether the operation has finished executing its task. (read-only)
    open override internal(set) var isFinished: Bool {
        get {
            return _finished
        }
        set (newValue) {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    /// A boolean value `true` indicating the operation executes its task asynchronously.
    override open var isAsynchronous: Bool {
        return true
    }
    
}
