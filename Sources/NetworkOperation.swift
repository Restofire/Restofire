//
//  NetworkOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 10/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

class NetworkOperation: NSOperation {
    
    override var asynchronous: Bool {
        return true
    }
    
    private var _executing: Bool = false
    override var executing: Bool {
        get {
            return _executing
        }
        set {
            if (_executing != newValue) {
                self.willChangeValueForKey("isExecuting")
                _executing = newValue
                self.didChangeValueForKey("isExecuting")
            }
        }
    }
    
    private var _finished: Bool = false;
    override var finished: Bool {
        get {
            return _finished
        }
        set {
            if (_finished != newValue) {
                self.willChangeValueForKey("isFinished")
                _finished = newValue
                self.didChangeValueForKey("isFinished")
            }
        }
    }
    
    func completeOperation() {
        executing = false
        finished  = true
    }
    
    override func start() {
        if (cancelled) {
            finished = true
            return
        }
        
        executing = true
        
        main()
    }
    
}