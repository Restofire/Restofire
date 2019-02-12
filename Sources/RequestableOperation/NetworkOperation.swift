//
//  BaseOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 30/01/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation

/// An NSOperation base class for all request operations
open class NetworkOperation<R: BaseRequestable>: Operation, Cancellable {
    
    let baseRequestable: R
    let requestClosure: () -> Request
    let downloadProgressHandler: (((Progress) -> Void), queue: DispatchQueue?)?
    let uploadProgressHandler: (((Progress) -> Void), queue: DispatchQueue?)?
    
    /// The underlying respect respective to requestable.
    public private(set) var request: Request?
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
            } else if let _ = request as? DataRequest {
                self = .data
            } else {
                fatalError("Unsupported request type.")
            }
        }
    }
    
    #if !os(watchOS)
    lazy var reachability: NetworkReachability = {
        return NetworkReachability(configurable: baseRequestable)
    }()
    #endif
    
    init(
        requestable: R,
        request: @escaping (() -> Request),
        downloadProgressHandler: (((Progress) -> Void), queue: DispatchQueue?)? = nil,
        uploadProgressHandler: (((Progress) -> Void), queue: DispatchQueue?)? = nil
    ) {
        self.baseRequestable = requestable
        self.requestClosure = request
        self.retryAttempts = requestable.maxRetryAttempts
        self.downloadProgressHandler = downloadProgressHandler
        self.uploadProgressHandler = uploadProgressHandler
        super.init()
        self.name = "NetworkOperation<\(R.self)>"
        self.isReady = true
        self.qualityOfService = requestable.qos
        self.queuePriority = requestable.priority
    }
    
    /// Starts the request.
    override open func main() {
        guard !isCancelled else { return }
        executeRequest()
    }
    
    /// Cancels the request.
    override open func cancel() {
        guard !isCancelled else { return }
        super.cancel()
        request?.cancel()
    }
    
    @objc func executeRequest() {
        guard !isCancelled else { return }
        request = requestClosure()
        let requestType = RequestType(request: request!)
        switch requestType {
        case .data:
            let request = self.request as! DataRequest
            request
                .downloadProgress(queue: downloadProgressHandler?.1 ?? .main) { [unowned self] progress in
                    self.downloadProgressHandler?.0(progress)
                }
                .response { [unowned self] in
                    if $0.error != nil {
                        self.handleDataRequestError($0)
                    } else {
                        self.handleDataResponseIfNeeded($0)
                    }
                    request.logDataRequestIfNeeded(result: $0)
                }
        case .download:
            let request = self.request as! DownloadRequest
            request
                .downloadProgress(queue: downloadProgressHandler?.1 ?? .main) { [unowned self] progress in
                    self.downloadProgressHandler?.0(progress)
                }
                .response { [unowned self] in
                    if $0.error != nil {
                        self.handleDownloadRequestError($0)
                    } else {
                        self.handleDownloadResponseIfNeeded($0)
                    }
                    request.logDownloadRequestIfNeeded(result: $0)
                }
        case .upload:
            let request = self.request as! DataRequest
            request
                .uploadProgress(queue: uploadProgressHandler?.1 ?? .main) { [unowned self] progress in
                    self.uploadProgressHandler?.0(progress)
                }
                .response { [unowned self] in
                    if $0.error != nil {
                        self.handleDataRequestError($0)
                    } else {
                        self.handleDataResponseIfNeeded($0)
                    }
                    request.logDataRequestIfNeeded(result: $0)
            }
        }
        request?.logRequestIfNeeded()
    }
    
    open func copy() -> NetworkOperation {
        fatalError("override me")
    }
    
    func retry(afterDelay: TimeInterval = 0.0) {
        perform(
            #selector(NetworkOperation<R>.executeRequest),
            with: nil,
            afterDelay: afterDelay
        )
    }
    
    // MARK:- Data Response
    func handleDataResponseIfNeeded(_ response: DataResponse<Data?>) {
        guard let request = request else { fatalError("Request should not be nil"); }
        let response = dataResponseResult(response: response)
        if baseRequestable.shouldPoll(request, requestable: baseRequestable, response: response) {
            retry(afterDelay: baseRequestable.pollingInterval)
        } else {
            handleDataResponse(response)
        }
    }
    
    func handleDataResponse(_ response: DataResponse<R.Response>) {
        fatalError("override me")
    }
    
    func handleDataRequestError(_ response: DataResponse<Data?>) {
        guard let error = response.error else { fatalError("Error should not be nil"); }
        if handleRequestError(error) {
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
        guard let request = request else { fatalError("Request should not be nil"); }
        let response = downloadResponseResult(response: response)
        if baseRequestable.shouldPoll(request, requestable: baseRequestable, response: response) {
            retry(afterDelay: baseRequestable.pollingInterval)
        } else {
            handleDownloadResponse(response)
        }
    }
    
    func handleDownloadResponse(_ response: DownloadResponse<R.Response>) {
        fatalError("override me")
    }
    
    func handleDownloadRequestError(_ response: DownloadResponse<URL?>) {
        guard let error = response.error else { fatalError("Error should not be nil"); }
        if handleRequestError(error) {
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
        var handledError = false
        var isConnectivityError = false
        #if !os(watchOS)
            if let error = error as? URLError, baseRequestable.waitsForConnectivity &&
                error.code == .notConnectedToInternet {
                isConnectivityError = true
                baseRequestable.eventuallyOperationQueue.isSuspended = true
                let eventuallyOperation: NetworkOperation = self.copy()
                reachability.setupListener()
                baseRequestable.eventuallyOperationQueue.addOperation(eventuallyOperation)
                handledError = true
            }
        #endif
        if let error = error as? URLError, !isConnectivityError {
            if retryAttempts > 0 && baseRequestable.retryErrorCodes.contains(error.code) {
                retryAttempts -= 1
                retry(afterDelay: baseRequestable.retryInterval)
            } else {
                handledError = true
            }
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
