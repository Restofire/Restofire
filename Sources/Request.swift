//
//  RequestConstructor.swift
//  Restofire
//
//  Created by Rahul Katariya on 02/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

class Request {
    
    let requestable: Requestable!
    var request: Alamofire.Request!
    
    init(requestable: Requestable) {
        self.requestable = requestable
        request = RequestConstructor.requestFromRequestable(requestable)
    }
    
    func executeTask<Model: Any>(completionHandler: Response<Model, NSError> -> Void) {
        request.response(rootKeyPath: requestable.rootKeyPath) {(response: Response<Model, NSError>) -> Void in
            completionHandler(response)
            if self.requestable.logging { debugPrint(response) }
        }
    }
    
    deinit {
        request.cancel()
    }
    
}