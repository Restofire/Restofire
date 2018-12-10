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
    func prepare<R: _Requestable>(_ request: URLRequest, requestable: R) -> URLRequest
    
    /// Called before the request is sent over the network.
    func willSend<R: Requestable>(_ request: inout DataRequest, requestable: R)
    
    /// Called before the request is sent over the network.
    func willSend<R: Downloadable>(_ request: inout DownloadRequest, requestable: R)
    
    /// Called before the request is sent over the network.
    func willSend<R: Uploadable>(_ request: inout UploadRequest, requestable: R)
    
    /// Called when the request is sent over the network.
    func didSend<R: _Requestable>(_ request: Request, requestable: R)
    
    /// Called before the request calls its completion handler.
    func process<R: Requestable>(_ request: Request, requestable: R, response: DataResponse<R.Response>) -> DataResponse<R.Response>
    
    /// Called before the request calls its completion handler.
    func process<R: Downloadable>(_ request: Request, requestable: R, response: DownloadResponse<R.Response>) -> DownloadResponse<R.Response>
    
    /// Called before the request calls its completion handler.
    func process<R: Uploadable>(_ request: Request, requestable: R, response: DataResponse<R.Response>) -> DataResponse<R.Response>
    
}

extension RequestDelegate {

    /// `No-op`
    public func prepare<R: _Requestable>(_ request: URLRequest, requestable: R) -> URLRequest {
        return request
    }

    /// `No-op`
    func willSend<R: Requestable>(_ request: inout DataRequest, requestable: R) {}
    
    /// `No-op`
    func willSend<R: Downloadable>(_ request: inout DownloadRequest, requestable: R) {}
    
    /// `No-op`
    func willSend<R: Uploadable>(_ request: inout UploadRequest, requestable: R) {}
    
    /// `No-op`
    public func didSend<R: _Requestable>(_ request: Request, requestable: R) {}
    
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
