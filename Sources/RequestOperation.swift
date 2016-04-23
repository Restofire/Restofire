//
//  RequestOperation.swift
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
/// - Note: Auto Retry is available only in `RequestEventuallyOperation`.
public class RequestOperation: NSOperation {
    
    var request: Request!
    let requestable: Requestable
    let completionHandler: (Response<AnyObject, NSError> -> Void)?
    var retryAttempts = 0
    
    init(requestable: Requestable, completionHandler: (Response<AnyObject, NSError> -> Void)?) {
        self.requestable = requestable
        retryAttempts = requestable.maxRetryAttempts
        self.completionHandler = completionHandler
        super.init()
        _ready = super.ready
    }
    
    var successful = false {
        didSet {
            if successful {
                executing = false
                finished = true
            }
        }
    }
    
    var failed = false {
        didSet {
            if failed {
                executing = false
                finished = true
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
    public override internal(set) var ready: Bool {
        get {
            return _ready
        }
        set (newValue) {
            willChangeValueForKey("isReady")
            _ready = newValue
            didChangeValueForKey("isReady")
        }
    }
    
    var _executing: Bool = false
    
    /// A Boolean value indicating whether the operation is currently executing. (read-only)
    public override private(set) var executing: Bool {
        get {
            return _executing
        }
        set (newValue) {
            willChangeValueForKey("isExecuting")
            _executing = newValue
            didChangeValueForKey("isExecuting")
        }
    }
    
    var _cancelled: Bool = false
    /// A Boolean value indicating whether the operation has been cancelled. (read-only)
    public override private(set) var cancelled: Bool {
        get {
            return _cancelled
        }
        set (newValue) {
            willChangeValueForKey("isCancelled")
            _cancelled = newValue
            didChangeValueForKey("isCancelled")
        }
    }
    
    var _finished: Bool = false
    /// A Boolean value indicating whether the operation has finished executing its task. (read-only)
    public override private(set) var finished: Bool {
        get {
            return _finished
        }
        set (newValue) {
            willChangeValueForKey("isFinished")
            _finished = newValue
            didChangeValueForKey("isFinished")
        }
    }
    
    /// Begins the execution of the operation.
    public override func start() {
        if cancelled {
            finished = true
            return
        }
        executing = true
        executeRequest()
    }
    
    func executeRequest() {
        request = AlamofireUtils.alamofireRequestFromRequestable(requestable)
        request.responseJSON(queue: requestable.queue) { (response: Response<AnyObject, NSError>) in
            if response.result.error == nil {
                self.successful = true
                if let completionHandler = self.completionHandler { completionHandler(response) }
            } else {
                self.handleErrorResponse(response)
            }
            if self.requestable.logging { debugPrint(self.request) }
        }
        
    }
    
    func handleErrorResponse(response: Response<AnyObject, NSError>) {
        self.failed = true
        if let completionHandler = self.completionHandler { completionHandler(response) }
    }
    
    /// Advises the operation object that it should stop executing its request.
    public override func cancel() {
        request.cancel()
        executing = false
        cancelled = true
        finished = true
    }
    
}
