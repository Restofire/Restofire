//
//  UploadOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// An NSOperation that executes the `Uploadable` asynchronously.
public class UploadOperation<R: Uploadable>: AOperation<R> {
    
    let uploadable: R
    let uploadRequest: () -> UploadRequest
    let completionHandler: ((DataResponse<R.Response>) -> Void)?
    
    /// Intializes an upload operation.
    ///
    /// - Parameters:
    ///   - uploadable: The `Uploadable`.
    ///   - request: The request closure.
    ///   - completionHandler: The async completion handler called
    ///     when the request is completed
    public init(uploadable: R, request: @escaping () -> UploadRequest, completionHandler: ((DataResponse<R.Response>) -> Void)?) {
        self.uploadable = uploadable
        self.uploadRequest = request
        self.completionHandler = completionHandler
        super.init(configurable: uploadable, request: request)
    }
    
    override func handleDataResponse(_ response: DefaultDataResponse) {
        let request = self.request as! UploadRequest
        request.response(
            queue: uploadable.queue,
            responseSerializer: uploadable.responseSerializer
        ) { ( response: (DataResponse<R.Response>)) in
            self.completionHandler?(response)
            if let error = response.error {
                self.uploadable.request(self, didFailWithError: error)
                self.isFinished = true
            } else {
                self.uploadable.request(self, didCompleteWithValue: response.value!)
                self.isFinished = true
            }
        }
    }
    
    /// Creates a copy of self
    open override func copy() -> AOperation<R> {
        return UploadOperation(
            uploadable: uploadable,
            request: uploadRequest,
            completionHandler: completionHandler
        )
    }
    
}
