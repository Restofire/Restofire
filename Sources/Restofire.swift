//
//  Restofire.swift
//  Restofire
//
//  Created by Rahul Katariya on 01/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

#if !os(watchOS)
    /// The default request eventually queue.
    public let defaultRequestEventuallyQueue: OperationQueue = {
        let oq = OperationQueue()
        if #available(OSX 10.10, *) { oq.qualityOfService = .utility }
        return oq
    }()
#endif
