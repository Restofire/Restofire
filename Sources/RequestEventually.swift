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
    
    init(request: Request, requestCompletionHandler: (Response<AnyObject, NSError> -> Void)) {
        self.request = request
        self.requestCompletionHandler = requestCompletionHandler
    }
    
}