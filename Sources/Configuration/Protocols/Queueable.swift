//
//  Queueable.swift
//  Restofire
//
//  Created by Rahul Katariya on 15/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// Represents a `Queueable` that is associated with `Requestable`.
public protocol Queueable {
    
    /// The `queue`.
    var callbackQueue: DispatchQueue { get }
    
    /// The request operation queue
    var requestQueue: OperationQueue { get }
    
    /// The download operation queue
    var downloadQueue: OperationQueue { get }
    
    /// The upload operation queue
    var uploadQueue: OperationQueue { get }
    
}

public extension Queueable where Self: Configurable {
    
    /// `DispatchQueue.main`
    public var callbackQueue: DispatchQueue {
        return DispatchQueue.main
    }
    
    /// `configuration.requestQueue`
    public var requestQueue: OperationQueue {
        return configuration.operationQueue
    }
    
    /// `configuration.downloadQueue`
    public var downloadQueue: OperationQueue {
        return configuration.operationQueue
    }
    
    /// `configuration.uploadQueue`
    public var uploadQueue: OperationQueue {
        return configuration.operationQueue
    }
    
}
