//
//  Retryable.swift
//  Restofire
//
//  Created by Rahul Katariya on 23/04/16.
//  Copyright © 2016 Restofire. All rights reserved.
//

import Foundation

/// Represents a `Retry` that is associated with `Requestable`.
public protocol Retryable {
    /// The `retry`.
    var retry: Retry { get }
}

extension Retryable where Self: Configurable {
    /// `Retry.default`
    public var retry: Retry {
        return Retry.default
    }
}
