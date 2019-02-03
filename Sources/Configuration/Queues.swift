//
//  Queues.swift
//  Restofire
//
//  Created by RahulKatariya on 10/12/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation

/// A Queues for RESTful Services.
///
/// ```swift
/// var queues = Queues()
/// queues.completionQueue = DispatchQueue.main
/// ```
public struct Queues {
    
    /// The default queues.
    public static var `default` = Queues()
    
    /// The request operation queue
    public var requestQueue: OperationQueue = OperationQueue()
    
    /// The download operation queue
    public var downloadQueue: OperationQueue = OperationQueue()
    
    /// The upload operation queue
    public var uploadQueue: OperationQueue = OperationQueue()
    
}
