//
//  UploadOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation

/// An NSOperation that executes the `Uploadable` asynchronously.
public class UploadOperation<R: Uploadable>: NetworkOperation<R> {
    let uploadable: R
    let uploadRequest: () -> UploadRequest
    let completionQueue: DispatchQueue
    let completionHandler: ((DataResponse<R.Response>) -> Void)?

    /// Intializes an upload operation.
    ///
    /// - Parameters:
    ///   - uploadable: The `Uploadable`.
    ///   - request: The request closure.
    ///   - completionHandler: The async completion handler called
    ///     when the request is completed
    public init(
        uploadable: R,
        request: @escaping () -> UploadRequest,
        uploadProgressHandler: ((Progress) -> Void, queue: DispatchQueue?)? = nil,
        completionQueue: DispatchQueue,
        completionHandler: ((DataResponse<R.Response>) -> Void)?
    ) {
        self.uploadable = uploadable
        self.uploadRequest = request
        self.completionQueue = completionQueue
        self.completionHandler = completionHandler
        super.init(
            requestable: uploadable,
            request: request,
            uploadProgressHandler: uploadProgressHandler
        )
    }

    override func handleDataResponse(_ response: DataResponse<R.Response>) {
        let request = self.request as! UploadRequest

        var res = response
        uploadable.delegates.forEach {
            res = $0.process(request, requestable: uploadable, response: res)
        }
        res = uploadable.process(request, requestable: uploadable, response: res)

        completionQueue.async {
            self.completionHandler?(res)
        }

        switch res.result {
        case .success(let value):
            self.uploadable.request(self, didCompleteWithValue: value)
        case .failure(let error):
            self.uploadable.request(self, didFailWithError: error)
        }

        self.isFinished = true
    }

    override func dataResponseResult(response: DataResponse<Data?>) -> DataResponse<R.Response> {
        let result = Result<R.Response, RFError>.serialize { try uploadable.responseSerializer
            .serialize(
                request: response.request,
                response: response.response,
                data: response.data,
                error: response.error
            )
        }

        var responseResult: RFResult<R.Response>!

        switch result {
        case .success(let value):
            responseResult = value
        case .failure(let error):
            assertionFailure(error.localizedDescription)
            responseResult = RFResult<R.Response>.failure(error)
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
    open override func copy() -> NetworkOperation<R> {
        let operation = UploadOperation(
            uploadable: uploadable,
            request: uploadRequest,
            completionQueue: completionQueue,
            completionHandler: completionHandler
        )
        return operation
    }
}
