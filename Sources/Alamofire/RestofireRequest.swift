//
//  Restofire.swift
//  Restofire
//
//  Created by Rahul Katariya on 19/04/16.
//  Copyright © 2016 Restofire. All rights reserved.
//

import Foundation
import Alamofire

class RestofireRequest {
    
    static func dataRequest<R: Requestable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> DataRequest {
        let urlRequest = prepareRequest(urlRequest, requestable: requestable)
        let request = requestable.session.request(urlRequest)
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireRequestValidation.validateDataRequest(request: request, requestable: requestable)
        requestable.session.requestQueue.async {
            requestable.session.rootQueue.async {
                willSendRequest(request, requestable: requestable)
                request.resume()
                didSendRequest(request, requestable: requestable)
            }
        }
        return request
    }

    static func downloadRequest<R: Downloadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> DownloadRequest {
        let urlRequest = prepareDownloadRequest(urlRequest, requestable: requestable)
        var request: DownloadRequest!
        if let resumeData = requestable.resumeData {
            request = requestable.session.download(resumingWith: resumeData, to: requestable.destination)
        } else {
            request = requestable.session.download(urlRequest, to: requestable.destination)
        }
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireDownloadValidation.validateDownloadRequest(request: request, requestable: requestable)
        requestable.session.requestQueue.async {
            requestable.session.rootQueue.async {
                willSendRequest(request, requestable: requestable)
                request.resume()
                didSendRequest(request, requestable: requestable)
            }
        }
        return request
    }

    static func fileUploadRequest<R: FileUploadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> UploadRequest {
        let urlRequest = prepareRequest(urlRequest, requestable: requestable)
        let request = requestable.session.upload(requestable.url, with: urlRequest)
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireUploadValidation.validateUploadRequest(request: request, requestable: requestable)
        requestable.session.requestQueue.async {
            requestable.session.rootQueue.async {
                willSendRequest(request, requestable: requestable)
                request.resume()
                didSendRequest(request, requestable: requestable)
            }
        }
        return request
    }

    static func dataUploadRequest<R: DataUploadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> UploadRequest {
        let urlRequest = prepareRequest(urlRequest, requestable: requestable)
        let request = requestable.session.upload(requestable.data, with: urlRequest)
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireUploadValidation.validateUploadRequest(request: request, requestable: requestable)
        requestable.session.requestQueue.async {
            requestable.session.rootQueue.async {
                willSendRequest(request, requestable: requestable)
                request.resume()
                didSendRequest(request, requestable: requestable)
            }
        }
        return request
    }

    static func streamUploadRequest<R: StreamUploadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> UploadRequest {
        let urlRequest = prepareRequest(urlRequest, requestable: requestable)
        let request = requestable.session.upload(requestable.stream, with: urlRequest)
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireUploadValidation.validateUploadRequest(request: request, requestable: requestable)
        requestable.session.requestQueue.async {
            requestable.session.rootQueue.async {
                willSendRequest(request, requestable: requestable)
                request.resume()
                didSendRequest(request, requestable: requestable)
            }
        }
        return request
    }

    static func multipartUploadRequest<R: MultipartUploadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest) -> UploadRequest {
        let urlRequest = prepareRequest(urlRequest, requestable: requestable)
        let request = requestable.session.upload(
            multipartFormData: requestable.multipartFormData,
            usingThreshold: requestable.encodingMemoryThreshold,
            with: urlRequest
        )
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireUploadValidation.validateUploadRequest(request: request, requestable: requestable)
        requestable.session.requestQueue.async {
            requestable.session.rootQueue.async {
                willSendRequest(request, requestable: requestable)
                request.resume()
                didSendRequest(request, requestable: requestable)
            }
        }
        return request
    }

    internal static func authenticateRequest(_ request: Request, usingCredential credential: URLCredential?) {
        guard let credential = credential else { return }
        request.authenticate(with: credential)
    }

    internal static func prepareRequest<R: BaseRequestable>(_ request: URLRequest, requestable: R) -> URLRequest {
        precondition(requestable.session.startRequestsImmediately == false,
                     "The session should always have startRequestsImmediately to false")
        var request = request
        requestable.delegates.forEach {
            request = $0.prepare(request, requestable: requestable)
        }
        request = requestable.prepare(request, requestable: requestable)
        return request
    }
    
    internal static func willSendRequest<R: BaseRequestable>(_ request: Request, requestable: R) {
        requestable.delegates.forEach {
            $0.willSend(request, requestable: requestable)
        }
        requestable.willSend(request, requestable: requestable)
    }
    
    internal static func didSendRequest<R: BaseRequestable>(_ request: Request, requestable: R) {
        requestable.delegates.forEach {
            $0.didSend(request, requestable: requestable)
        }
        requestable.didSend(request, requestable: requestable)
    }

    internal static func prepareDownloadRequest<R: Downloadable>(_ request: URLRequest, requestable: R) -> URLRequest {
        var request = request
        requestable.delegates.forEach {
            request = $0.prepare(request, requestable: requestable)
        }
        request = requestable.prepare(request, requestable: requestable)
        return request
    }
    
}
