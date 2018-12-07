//
//  QueuePriortizable.swift
//  Restofire
//
//  Created by RahulKatariya on 21/08/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation

public protocol QueuePriortizable {
    
    var priority: Operation.QueuePriority { get }
    
}

extension QueuePriortizable {
    
    public var priority: Operation.QueuePriority {
        return .normal
    }
    
}

public protocol VeryHighQueuePriortizable: QueuePriortizable {}

extension VeryHighQueuePriortizable {
    
    public var priority: Operation.QueuePriority {
        return .veryHigh
    }
    
}

public protocol HighQueuePriortizable: QueuePriortizable {}

extension HighQueuePriortizable {
    
    public var priority: Operation.QueuePriority {
        return .high
    }
    
}

public protocol LowQueuePriortizable: QueuePriortizable {}

extension LowQueuePriortizable {
    
    public var priority: Operation.QueuePriority {
        return .low
    }
    
}

public protocol VeryLowQueuePriortizable: QueuePriortizable {}

extension VeryLowQueuePriortizable {
    
    public var priority: Operation.QueuePriority {
        return .veryLow
    }
    
}
