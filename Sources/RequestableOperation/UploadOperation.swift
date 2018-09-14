//
//  UploadOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

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
    
    override func handleDataResponse(_ response: DataResponse<Data?>) {
        let request = self.request as! UploadRequest
        
        var res = response
        uploadable.delegates.forEach {
            res = $0.process(request, requestable: uploadable, response: res)
        }
        res = uploadable.process(request, requestable: uploadable, response: res)
        
        let result = Result { try uploadable.responseSerializer
            .serialize(request: res.request,
                       response: res.response,
                       data: res.data,
                       error: res.error)
        }
        
        let dataResponse = DataResponse<R.Response>(
            request: res.request,
            response: res.response,
            data: res.data,
            metrics: res.metrics,
            serializationDuration: res.serializationDuration,
            result: result.value!
        )
        
        uploadable.queue.async {
            self.completionHandler?(dataResponse)
        }
        
        if let error = res.error {
            self.uploadable.request(self, didFailWithError: error)
        } else {
            self.uploadable.request(self, didCompleteWithValue: dataResponse.value!)
        }
        self.isFinished = true
        
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
