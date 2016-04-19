//
//  Restofire.swift
//  Restofire
//
//  Created by Rahul Katariya on 01/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// The default configuration used for `requestable` objects.
/// One needs to override baseURL.
public var defaultConfiguration = Configuration()

#if !os(watchOS)
/// The default request eventually queue to which all the request eventually
/// operations are added.
let defaultRequestEventuallyQueue: NSOperationQueue = {
    let oq = NSOperationQueue()
    if #available(OSX 10.10, *) { oq.qualityOfService = .Utility }
    return oq
}()
#endif