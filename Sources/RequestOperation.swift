//
//  RequestOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 18/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// RequestOperation represents an NSOperation object which executes
/// asynchronously.
public class RequestOperation: NSOperation {
    
    var request: Alamofire.Request!
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
    
    /// Begins the execution of the HTTP operation.
    public override func start() {
        if cancelled {
            finished = true
            return
        }
        executing = true
        startRequest()
    }
    
    func startRequest() {
        request = alamofireRequest()
        authenticateRequest(request, usingCredential: requestable.credential)
        validateRequest(request, forAcceptableContentTypes: requestable.acceptableContentTypes)
        validateRequest(request, forAcceptableStatusCodes: requestable.acceptableStatusCodes)
        validateRequest(request, forValidation: requestable.validation)
        executeRequest()
    }
    
    func executeRequest() {
        request.response(rootKeyPath: requestable.rootKeyPath) { (response: Response<AnyObject, NSError>) in
            if response.result.error == nil {
                self.successful = true
                if let completionHandler = self.completionHandler { completionHandler(response) }
            } else {
                self.failed = true
                if let completionHandler = self.completionHandler { completionHandler(response) }
            }
            if self.requestable.logging { debugPrint(response) }
        }
    }
    
    /// Advises the HTTP operation object that it should stop executing its request.
    public override func cancel() {
        request.cancel()
        executing = false
        cancelled = true
        finished = true
    }
    
}

// MARK: - Alamofire Request
extension RequestOperation {
    
    private func alamofireRequest() -> Alamofire.Request {
        
        var request = requestable.manager.request(requestable.method, requestable.baseURL + requestable.path, parameters: requestable.parameters as? [String: AnyObject], encoding: requestable.encoding, headers: requestable.headers)
        
        if let parameters = requestable.parameters as? [AnyObject] {
            let (encodedURLRequest, error) = encodeURLRequest(request.request!, parameters: parameters, encoding: requestable.encoding)
            if let error = error {
                print("[Restofire] - Encoding Error: " + error.localizedDescription)
            } else {
                request = Alamofire.request(encodedURLRequest)
            }
        }
        
        return request
        
    }
    
    private func encodeURLRequest(URLRequest: URLRequestConvertible, parameters: [AnyObject]?, encoding: ParameterEncoding) -> (NSMutableURLRequest, NSError?) {
        let mutableURLRequest = URLRequest.URLRequest
        
        guard let parameters = parameters where !parameters.isEmpty else {
            return (mutableURLRequest, nil)
        }
        
        var encodingError: NSError? = nil
        
        switch encoding {
        case .JSON:
            do {
                let options = NSJSONWritingOptions()
                let data = try NSJSONSerialization.dataWithJSONObject(parameters, options: options)
                
                mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                mutableURLRequest.HTTPBody = data
            } catch {
                encodingError = error as NSError
            }
        case .PropertyList(let format, let options):
            do {
                let data = try NSPropertyListSerialization.dataWithPropertyList(
                    parameters,
                    format: format,
                    options: options
                )
                mutableURLRequest.setValue("application/x-plist", forHTTPHeaderField: "Content-Type")
                mutableURLRequest.HTTPBody = data
            } catch {
                encodingError = error as NSError
            }
        default:
            encodingError = NSError(domain: "com.rahulkatariya.Restofire", code: -1, userInfo: [NSLocalizedDescriptionKey: "parameters as array are only implemented in .JSON and .Propertylist parameter encoding. If you think it is an issue, please create one or send a pull request if you can solve it at http://github.com/Restofire/Restofire."])
            break
        }
        
        return (mutableURLRequest, encodingError)
    }
    
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
