//
//  Restofire.swift
//  Restofire
//
//  Created by Rahul Katariya on 01/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

public var defaultConfiguration = Configuration()
public var defaultRequestEventuallyTimeOut: NSTimeInterval = 600
public var defaultMaxAttempts: UInt8 = 5

let requestEventuallyQueue = RequestEventuallyQueue()
let internetReachableAfterTimeWait: NSTimeInterval = 5