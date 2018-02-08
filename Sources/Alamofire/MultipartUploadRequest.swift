//
//  MultipartUploadRequest.swift
//  Restofire
//
//  Created by Rahul Katariya on 09/02/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// Defines whether the `MultipartFormData` encoding was successful and contains result of the encoding as
/// associated values.
///
/// - Success: Represents a successful `MultipartFormData` encoding and contains the new `UploadRequest` along with
///            streaming information.
/// - Failure: Used to represent a failure in the `MultipartFormData` encoding and also contains the encoding
///            error.
public enum RFMultipartFormDataEncodingResult {
    case success(
        request: () -> UploadRequest,
        streamingFromDisk: Bool,
        streamFileURL: URL?
    )
    case failure(Error)
}

class MultipartUploadRequest {
    
    let queue = DispatchQueue(label: "org.alamofire.session-manager." + UUID().uuidString)
    
    func request<R: AMultipartUploadable>(fromRequestable requestable: R, withUrlRequest urlRequest: URLRequest, encodingCompletion: ((RFMultipartFormDataEncodingResult) -> Void)? = nil) {
        
        DispatchQueue.global(qos: .utility).async {
            let formData = MultipartFormData()
            requestable.multipartFormData(formData)
            
            var tempFileURL: URL?
            
            do {
                var urlRequestWithContentType = try urlRequest.asURLRequest()
                urlRequestWithContentType.setValue(formData.contentType, forHTTPHeaderField: "Content-Type")
                
                let isBackgroundSession = requestable.sessionManager.session.configuration.identifier != nil
                
                if formData.contentLength < requestable.encodingMemoryThreshold && !isBackgroundSession {
                    let data = try formData.encode()
                    
                    let upload: () -> UploadRequest = {
                        let request = requestable.sessionManager.upload(data, with: urlRequestWithContentType)
                        RestofireRequest.didSend(request, requestable: requestable)
                        RestofireRequest.authenticateRequest(request, usingCredential: requestable.credential)
                        RestofireRequestValidation.validateDataRequest(
                            request: request,
                            requestable: requestable
                        )
                        return request
                    }
                    
                    let encodingResult = RFMultipartFormDataEncodingResult.success(
                        request: upload,
                        streamingFromDisk: false,
                        streamFileURL: nil
                    )
                    
                    DispatchQueue.main.async { encodingCompletion?(encodingResult) }
                } else {
                    let fileManager = FileManager.default
                    let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
                    let directoryURL = tempDirectoryURL.appendingPathComponent("org.alamofire.manager/multipart.form.data")
                    let fileName = UUID().uuidString
                    let fileURL = directoryURL.appendingPathComponent(fileName)
                    
                    tempFileURL = fileURL
                    
                    var directoryError: Error?
                    
                    // Create directory inside serial queue to ensure two threads don't do this in parallel
                    self.queue.sync {
                        do {
                            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                        } catch {
                            directoryError = error
                        }
                    }
                    
                    if let directoryError = directoryError { throw directoryError }
                    
                    try formData.writeEncodedData(to: fileURL)
                    
                    let upload: () -> UploadRequest = {
                        let request = requestable.sessionManager.upload(fileURL, with: urlRequestWithContentType)
                        RestofireRequest.didSend(request, requestable: requestable)
                        RestofireRequest.authenticateRequest(request, usingCredential: requestable.credential)
                        RestofireRequestValidation.validateDataRequest(
                            request: request,
                            requestable: requestable
                        )
                        
                        // Cleanup the temp file once the upload is complete
                        request.delegate.queue.addOperation {
                            do {
                                try FileManager.default.removeItem(at: fileURL)
                            } catch {
                                // No-op
                            }
                        }
                        
                        return request
                    }
                    
                    DispatchQueue.main.async {
                        let encodingResult = RFMultipartFormDataEncodingResult.success(
                            request: upload,
                            streamingFromDisk: true,
                            streamFileURL: fileURL
                        )
                        
                        encodingCompletion?(encodingResult)
                    }
                }
            } catch {
                // Cleanup the temp file in the event that the multipart form data encoding failed
                if let tempFileURL = tempFileURL {
                    do {
                        try FileManager.default.removeItem(at: tempFileURL)
                    } catch {
                        // No-op
                    }
                }
                
                DispatchQueue.main.async { encodingCompletion?(.failure(error)) }
            }
        }
    }
}
