//
//  Queueable.swift
//  Restofire
//
//  Created by Rahul Katariya on 15/04/16.
//  Copyright © 2016 Restofire. All rights reserved.
//

import Foundation

/// Represents a `Queueable` that is associated with `Requestable`.
public protocol Queueable {
    
    /// The `queues`.
    var queues: Queues { get }
    
    /// The request operation queue
    var requestQueue: OperationQueue { get }
    
    /// The download operation queue
    var downloadQueue: OperationQueue { get }
    
    /// The upload operation queue
    var uploadQueue: OperationQueue { get }
    
}

extension Queueable where Self: Configurable {
    
    /// `Queues.default`
    public var queues: Queues {
        return Queues.default
    }
    
    /// `Queues.default.requestQueue`
    public var requestQueue: OperationQueue {
        return queues.requestQueue
    }
    
    /// `Queues.default.downloadQueue`
    public var downloadQueue: OperationQueue {
        return queues.downloadQueue
    }
    
    /// `Queues.default.uploadQueue`
    public var uploadQueue: OperationQueue {
        return queues.uploadQueue
    }
    
}
