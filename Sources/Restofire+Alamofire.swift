//
//  Restofire.swift
//  Restofire
//
//  Created by Rahul Katariya on 19/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

class Restofire {
    
    static func dataRequest<R: Requestable>(fromRequestable requestable: R) -> Alamofire.DataRequest {
        let request = requestable.sessionManager.request(requestable.asUrlRequest()!)
        authenticateRequest(request, usingCredential: requestable.credential)
        validateRequest(request: request, requestable: requestable)
        return request
    }
    
    static func downloadRequest<R: Downloadable>(fromRequestable requestable: R) -> Alamofire.DownloadRequest {
        let request = requestable.sessionManager.download(requestable.asUrlRequest()!, to: requestable.destination)
        authenticateRequest(request, usingCredential: requestable.credential)
        return request
    }
    
    static func fileUploadRequest<R: FileUploadable>(fromRequestable requestable: R) -> Alamofire.UploadRequest {
        let request = requestable.sessionManager.upload(requestable.url, with: requestable.asUrlRequest()!)
        authenticateRequest(request, usingCredential: requestable.credential)
        validateRequest(request: request, requestable: requestable)
        return request
    }
    
    static func dataUploadRequest<R: DataUploadable>(fromRequestable requestable: R) -> Alamofire.UploadRequest {
        let request = requestable.sessionManager.upload(requestable.data, with: requestable.asUrlRequest()!)
        authenticateRequest(request, usingCredential: requestable.credential)
        validateRequest(request: request, requestable: requestable)
        return request
    }
    
    static func streamUploadRequest<R: StreamUploadable>(fromRequestable requestable: R) -> Alamofire.UploadRequest {
        let request = requestable.sessionManager.upload(requestable.stream, with: requestable.asUrlRequest()!)
        authenticateRequest(request, usingCredential: requestable.credential)
        validateRequest(request: request, requestable: requestable)
        return request
    }
    
    static func multipartUploadRequest<R: MultipartUploadable>(fromRequestable requestable: R) {
        requestable.sessionManager.upload(
            multipartFormData: requestable.multipartFormData,
            usingThreshold: requestable.threshold,
            with: requestable.asUrlRequest()!) { encodingCompletion in
                switch encodingCompletion {
                case .success(let request,_,_):
                    authenticateRequest(request, usingCredential: requestable.credential)
                    validateRequest(request: request, requestable: requestable)
                    requestable.encodingCompletion?(encodingCompletion)
                case .failure(_):
                    requestable.encodingCompletion?(encodingCompletion)
                }
        }
    }

}

extension Restofire {
    
    fileprivate static func authenticateRequest(_ request: Request, usingCredential credential:URLCredential?) {
        guard let credential = credential else { return }
        request.authenticate(usingCredential: credential)
    }
    
    fileprivate static func validateRequest(request: DataRequest, requestable: Requestable) {
        validateRequest(request, forAcceptableContentTypes: requestable.acceptableContentTypes)
        validateRequest(request, forAcceptableStatusCodes: requestable.acceptableStatusCodes)
        validateRequest(request, forValidation: requestable.validationBlock)
    }
    
    fileprivate static func validateRequest(_ request: DataRequest, forAcceptableContentTypes contentTypes:[String]?) {
        guard let contentTypes = contentTypes else { return }
        request.validate(contentType: contentTypes)
    }
    
    fileprivate static func validateRequest(_ request: DataRequest, forAcceptableStatusCodes statusCodes:[Int]?) {
        guard let statusCodes = statusCodes else { return }
        request.validate(statusCode: statusCodes)
    }
    
    fileprivate static func validateRequest(_ request: DataRequest, forValidation validation:DataRequest.Validation?) {
        guard let validation = validation else { return }
        request.validate(validation)
    }
    
}
