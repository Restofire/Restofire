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
    let manager: Alamofire.Manager!
    var request: Alamofire.Request!
    
    init(requestable: Requestable) {
        self.requestable = requestable
        self.manager = Alamofire.Manager(configuration: requestable.sessionConfiguration)
        request = requestFromRequestable(requestable)
    }
    
    func requestFromRequestable(requestable: Requestable) -> Alamofire.Request {
        
        var request: Alamofire.Request!
        
        request = manager.request(requestable.method, requestable.baseURL + requestable.path, parameters: requestable.parameters as? [String: AnyObject], encoding: requestable.encoding, headers: requestable.headers)
        
        if let parameters = requestable.parameters as? [AnyObject] where requestable.method != .GET {
            let encodedURLRequest = Request.encodeURLRequest(request.request!, parameters: parameters, encoding: requestable.encoding).0
            request = Alamofire.request(encodedURLRequest)
        }
        
        return request
        
    }
    
    func executeTask(completionHandler: Response<AnyObject, NSError> -> Void) {
        validateRequest(request, forAcceptableContentTypes: requestable.acceptableContentTypes)
        validateRequest(request, forAcceptableStatusCodes: requestable.acceptableStatusCodes)
        validateRequest(request, forValidation: requestable.validation)
        request.response(rootKeyPath: requestable.rootKeyPath) { (response: Response<AnyObject, NSError>) -> Void in
            completionHandler(response)
            if self.requestable.logging { debugPrint(response) }
        }
    }
    
    deinit {
        request.cancel()
    }
    
}

// MARK: - Validations
extension Request {
    
    func validateRequest(request: Alamofire.Request, forAcceptableContentTypes contentTypes:[String]?) {
        guard let contentTypes = contentTypes else { return }
        request.validate(contentType: contentTypes)
    }
    
    func validateRequest(request: Alamofire.Request, forAcceptableStatusCodes statusCodes:[Range<Int>]?) {
        guard let statusCodes = statusCodes else { return }
        for statusCode in statusCodes {
            request.validate(statusCode: statusCode)
        }
    }
    
    func validateRequest(request: Alamofire.Request, forValidation validation:Alamofire.Request.Validation?) {
        guard let validation = validation else { return }
        request.validate(validation)
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
