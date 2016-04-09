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
            let encodedURLRequest = Request.encodeURLRequest(request.request!, parameters: parameters, encoding: requestable.encoding).0
            request = Alamofire.request(encodedURLRequest)
        }
        
        return request
        
    }
    
    func executeTask(completionHandler: Response<T.Model, NSError> -> Void) {
        request.response(rootKeyPath: requestable.rootKeyPath) {(response: Response<T.Model, NSError>) -> Void in
            completionHandler(response)
            if self.requestable.logging { debugPrint(response) }
        }
    }
    
    func executeTaskEventually(completionHandler: Response<T.Model, NSError> -> Void) {
        request.response(rootKeyPath: requestable.rootKeyPath) {(response: Response<T.Model, NSError>) -> Void in
            if response.result.error != nil {
                completionHandler(response)
            } else {
                self.requestCompletionHandler = completionHandler
                
            }
            if self.requestable.logging { debugPrint(response) }
        }
    }
    
    
    deinit {
        request.cancel()
    }
    
}

extension Request {
    
    static func encodeURLRequest(URLRequest: URLRequestConvertible, parameters: [AnyObject]?, encoding: ParameterEncoding) -> (NSMutableURLRequest, NSError?) {
        let mutableURLRequest = URLRequest.URLRequest
        
        guard let parameters = parameters where !parameters.isEmpty else {
            return (mutableURLRequest, nil)
        }
        
        var encodingError: NSError? = nil
        
        switch encoding {
        case .JSON:
            do {
                let options = NSJSONWritingOptions()
                let data = try NSJSONSerialization.dataWithJSONObject(parameters, options: options)
                
                mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                mutableURLRequest.HTTPBody = data
            } catch {
                encodingError = error as NSError
            }
        case .PropertyList(let format, let options):
            do {
                let data = try NSPropertyListSerialization.dataWithPropertyList(
                    parameters,
                    format: format,
                    options: options
                )
                mutableURLRequest.setValue("application/x-plist", forHTTPHeaderField: "Content-Type")
                mutableURLRequest.HTTPBody = data
            } catch {
                encodingError = error as NSError
            }
        default:
            break
        }
        
        return (mutableURLRequest, encodingError)
    }
    
}