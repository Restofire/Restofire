//
//  RequestEventually.swift
//  Restofire
//
//  Created by Rahul Katariya on 10/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

class RequestEventually {
    
    let request: Request
    let requestCompletionHandler: (Response<AnyObject, NSError> -> Void)
    var timeOut: NSTimeInterval = Restofire.defaultRequestEventuallyTimeOut
    var maxAttempts: UInt8 = Restofire.defaultMaxAttempts + 1
    
    init(request: Request, requestCompletionHandler: (Response<AnyObject, NSError> -> Void)) {
        self.request = request
        self.requestCompletionHandler = requestCompletionHandler
    }
    
}
