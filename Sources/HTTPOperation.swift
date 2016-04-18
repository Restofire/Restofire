//
//  Operation.swift
//  Restofire
//
//  Created by Rahul Katariya on 18/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

public class HTTPOperation: NSOperation {

    var request: Alamofire.Request!
    let requestable: Requestable
    let completionHandler: (Response<AnyObject, NSError> -> Void)?
    
    init(requestable: Requestable, completionHandler: (Response<AnyObject, NSError> -> Void)?) {
        self.requestable = requestable
        self.completionHandler = completionHandler
    }
    
    public var successful = false {
        didSet {
            if successful {
                executing = false
                finished = true
            }
        }
    }
    
    public var failed = false {
        didSet {
            if failed {
                executing = false
                finished = true
            }
        }
    }
    
    public var pause = false {
        didSet {
            if pause {
                resume = false
                request.suspend()
            }
        }
    }
    
    public var resume = false {
        didSet {
            if resume {
                pause = false
                startRequest()
            }
        }
    }

    var _ready: Bool = false
    public override var ready: Bool {
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
    
    /// Begins the execution of the operation.
    public override func start() {
        if cancelled {
            finished = true
            return
        }
        executing = true
        startRequest()
    }
    
    func startRequest() {
        request = requestable.request
        authenticateRequest(request, usingCredential: requestable.credential)
        validateRequest(request, forAcceptableContentTypes: requestable.acceptableContentTypes)
        validateRequest(request, forAcceptableStatusCodes: requestable.acceptableStatusCodes)
        validateRequest(request, forValidation: requestable.validation)
        executeRequest()
    }
    
    func executeRequest() {
        fatalError("Abstract Method: Implemented in SubClasses")
    }
    
    public override func cancel() {
        request.cancel()
        executing = false
        cancelled = true
        finished = true
    }
    
}

// MARK: - Request Authentication and Validation
extension HTTPOperation {
    
    private func authenticateRequest(request: Alamofire.Request, usingCredential credential:NSURLCredential?) {
        guard let credential = credential else { return }
        request.authenticate(usingCredential: credential)
    }
    
    private func validateRequest(request: Alamofire.Request, forAcceptableContentTypes contentTypes:[String]?) {
        guard let contentTypes = contentTypes else { return }
        request.validate(contentType: contentTypes)
    }
    
    private func validateRequest(request: Alamofire.Request, forAcceptableStatusCodes statusCodes:[Range<Int>]?) {
        guard let statusCodes = statusCodes else { return }
        for statusCode in statusCodes {
            request.validate(statusCode: statusCode)
        }
    }
    
    private func validateRequest(request: Alamofire.Request, forValidation validation:Alamofire.Request.Validation?) {
        guard let validation = validation else { return }
        request.validate(validation)
    }
    
}
