//
//  Restofire.swift
//  Restofire
//
//  Created by Rahul Katariya on 19/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

class RestofireRequest {
    
    static func dataRequest<R: ARequestable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> DataRequest {
        let urlRequest = prepare(urlRequest, requestable: requestable)
        let request = requestable.sessionManager.request(urlRequest)
        didSend(request, requestable: requestable)
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireRequestValidation.validateDataRequest(request: request, requestable: requestable)
        return request
    }
    
    static func downloadRequest<R: ADownloadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> DownloadRequest {
        let urlRequest = prepare(urlRequest, requestable: requestable)
        let request = requestable.sessionManager.download(urlRequest, to: requestable.destination)
        didSend(request, requestable: requestable)
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireDownloadValidation.validateDownloadRequest(request: request, requestable: requestable)
        return request
    }
    
    static func fileUploadRequest<R: AFileUploadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> UploadRequest {
        let urlRequest = prepare(urlRequest, requestable: requestable)
        let request = requestable.sessionManager.upload(requestable.url, with: urlRequest)
        didSend(request, requestable: requestable)
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireRequestValidation.validateDataRequest(request: request, requestable: requestable)
        return request
    }
    
    static func dataUploadRequest<R: ADataUploadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> UploadRequest {
        let urlRequest = prepare(urlRequest, requestable: requestable)
        let request = requestable.sessionManager.upload(requestable.data, with: urlRequest)
        didSend(request, requestable: requestable)
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireRequestValidation.validateDataRequest(request: request, requestable: requestable)
        return request
    }
    
    static func streamUploadRequest<R: AStreamUploadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> UploadRequest {
        let urlRequest = prepare(urlRequest, requestable: requestable)
        let request = requestable.sessionManager.upload(requestable.stream, with: urlRequest)
        didSend(request, requestable: requestable)
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireRequestValidation.validateDataRequest(request: request, requestable: requestable)
        return request
    }
    
    static func multipartUploadRequest<R: AMultipartUploadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest, encodingCompletion: ((RFMultipartFormDataEncodingResult) -> Void)? = nil) {
        let urlRequest = prepare(urlRequest, requestable: requestable)
        let multipartUploadRequest = MultipartUploadRequest()
        multipartUploadRequest.request(fromRequestable: requestable, withUrlRequest: urlRequest, encodingCompletion: encodingCompletion)
    }
    
    internal static func authenticateRequest(_ request: Request, usingCredential credential: URLCredential?) {
        guard let credential = credential else { return }
        request.authenticate(usingCredential: credential)
    }
    
    internal static func prepare<R: AConfigurable>(_ request: URLRequest, requestable: R) -> URLRequest {
        var request = request
        request = requestable.prepare(request, requestable: requestable)
        requestable.delegates.forEach {
            request = $0.prepare(request, requestable: requestable)
        }
        return request
    }
    
    internal static func didSend<R: AConfigurable>(_ request: Request, requestable: R) {
        requestable.didSend(request, requestable: requestable)
        requestable.delegates.forEach {
            $0.didSend(request, requestable: requestable)
        }
    }
    
}
