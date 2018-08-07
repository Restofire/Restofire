//
//  DownloadOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// An NSOperation that executes the `Downloadable` asynchronously.
public class DownloadOperation<R: Downloadable>: AOperation<R> {
    
    let downloadable: R
    let downloadRequest: () -> DownloadRequest
    let completionHandler: ((DownloadResponse<R.Response>) -> Void)?
    
    /// Intializes an download operation.
    ///
    /// - Parameters:
    ///   - downloadable: The `Downloadable`.
    ///   - request: The request closure.
    ///   - completionHandler: The async completion handler called
    ///     when the request is completed
    public init(downloadable: R, request: @escaping (() -> DownloadRequest), completionHandler: ((DownloadResponse<R.Response>) -> Void)?) {
        self.downloadable = downloadable
        self.downloadRequest = request
        self.completionHandler = completionHandler
        super.init(configurable: downloadable, request: request)
    }
    
    override func handleDownloadResponse(_ response: DownloadResponse<URL?>) {
        let request = self.request as! DownloadRequest
        var res = response
        
        downloadable.delegates.forEach {
            res = $0.process(request, requestable: downloadable, response: res)
        }
        res = downloadable.process(request, requestable: downloadable, response: res)
        
        let result = Result { try downloadable.responseSerializer
            .serializeDownload(request: res.request,
                               response: res.response,
                               fileURL: res.fileURL,
                               error: res.error)
        }
        
        switch result {
        case .success(let value):
            let downloadResponse = DownloadResponse<R.Response>(
                request: res.request,
                response: res.response,
                fileURL: res.fileURL,
                resumeData: res.resumeData,
                metrics: res.metrics,
                serializationDuration: res.serializationDuration,
                result: value
            )
            downloadable.queue.async {
                self.completionHandler?(downloadResponse)
                switch value {
                case .success(let innerValue):
                    self.downloadable.request(self, didCompleteWithValue: innerValue)
                case .failure(let error):
                    self.downloadable.request(self, didFailWithError: error)
                }
                self.isFinished = true
            }
        case .failure(let error):
            let downloadResponse = DownloadResponse<R.Response>(
                request: res.request,
                response: res.response,
                fileURL: res.fileURL,
                resumeData: res.resumeData,
                metrics: res.metrics,
                serializationDuration: res.serializationDuration,
                result: Result<R.Response>.failure(error)
            )
            downloadable.queue.async {
                self.completionHandler?(downloadResponse)
                self.downloadable.request(self, didFailWithError: error)
                self.isFinished = true
            }
        }
    }
    
    /// Creates a copy of self
    open override func copy() -> AOperation<R> {
        return DownloadOperation(
            downloadable: downloadable,
            request: downloadRequest,
            completionHandler: completionHandler
        )
    }
    
}
