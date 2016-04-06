//
//  RequestConstructor.swift
//  Restofire
//
//  Created by Rahul Katariya on 02/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

class Request<T: Requestable> {
    
    let requestable: T!
    var request: Alamofire.Request!
    var requestCompletionHandler: (Response<T.Model, NSError> -> Void)!
    
    init(requestable: T) {
        self.requestable = requestable
        request = requestFromRequestable(requestable)
    }
    
    func requestFromRequestable(requestable: T) -> Alamofire.Request {
        
        var request: Alamofire.Request!
        
        request = Alamofire.request(requestable.method, requestable.baseURL + requestable.path, parameters: requestable.parameters as? [String: AnyObject], encoding: requestable.encoding, headers: requestable.headers)
        
        if let parameters = requestable.parameters as? [AnyObject] where requestable.method != .GET {
            let encodedURLRequest = RequestConstructor.encodeURLRequest(request.request!, parameters: parameters, encoding: requestable.encoding).0
            request = Alamofire.request(encodedURLRequest)
        }
        
        return request
        
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