//
//  DataRequestOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 18/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// An NSOperation that executes the `RequestableBase` asynchronously on `start()`
/// or when added to a NSOperationQueue
///
/// - Note: Auto Retry is available only in `DataRequestEventuallyOperation`.
open class DataRequestOperation<R: Requestable>: BaseOperation {
    
    var request: DataRequest!
    let requestable: R
    let completionHandler: ((DefaultDataResponse) -> Void)?
    var retryAttempts = 0
    
    init(requestable: R, completionHandler: ((DefaultDataResponse) -> Void)?) {
        self.requestable = requestable
        retryAttempts = requestable.maxRetryAttempts
        self.completionHandler = completionHandler
        super.init()
        _ready = super.isReady
    }
    
    override var pause: Bool {
        didSet {
            request.suspend()
        }
    }
    
    override var resume: Bool {
        didSet {
            executeRequest()
        }
    }
    
    /// Begins the execution of the operation.
    open override func start() {
        super.start()
        executeRequest()
    }
    
    /// Advises the operation object that it should stop executing its request.
    open override func cancel() {
        super.cancel()
        request.cancel()
    }
    
    @objc func executeRequest() {
        request = Restofire.dataRequest(fromRequestable: requestable)
        request.response(queue: requestable.queue) { (response: DefaultDataResponse) in
            if response.error == nil {
                self.successful = true
                if let completionHandler = self.completionHandler { completionHandler(response) }
            } else {
                self.handleErrorDataResponse(response)
            }
            let debug = ProcessInfo.processInfo.environment["-me.rahulkatariya.Restofire.Debug"]
            if debug == "1" {
                print(self.request.debugDescription)
            } else if debug == "2" {
                print(self.request)
                print(self.request.debugDescription)
            } else if debug == "3" {
                print(self.request)
                print(self.request.debugDescription)
                print(response)
            }
        }
    }
    
    func handleErrorDataResponse(_ response: DefaultDataResponse) {
        self.failed = true
        if let completionHandler = self.completionHandler { completionHandler(response) }
    }
}
