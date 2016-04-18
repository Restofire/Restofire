//
//  RequestOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 16/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// RequestOperation represents an NSOperation object which executes the request
/// asynchronously on start
public class RequestOperation: NSOperation {
    
    /// The Alamofire Request.
    public let request: Alamofire.Request
    
    let taskRequest: Request
    let requestable: Requestable
    var completionHandler: (Response<AnyObject, NSError> -> Void)?
    var retry: Bool = false
    var attempts: Int = 0
    
    public init(requestable: Requestable, completionHandler: (Response<AnyObject, NSError> -> Void)? = nil) {
        self.requestable = requestable
        self.taskRequest = Request(requestable: requestable)
        self.completionHandler = completionHandler
        self.request = requestable.request
    }
    
    var _executing: Bool = false
    public override var executing: Bool {
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
    public override var cancelled: Bool {
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
    public override var finished: Bool {
        get {
            return _finished
        }
        set (newValue) {
            willChangeValueForKey("isFinished")
            _finished = newValue
            didChangeValueForKey("isFinished")
        }
    }
    public var successful = false
    public var failed = false
    public var pause = false {
        didSet {
            if pause {
                request.suspend()
            }
        }
    }
    
    public override func start() {
        if cancelled {
            finished = true
            return
        }
        executing = true
        executeRequest()
    }
    
    func executeRequest() {
        taskRequest.execute { (response: Response<AnyObject, NSError>) in
            if response.result.error == nil {
                self.successful = true
                self.executing = false
                self.finished = true
                if let completionHandler = self.completionHandler { completionHandler(response) }
            } else if self.retry && self.attempts > 0 {
                if response.result.error!.code == NSURLErrorNotConnectedToInternet {
                    self.pause = true
                } else if self.requestable.retryErrorCodes.contains(response.result.error!.code) {
                    self.attempts -= 1
                    print(self.attempts)
                    self.performSelector(#selector(RequestOperation.executeRequest), withObject: nil, afterDelay: self.requestable.retryInterval)
                }
            } else {
                self.failed = true
                self.executing = false
                self.finished = true
                if let completionHandler = self.completionHandler { completionHandler(response) }
            }
        }
    }
    
    public override func cancel() {
        taskRequest.request.cancel()
        executing = false
        cancelled = true
        finished = true
    }
    
}
