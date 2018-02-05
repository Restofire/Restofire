//
//  Restofire.swift
//  Restofire
//
//  Created by Rahul Katariya on 19/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

class RestofireRequest {
    
    static func dataRequest<R: ARequestable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> Alamofire.DataRequest {
        let urlRequest = prepare(urlRequest, requestable: requestable)
        let request = requestable.sessionManager.request(urlRequest)
        didSend(request, requestable: requestable)
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireRequestValidation.validateDataRequest(request: request, requestable: requestable)
        request.response { _ in didComplete(request, requestable: requestable) }
        return request
    }
    
    static func downloadRequest<R: ADownloadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> Alamofire.DownloadRequest {
        let urlRequest = prepare(urlRequest, requestable: requestable)
        let request = requestable.sessionManager.download(urlRequest, to: requestable.destination)
        didSend(request, requestable: requestable)
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireDownloadValidation.validateDownloadRequest(request: request, requestable: requestable)
        request.response { _ in didComplete(request, requestable: requestable) }
        return request
    }
    
    static func fileUploadRequest<R: AFileUploadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> Alamofire.UploadRequest {
        let urlRequest = prepare(urlRequest, requestable: requestable)
        let request = requestable.sessionManager.upload(requestable.url, with: urlRequest)
        didSend(request, requestable: requestable)
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireRequestValidation.validateDataRequest(request: request, requestable: requestable)
        request.response { _ in didComplete(request, requestable: requestable) }
        return request
    }
    
    static func dataUploadRequest<R: ADataUploadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> Alamofire.UploadRequest {
        let urlRequest = prepare(urlRequest, requestable: requestable)
        let request = requestable.sessionManager.upload(requestable.data, with: urlRequest)
        didSend(request, requestable: requestable)
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireRequestValidation.validateDataRequest(request: request, requestable: requestable)
        request.response { _ in didComplete(request, requestable: requestable) }
        return request
    }
    
    static func streamUploadRequest<R: AStreamUploadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> Alamofire.UploadRequest {
        let urlRequest = prepare(urlRequest, requestable: requestable)
        let request = requestable.sessionManager.upload(requestable.stream, with: urlRequest)
        didSend(request, requestable: requestable)
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireRequestValidation.validateDataRequest(request: request, requestable: requestable)
        request.response { _ in didComplete(request, requestable: requestable) }
        return request
    }
    
    static func multipartUploadRequest<R: AMultipartUploadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest, encodingCompletion: ((MultipartFormDataEncodingResult) -> Void)? = nil) {
        let urlRequest = prepare(urlRequest, requestable: requestable)
        let localEncodingCompletion = encodingCompletion
        requestable.sessionManager.upload(
            multipartFormData: requestable.multipartFormData,
            usingThreshold: requestable.threshold,
            with: urlRequest) { encodingCompletion in
                switch encodingCompletion {
                case .success(let request, let streamingFromDisk, let streamFileURL):
                    didSend(request, requestable: requestable)
                    authenticateRequest(request, usingCredential: requestable.credential)
                    RestofireRequestValidation.validateDataRequest(
                        request: request,
                        requestable: requestable
                    )
                    request.response { _ in didComplete(request, requestable: requestable) }
                    let result = MultipartFormDataEncodingResult.success(request: request, streamingFromDisk: streamingFromDisk, streamFileURL: streamFileURL)
                    localEncodingCompletion?(result)
                case .failure(_):
                    localEncodingCompletion?(encodingCompletion)
                }
        }
    }
    
    fileprivate static func authenticateRequest(_ request: Request, usingCredential credential: URLCredential?) {
        guard let credential = credential else { return }
        request.authenticate(usingCredential: credential)
    }
    
    fileprivate static func prepare<R: AConfigurable>(_ request: URLRequest, requestable: R) -> URLRequest {
        var request = request
        request = requestable.prepare(request, requestable: requestable)
        requestable.delegates.forEach {
            request = $0.prepare(request, requestable: requestable)
        }
        return request
    }
    
    fileprivate static func didSend<R: AConfigurable>(_ request: Request, requestable: R) {
        requestable.didSend(request, requestable: requestable)
        requestable.delegates.forEach {
            $0.didSend(request, requestable: requestable)
        }
    }
    
    fileprivate static func didComplete<R: AConfigurable>(_ request: Request, requestable: R) {
        requestable.didComplete(request, requestable: requestable)
        requestable.delegates.forEach {
            $0.didComplete(request, requestable: requestable)
        }
    }
}
