//
//  RequestOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// An NSOperation that executes the `Requestable` asynchronously.
public class RequestOperation<R: Requestable>: AOperation<R> {
    
    let requestable: R
    let dataRequest: () -> DataRequest
    let completionHandler: ((DataResponse<R.Response>) -> Void)?
    
    /// Intializes an request operation.
    ///
    /// - Parameters:
    ///   - requestable: The `Requestable`.
    ///   - request: The request closure.
    ///   - completionHandler: The async completion handler called
    ///     when the request is completed
    public init(requestable: R, request: @escaping () -> DataRequest, completionHandler: ((DataResponse<R.Response>) -> Void)?) {
        self.requestable = requestable
        self.dataRequest = request
        self.completionHandler = completionHandler
        super.init(configurable: requestable, request: request)
    }
    
    override func handleDataResponse(_ response: DataResponse<Data?>) {
        let request = self.request as! DataRequest
        
        var res = response
        requestable.delegates.forEach {
            res = $0.process(request, requestable: requestable, response: res)
        }
        res = requestable.process(request, requestable: requestable, response: res)
        
        let result = Result { try requestable.responseSerializer
            .serialize(request: res.request,
                       response: res.response,
                       data: res.data,
                       error: res.error) }
        
        let dataResponse = DataResponse<R.Response>(
            request: res.request,
            response: res.response,
            data: res.data,
            metrics: res.metrics,
            serializationDuration: res.serializationDuration,
            result: result.value!
        )
        
        requestable.queue.async {
            self.completionHandler?(dataResponse)
        }
        
        if let error = res.error {
            self.requestable.request(self, didFailWithError: error)
        } else {
            self.requestable.request(self, didCompleteWithValue: dataResponse.value!)
        }
        
        self.isFinished = true
    }
    
    /// Creates a copy of self
    open override func copy() -> AOperation<R> {
        return RequestOperation(
            requestable: requestable,
            request: dataRequest,
            completionHandler: completionHandler
        )
    }
    
}
