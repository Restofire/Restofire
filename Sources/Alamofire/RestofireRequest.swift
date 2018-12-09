//
//  Restofire.swift
//  Restofire
//
//  Created by Rahul Katariya on 19/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

class RestofireRequest {
    
    static func dataRequest<R: ARequestable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> DataRequest {
        let urlRequest = prepareRequest(urlRequest, requestable: requestable)
        let request = requestable.session.request(urlRequest)
        requestable.session.requestQueue.async {
            requestable.session.rootQueue.async {
                didSendRequest(request, requestable: requestable)
            }
        }
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireRequestValidation.validateDataRequest(request: request, requestable: requestable)
        return request
    }

    static func downloadRequest<R: ADownloadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> DownloadRequest {
        let urlRequest = prepareDownloadRequest(urlRequest, requestable: requestable)
        var request: DownloadRequest!
        if let resumeData = requestable.resumeData {
            request = requestable.session.download(resumingWith: resumeData, to: requestable.destination)
        } else {
            request = requestable.session.download(urlRequest, to: requestable.destination)
        }
        requestable.session.requestQueue.async {
            requestable.session.rootQueue.async {
                didSendDownloadRequest(request, requestable: requestable)
            }
        }
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireDownloadValidation.validateDownloadRequest(request: request, requestable: requestable)
        return request
    }

    static func fileUploadRequest<R: AFileUploadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> UploadRequest {
        let urlRequest = prepareRequest(urlRequest, requestable: requestable)
        let request = requestable.session.upload(requestable.url, with: urlRequest)
        requestable.session.requestQueue.async {
            requestable.session.rootQueue.async {
                didSendRequest(request, requestable: requestable)
            }
        }
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireUploadValidation.validateUploadRequest(request: request, requestable: requestable)
        return request
    }

    static func dataUploadRequest<R: ADataUploadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> UploadRequest {
        let urlRequest = prepareRequest(urlRequest, requestable: requestable)
        let request = requestable.session.upload(requestable.data, with: urlRequest)
        requestable.session.requestQueue.async {
            requestable.session.rootQueue.async {
                didSendRequest(request, requestable: requestable)
            }
        }
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireUploadValidation.validateUploadRequest(request: request, requestable: requestable)
        return request
    }

    static func streamUploadRequest<R: AStreamUploadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> UploadRequest {
        let urlRequest = prepareRequest(urlRequest, requestable: requestable)
        let request = requestable.session.upload(requestable.stream, with: urlRequest)
        requestable.session.requestQueue.async {
            requestable.session.rootQueue.async {
                didSendRequest(request, requestable: requestable)
            }
        }
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireUploadValidation.validateUploadRequest(request: request, requestable: requestable)
        return request
    }

    static func multipartUploadRequest<R: AMultipartUploadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> UploadRequest {
        let urlRequest = prepareRequest(urlRequest, requestable: requestable)
        let request = requestable.session.upload(
            multipartFormData: requestable.multipartFormData,
            usingThreshold: requestable.encodingMemoryThreshold,
            with: urlRequest
        )
        requestable.session.requestQueue.async {
            requestable.session.rootQueue.async {
                didSendRequest(request, requestable: requestable)
            }
        }
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireUploadValidation.validateUploadRequest(request: request, requestable: requestable)
        return request
    }

    internal static func authenticateRequest(_ request: Request, usingCredential credential: URLCredential?) {
        guard let credential = credential else { return }
        request.authenticate(with: credential)
    }

    internal static func prepareRequest<R: ARequestable>(_ request: URLRequest, requestable: R) -> URLRequest {
        var request = request
        requestable.delegates.forEach {
            request = $0.prepare(request, requestable: requestable)
        }
        request = requestable.prepare(request, requestable: requestable)
        return request
    }

    internal static func didSendRequest<R: ARequestable>(_ request: Request, requestable: R) {
        requestable.delegates.forEach {
            $0.didSend(request, requestable: requestable)
        }
        requestable.didSend(request, requestable: requestable)
    }

    internal static func prepareDownloadRequest<R: ADownloadable>(_ request: URLRequest, requestable: R) -> URLRequest {
        var request = request
        requestable.delegates.forEach {
            request = $0.prepare(request, requestable: requestable)
        }
        request = requestable.prepare(request, requestable: requestable)
        return request
    }

    internal static func didSendDownloadRequest<R: ADownloadable>(_ request: Request, requestable: R) {
        requestable.delegates.forEach {
            $0.didSend(request, requestable: requestable)
        }
        requestable.didSend(request, requestable: requestable)
    }
    
}
