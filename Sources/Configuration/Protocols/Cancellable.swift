//
//  Cancellable.swift
//  Restofire
//
//  Created by RahulKatariya on 04/02/19.
//  Copyright © 2019 Restofire. All rights reserved.
//

import Foundation

/// Protocol to define the opaque type returned from a request.
public protocol Cancellable {
    /// A Boolean value stating whether a request is cancelled.
    var isCancelled: Bool { get }

    /// Cancels the represented request.
    func cancel()
}
