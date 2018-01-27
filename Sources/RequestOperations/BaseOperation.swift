//
//  BaseOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

open class BaseOperation: Operation {
    
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
            }
        }
    }
    
    var resume = false {
        didSet {
            if resume {
                pause = false
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
    }
    
    /// Advises the operation object that it should stop executing its request.
    open override func cancel() {
        isExecuting = false
        isCancelled = true
        isFinished = true
    }
    
}
