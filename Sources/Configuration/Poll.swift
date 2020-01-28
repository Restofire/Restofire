//
//  Poll.swift
//  Restofire
//
//  Created by RahulKatariya on 09/12/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation

/// A Poll for RESTful Services.
///
/// ```swift
/// var poll = Poll()
/// poll.pollingInterval = 1.0
/// ```
public struct Poll {
    /// The default poll.
    public static var `default` = Poll()

    /// The polling interval.
    public var pollingInterval: TimeInterval = 0.0
}
