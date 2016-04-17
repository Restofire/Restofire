//
//  RequestConstructor.swift
//  Restofire
//
//  Created by Rahul Katariya on 02/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

class Request {
    
    let requestable: Requestable
    let request: Alamofire.Request
    
    init(requestable: Requestable) {
        self.requestable = requestable
        self.request = requestable.request
        authenticateRequests()
        validateRequests()
    }
    
    func execute(completionHandler: (Response<AnyObject, NSError> -> Void)? = nil) {
        request.response(rootKeyPath: requestable.rootKeyPath) { (response: Response<AnyObject, NSError>) -> Void in
            if let completionHandler = completionHandler { completionHandler(response) }
            if self.requestable.logging { debugPrint(response) }
        }
    }
    
    deinit {
        request.cancel()
    }
    
}

// MARK: - Authentication
extension Request {

    func authenticateRequests() {
        authenticateRequest(request, usingCredential: requestable.credential)
    }
    
    func authenticateRequest(request: Alamofire.Request, usingCredential credential:NSURLCredential?) {
        guard let credential = credential else { return }
        request.authenticate(usingCredential: credential)
    }
    
}

// MARK: - Validations
extension Request {

    func validateRequests() {
        validateRequest(request, forAcceptableContentTypes: requestable.acceptableContentTypes)
        validateRequest(request, forAcceptableStatusCodes: requestable.acceptableStatusCodes)
        validateRequest(request, forValidation: requestable.validation)
    }
    
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
