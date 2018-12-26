//
//  RequestOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation
import Alamofire

/// An NSOperation that executes the `Requestable` asynchronously.
public class RequestOperation<R: Requestable>: AOperation<R> {
    
    let requestable: R
    let dataRequest: () -> DataRequest
    let completionHandler: ((R.Response?, DataResponse<R.Response>) -> Void)?
    
    /// Intializes an request operation.
    ///
    /// - Parameters:
    ///   - requestable: The `Requestable`.
    ///   - request: The request closure.
    ///   - completionHandler: The async completion handler called
    ///     when the request is completed
    public init(
        requestable: R,
        request: @escaping () -> DataRequest,
        downloadProgressHandler: ((Progress) -> Void)? = nil,
        completionHandler: ((R.Response?, DataResponse<R.Response>) -> Void)?
    ) {
        self.requestable = requestable
        self.dataRequest = request
        self.completionHandler = completionHandler
        super.init(
            requestable: requestable,
            request: request,
            downloadProgressHandler: downloadProgressHandler
        )
    }
    
    override func handleDataResponse(_ response: DataResponse<R.Response>) {
        let request = self.request as! DataRequest
        
        var res = response
        requestable.delegates.forEach {
            res = $0.process(request, requestable: requestable, response: res)
        }
        res = requestable.process(request, requestable: requestable, response: res)
        
        requestable.callbackQueue.async {
            self.completionHandler?(res.value, res)
        }
        
        switch res.result {
        case .success(let value):
            self.requestable.request(self, didCompleteWithValue: value)
        case .failure(let error):
            self.requestable.request(self, didFailWithError: error)
        }
        
        self.isFinished = true
    }
    
    override func dataResponseResult(response: DataResponse<Data?>) -> DataResponse<R.Response> {
        let result = Result { try requestable.responseSerializer
            .serialize(request: response.request,
                       response: response.response,
                       data: response.data,
                       error: response.error) }
        
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
        let operation = RequestOperation(
            requestable: requestable,
            request: dataRequest,
            completionHandler: completionHandler
        )
        operation.queuePriority = requestable.priority
        return operation
    }
    
}
