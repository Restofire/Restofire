//
//  UploadOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// An NSOperation that executes the `Uploadable` asynchronously
/// or when added to a NSOperationQueue
public class UploadOperation<R: Uploadable>: AOperation<R> {
    
    let uploadable: R
    let completionHandler: ((DataResponse<R.Response>) -> Void)?
    
    init(uploadable: R, request: UploadRequest, completionHandler: ((DataResponse<R.Response>) -> Void)?) {
        self.uploadable = uploadable
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
                self.uploadable.request(request, didFailWithError: error)
            } else {
                self.uploadable.request(request, didCompleteWithValue: response.value!)
            }
        }
        super.handleDataResponse(response)
    }
    
}
