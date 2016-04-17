//
//  RequestOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 16/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

public class RequestOperation: NSOperation {
    
    let _request: Request
    var completionHandler: (Response<AnyObject, NSError> -> Void)?
    
    /// The Alamofire Request.
    public let request: Alamofire.Request
    
    public init(requestable: Requestable, completionHandler: (Response<AnyObject, NSError> -> Void)? = nil) {
        self._request = Request(requestable: requestable)
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
    
    public override func start() {
        if cancelled {
            finished = true
            return
        }
        executing = true
        _request.executeTask { (response: Response<AnyObject, NSError>) in
            self.finished = true
            self.executing = false
            if let completionHandler = self.completionHandler { completionHandler(response) }
        }
    }
    
    public override func cancel() {
        _request.request.cancel()
        executing = false
        cancelled = true
        finished = true
    }
    
}
