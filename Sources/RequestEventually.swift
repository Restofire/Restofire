//
//  RequestEventually.swift
//  Restofire
//
//  Created by Rahul Katariya on 10/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

struct RequestEventually {
    
    let request: Request
    let requestCompletionHandler: (Response<AnyObject, NSError> -> Void)
    let internetReachableTimeWait: NSTimeInterval = 10
    var defaultRequestEventuallyTimeOut: NSTimeInterval = 600
    var defaultMaxAttempts: NSTimeInterval = 6
    
    init(request: Request, requestCompletionHandler: (Response<AnyObject, NSError> -> Void)) {
        self.request = request
        self.requestCompletionHandler = requestCompletionHandler
    }
    
}