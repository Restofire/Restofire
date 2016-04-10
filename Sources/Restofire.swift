//
//  Restofire.swift
//  Restofire
//
//  Created by Rahul Katariya on 01/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

public class Restofire {
    
    public static var defaultConfiguration = Configuration()
    public static var defaultRequestEventuallyTimeOut: NSTimeInterval = 600
    public static var defaultMaxAttempts: UInt8 = 5
    
    static let requestEventuallyQueue = RequestEventuallyQueue()
    let internetReachableAfterTimeWait: NSTimeInterval = 5
    
}
