//
//  QueuePriortizable.swift
//  Restofire
//
//  Created by RahulKatariya on 21/08/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation

/// Represents an `QueuePriortizable` that is associated with `Requestable`.
public protocol QueuePriortizable {
    /// The operation queue priority.
    var priority: Operation.QueuePriority { get }
}

extension QueuePriortizable where Self: Configurable {
    /// `configuration.operationQueuePriority`
    public var priority: Operation.QueuePriority {
        return configuration.operationQueuePriority
    }
}

/// Represents an `VeryHighQueuePriortizable` that is associated with `Requestable`.
public protocol VeryHighQueuePriortizable: QueuePriortizable {}

extension VeryHighQueuePriortizable {
    /// `Operation.QueuePriority.veryHigh`
    public var priority: Operation.QueuePriority {
        return .veryHigh
    }
}

/// Represents an `HighQueuePriortizable` that is associated with `Requestable`.
public protocol HighQueuePriortizable: QueuePriortizable {}

extension HighQueuePriortizable {
    /// `Operation.QueuePriority.high`
    public var priority: Operation.QueuePriority {
        return .high
    }
}

/// Represents an `NormalQueuePriortizable` that is associated with `Requestable`.
public protocol NormalQueuePriortizable: QueuePriortizable {}

extension NormalQueuePriortizable {
    /// `Operation.QueuePriority.normal`
    public var priority: Operation.QueuePriority {
        return .normal
    }
}

/// Represents an `LowQueuePriortizable` that is associated with `Requestable`.
public protocol LowQueuePriortizable: QueuePriortizable {}

extension LowQueuePriortizable {
    /// `Operation.QueuePriority.low`
    public var priority: Operation.QueuePriority {
        return .low
    }
}

/// Represents an `VeryLowQueuePriortizable` that is associated with `Requestable`.
public protocol VeryLowQueuePriortizable: QueuePriortizable {}

extension VeryLowQueuePriortizable {
    /// `Operation.QueuePriority.veryLow`
    public var priority: Operation.QueuePriority {
        return .veryLow
    }
}
