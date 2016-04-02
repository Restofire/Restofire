//
//  RequestConstructor.swift
//  Restofire
//
//  Created by Rahul Katariya on 02/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

class RequestConstructor {
    
    static func requestFromRequestable(requestable: Requestable) -> Alamofire.Request {
        
        var request: Alamofire.Request!
        
        request = Alamofire.request(requestable.method, requestable.baseURL + requestable.path, parameters: requestable.parameters as? [String: AnyObject], encoding: requestable.encoding, headers: requestable.headers)
        
        if let parameters = requestable.parameters as? [AnyObject] where requestable.method != .GET {
            let encodedURLRequest = encodeURLRequest(request.request!, parameters: parameters, encoding: requestable.encoding).0
            request = Alamofire.request(encodedURLRequest)
        }
        
        return request
        
    }
    
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

