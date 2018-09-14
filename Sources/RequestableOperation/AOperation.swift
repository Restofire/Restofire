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
open class AOperation<R: Configurable>: Operation {
    
    var configurable: R
    var requestClosure: () -> Request
    
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
        return NetworkReachability(configurable: configurable)
    }()
    #endif
    
    public init(configurable: R, request: @escaping (() -> Request)) {
        self.configurable = configurable
        self.requestClosure = request
        self.retryAttempts = configurable.maxRetryAttempts
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
            request.response {
                if $0.error != nil {
                    self.handleDataRequestError($0)
                } else {
                    self.handleDataResponse($0)
                }
            }
        case .download:
            let request = self.request as! DownloadRequest
            request.response {
                if $0.error != nil {
                    self.handleDownloadRequestError($0)
                } else {
                    self.handleDownloadResponse($0)
                }
            }
        }
        request.logIfNeeded()
    }
    
    open func copy() -> AOperation {
        fatalError("override me")
    }
    
    // MARK:- Data Response
    func handleDataResponse(_ response: DataResponse<Data?>) {
        fatalError("override me")
    }
    
    func handleDataRequestError(_ response: DataResponse<Data?>) {
        if !handleRequestError(response.error!) {
            handleDataResponse(response)
        } else {
            isFinished = true
        }
    }
    
    // MARK: - Download Response
    func handleDownloadResponse(_ response: DownloadResponse<URL?>) {
        fatalError("override me")
    }
    
    func handleDownloadRequestError(_ response: DownloadResponse<URL?>) {
        if !handleRequestError(response.error!) {
            handleDownloadResponse(response)
        } else {
            isFinished = true
        }
    }
    
    // MARK: - Request Error
    func handleRequestError(_ error: Error) -> Bool {
        var handledError = true
        var isConnectivityError = false
        #if !os(watchOS)
            if let error = error as? URLError, configurable.waitsForConnectivity &&
                error.code == .notConnectedToInternet
            {
                isConnectivityError = true
                configurable.eventuallyOperationQueue.isSuspended = true
                let eventuallyOperation: AOperation = self.copy()
                reachability.setupListener()
                configurable.eventuallyOperationQueue.addOperation(eventuallyOperation)
            }
        #endif
        if isConnectivityError {
           // No-op
        } else if let error = error as? URLError, retryAttempts > 0 &&
            configurable.retryErrorCodes.contains(error.code) {
            retryAttempts -= 1
            perform(
                #selector(AOperation<R>.executeRequest),
                with: nil,
                afterDelay: configurable.retryInterval
            )
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
