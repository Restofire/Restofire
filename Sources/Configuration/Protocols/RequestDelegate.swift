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
    func prepare(_ request: URLRequest, requestable: ARequestable) -> URLRequest
    
    /// Called when the request is sent over the network.
    func didSend(_ request: Request, requestable: ARequestable)
    
    /// Called before the request calls its completion handler.
    func process<R: ARequestable & ResponseSerializable>(_ request: Request, requestable: R, response: DataResponse<R.Response>) -> DataResponse<R.Response>
    
    /// Called before the request calls its completion handler.
    func process<R: ADownloadable & ResponseSerializable>(_ request: Request, requestable: R, response: DownloadResponse<R.Response>) -> DownloadResponse<R.Response>
    
}

extension RequestDelegate {

    /// `No-op`
    public func prepare(_ request: URLRequest, requestable: ARequestable) -> URLRequest {
        return request
    }

    /// `No-op`
    public func didSend(_ request: Request, requestable: ARequestable) {}
    
    /// `No-op`
    public func process<R: ARequestable & ResponseSerializable>(_ request: Request, requestable: R, response: DataResponse<R.Response>) -> DataResponse<R.Response> {
        return response
    }
    
    /// `No-op`
    public func process<R: ADownloadable & ResponseSerializable>(_ request: Request, requestable: R, response: DownloadResponse<R.Response>) -> DownloadResponse<R.Response> {
        return response
    }
}
