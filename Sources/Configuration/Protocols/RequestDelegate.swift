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
    
    /// Called before the request is transformed to `Requestable`.Response.
    func process(_ request: Request, requestable: ARequestable, response: DataResponse<Data?>) -> DataResponse<Data?>
    
    /// Called before the request is transformed to `Downloadable`.Response.
    func process(_ request: Request, requestable: ADownloadable, response: DownloadResponse<URL?>) -> DownloadResponse<URL?>
    
}

extension RequestDelegate {

    /// `No-op`
    public func prepare(_ request: URLRequest, requestable: ARequestable) -> URLRequest {
        return request
    }

    /// `No-op`
    public func didSend(_ request: Request, requestable: ARequestable) {}
    
    /// `No-op`
    public func process(_ request: Request, requestable: ARequestable, response: DataResponse<Data?>) -> DataResponse<Data?> {
        return response
    }

    /// `No-op`
    public func process(_ request: Request, requestable: ADownloadable, response: DownloadResponse<URL?>) -> DownloadResponse<URL?> {
        return response
    }
}
