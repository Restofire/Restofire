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

extension QueuePriortizable where Self: AConfigurable {
    
    public var priority: Operation.QueuePriority {
        return configuration.operationQueuePriority
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

public protocol NormalQueuePriortizable: QueuePriortizable {}

extension NormalQueuePriortizable {
    
    public var priority: Operation.QueuePriority {
        return .normal
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
