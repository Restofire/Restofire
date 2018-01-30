//
//  Queueable.swift
//  Restofire
//
//  Created by Rahul Katariya on 15/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// Represents a `Queueable` that is associated with `Requestable`.
public protocol Queueable {
    
    /// The `queue`.
    var _queue: DispatchQueue { get }
    
}

public extension Queueable where Self: Configurable {
    
    /// `DispatchQueue.main`
    public var _queue: DispatchQueue {
        return DispatchQueue.main
    }
    
}
