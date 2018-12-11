//
//  Reachable.swift
//  Restofire
//
//  Created by Rahul Katariya on 30/01/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation
import Alamofire

/// Represents a `Reachability` that is associated with `Requestable`.
public protocol Reachable {
    
    /// The `reachable`.
    var reachability: Reachability { get }
    
}

extension Reachable where Self: Configurable {
    
    /// `Reachability.default`
    public var reachability: Reachability {
        return Reachability.default
    }
    
}
