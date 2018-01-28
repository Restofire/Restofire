//
//  RequestableOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// An NSOperation that executes the `Requestable` asynchronously on `start()`
/// or when added to a NSOperationQueue
///
/// - Note: Auto Retry is available only in `DataRequestEventuallyOperation`.
open class RequestableOperation<R: Requestable>: BaseOperation {
    
    let requestable: R
    var request: DataRequest!
    var retryAttempts = 0
    let completionHandler: ((DefaultDataResponse) -> Void)?
    
    init(requestable: R, completionHandler: ((DefaultDataResponse) -> Void)?) {
        self.requestable = requestable
        self.retryAttempts = requestable.maxRetryAttempts
        self.completionHandler = completionHandler
        super.init()
    }
    
    /// Begins the execution of the operation.
    open override func start() {
        super.start()
        executeRequest()
    }
    
    @objc func executeRequest() {
        request = requestable.request()
        requestable.didStart(request: request)
        request.response(queue: requestable.queue) { [weak self] (response: DefaultDataResponse) in
            guard let _self = self else { return }
            if response.error == nil {
                _self.successful = true
                _self.requestable.didComplete(request: _self.request, with: response)
                if let completionHandler = _self.completionHandler { completionHandler(response) }
            } else {
                _self.handleErrorDataResponse(response)
            }
            let debug = ProcessInfo.processInfo.environment["-me.rahulkatariya.Restofire.Debug"]
            if debug == "1" {
                print(_self.request.debugDescription)
            } else if debug == "2" {
                print(_self.request.debugDescription)
                print(response)
            } else if debug == "3" {
                print(_self.request.debugDescription)
                print(_self.request)
                print(response)
            }
        }
    }
    
    func handleErrorDataResponse(_ response: DefaultDataResponse) {
        if let error = response.error as? URLError, retryAttempts > 0,
            requestable.retryErrorCodes.contains(error.code) {
            
                retryAttempts -= 1
                perform(#selector(RequestableOperation<R>.executeRequest), with: nil, afterDelay: requestable.retryInterval)
            
        } else {
            failed = true
            requestable.didComplete(request: request, with: response)
            completionHandler?(response)
        }
    }
    
    /// Advises the operation object that it should stop executing its request.
    open override func cancel() {
        super.cancel()
        request.cancel()
    }
    
}
