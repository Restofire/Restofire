//
//  RequestDelegate.swift
//  Restofire
//
//  Created by Rahul Katariya on 05/02/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// Represents a `RequestDelegate` that is associated with `Requestable`.
public protocol RequestDelegate {
    
    /// Called to modify a request before sending.
    func prepare(_ request: URLRequest, requestable: _Requestable) -> URLRequest
    
    /// Called before the request is sent over the network.
    func willSend(dataRequest: inout DataRequest, requestable: _Requestable)
    
    /// Called before the request is sent over the network.
    func willSend(downloadRequest: inout DownloadRequest, requestable: _Requestable)
    
    /// Called before the request is sent over the network.
    func willSend(uploadRequest: inout UploadRequest, requestable: _Requestable)
    
    /// Called when the request is sent over the network.
    func didSend(_ request: Request, requestable: _Requestable)
    
    /// Called before the request calls its completion handler.
    func process<R: Requestable>(_ request: Request, requestable: R, response: DataResponse<R.Response>) -> DataResponse<R.Response>
    
    /// Called before the request calls its completion handler.
    func process<R: Downloadable>(_ request: Request, requestable: R, response: DownloadResponse<R.Response>) -> DownloadResponse<R.Response>
    
    /// Called before the request calls its completion handler.
    func process<R: Uploadable>(_ request: Request, requestable: R, response: DataResponse<R.Response>) -> DataResponse<R.Response>
    
}

extension RequestDelegate {

    /// `No-op`
    public func prepare(_ request: URLRequest, requestable: _Requestable) -> URLRequest {
        return request
    }

    /// `No-op`
    func willSend(dataRequest: inout DataRequest, requestable: _Requestable) {}
    
    /// `No-op`
    func willSend(downloadRequest: inout DownloadRequest, requestable: _Requestable) {}
    
    /// `No-op`
    func willSend(uploadRequest: inout UploadRequest, requestable: _Requestable) {}
    
    /// `No-op`
    public func didSend(_ request: Request, requestable: _Requestable) {}
    
    /// `No-op`
    public func process<R: Requestable>(_ request: Request, requestable: R, response: DataResponse<R.Response>) -> DataResponse<R.Response> {
        return response
    }
    
    /// `No-op`
    public func process<R: Downloadable>(_ request: Request, requestable: R, response: DownloadResponse<R.Response>) -> DownloadResponse<R.Response> {
        return response
    }
    
    /// `No-op`
    public func process<R: Uploadable>(_ request: Request, requestable: R, response: DataResponse<R.Response>) -> DataResponse<R.Response> {
        return response
    }
    
}
