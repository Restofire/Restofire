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
    
    var priority: Operation.QueuePriority {
        return .normal
    }
    
}

protocol VeryHighQueuePriortizable: QueuePriortizable {}

extension VeryHighQueuePriortizable {
    
    var priority: Operation.QueuePriority {
        return .veryHigh
    }
    
}

protocol HighQueuePriortizable: QueuePriortizable {}

extension HighQueuePriortizable {
    
    var priority: Operation.QueuePriority {
        return .high
    }
    
}

protocol LowQueuePriortizable: QueuePriortizable {}

extension LowQueuePriortizable {
    
    var priority: Operation.QueuePriority {
        return .low
    }
    
}

protocol VeryLowQueuePriortizable: QueuePriortizable {}

extension VeryLowQueuePriortizable {
    
    var priority: Operation.QueuePriority {
        return .veryLow
    }
    
}
