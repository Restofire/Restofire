//
//  Restofire.swift
//  Restofire
//
//  Created by Rahul Katariya on 01/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// The default configuration.
public var defaultConfiguration = Configuration()

#if !os(watchOS)
let defaultRequestEventuallyQueue: OperationQueue = {
    let oq = OperationQueue()
    if #available(OSX 10.10, *) { oq.qualityOfService = .utility }
    return oq
}()
#endif
