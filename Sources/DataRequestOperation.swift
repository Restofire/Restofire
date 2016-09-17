//
//  DataRequestOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 18/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// An NSOperation that executes the `Requestable` asynchronously on `start()`
/// or when added to a NSOperationQueue
///
/// - Note: Auto Retry is available only in `DataRequestEventuallyOperation`.
open class DataRequestOperation<R: Requestable>: Operation {
    
    var request: Alamofire.DataRequest!
    let requestable: R
    let completionHandler: ((Alamofire.DataResponse<Any>) -> Void)?
    var retryAttempts = 0
    
    init(requestable: R, completionHandler: ((Alamofire.DataResponse<Any>) -> Void)?) {
        self.requestable = requestable
        retryAttempts = requestable.maxRetryAttempts
        self.completionHandler = completionHandler
        super.init()
        _ready = super.isReady
    }
    
    var successful = false {
        didSet {
            if successful {
                isExecuting = false
                isFinished = true
            }
        }
    }
    
    var failed = false {
        didSet {
            if failed {
                isExecuting = false
                isFinished = true
            }
        }
    }
    
    var pause = false {
        didSet {
            if pause {
                resume = false
                request.suspend()
            }
        }
    }
    
    var resume = false {
        didSet {
            if resume {
                pause = false
                executeRequest()
            }
        }
    }
    
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
    open override fileprivate(set) var isExecuting: Bool {
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
    open override fileprivate(set) var isCancelled: Bool {
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
    open override fileprivate(set) var isFinished: Bool {
        get {
            return _finished
        }
        set (newValue) {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    /// Begins the execution of the operation.
    open override func start() {
        if isCancelled {
            isFinished = true
            return
        }
        isExecuting = true
        requestable.didStartRequest()
        executeRequest()
    }
    
    func executeRequest() {
        request = AlamofireUtils.alamofireRequestFromRequestable(requestable)
        request.restofireResponse(queue: requestable.queue, responseSerializer: requestable.responseSerializer) { (response: Alamofire.DataResponse<Any>) in
            if response.result.error == nil {
                self.successful = true
                self.requestable.didCompleteRequestWithResponse(response)
                if let completionHandler = self.completionHandler { completionHandler(response) }
            } else {
                self.handleErrorResponse(response)
            }
            if self.requestable.logging {
                debugPrint(self.request)
                debugPrint(response)
            }
        }
    }
    
    func handleErrorResponse(_ response: Alamofire.DataResponse<Any>) {
        self.failed = true
        self.requestable.didCompleteRequestWithResponse(response)
        if let completionHandler = self.completionHandler { completionHandler(response) }
    }
    
    /// Advises the operation object that it should stop executing its request.
    open override func cancel() {
        request.cancel()
        isExecuting = false
        isCancelled = true
        isFinished = true
    }
    
}
