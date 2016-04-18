//
//  RequestOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 16/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// RequestOperation represents an NSOperation object which executes the request
/// asynchronously on start
public class RequestOperation: HTTPOperation {
    
    public override init(requestable: Requestable, completionHandler: (Response<AnyObject, NSError> -> Void)? = nil) {
        super.init(requestable: requestable, completionHandler: completionHandler)
        ready = true
    }
    
    override func executeRequest() {
        request.response { (response: Response<AnyObject, NSError>) in
            if response.result.error == nil {
                self.successful = true
                if let completionHandler = self.completionHandler { completionHandler(response) }
            } else {
                self.failed = true
                if let completionHandler = self.completionHandler { completionHandler(response) }
            }
        }
    }
    
}
