//
//  RequestDelegate.swift
//  Restofire
//
//  Created by Rahul Katariya on 05/02/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// Represents a `RequestDelegate` that is associated with `Requestable`.
public protocol RequestDelegate {
    
    /// Called to modify a request before sending.
    func prepare(_ request: URLRequest, requestable: AConfigurable) -> URLRequest
    
    /// Called when the request is sent over the network.
    func didSend(_ request: Request, requestable: AConfigurable)
    
    /// Called when the request is completed.
    func didComplete(_ request: Request, requestable: AConfigurable)
    
}

extension RequestDelegate {
    
    /// `No-op`
    func prepare(_ request: URLRequest, requestable: AConfigurable) -> URLRequest {
        return request
    }
    
    /// `No-op`
    public func didSend(_ request: Request, requestable: AConfigurable) {}
    
    /// `No-op`
    public func didComplete(_ request: Request, requestable: AConfigurable) {}
    
}
