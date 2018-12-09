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
        
        let dataResponse = responseResult(response: response)
        
        uploadable.callbackQueue.async {
            self.completionHandler?(dataResponse)
        }
        
        switch dataResponse.result {
        case .success(let value):
            self.uploadable.request(self, didCompleteWithValue: value)
        case .failure(let error):
            self.uploadable.request(self, didFailWithError: error)
        }
        
        self.isFinished = true
    }
    
    func responseResult(response: DataResponse<Data?>) -> DataResponse<R.Response> {
        let result = Result { try uploadable.responseSerializer
            .serialize(request: response.request,
                       response: response.response,
                       data: response.data,
                       error: response.error)
        }
        
        var responseResult: Result<R.Response>!
        
        switch result {
        case .success(let value):
            responseResult = value
        case .failure(let error):
            assertionFailure(error.localizedDescription)
            responseResult = Result.failure(error)
        }
        
        let dataResponse = DataResponse<R.Response>(
            request: response.request,
            response: response.response,
            data: response.data,
            metrics: response.metrics,
            serializationDuration: response.serializationDuration,
            result: responseResult
        )
        return dataResponse
    }
    
    /// Creates a copy of self
    open override func copy() -> AOperation<R> {
        let operation = UploadOperation(
            uploadable: uploadable,
            request: uploadRequest,
            completionHandler: completionHandler
        )
        operation.queuePriority = uploadable.priority
        return operation
    }
    
}
