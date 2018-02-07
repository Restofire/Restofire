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
    func prepare(_ request: URLRequest, requestable: Configurable) -> URLRequest
    
    /// Called when the request is sent over the network.
    func didSend(_ request: Request, requestable: Configurable)
    
}

extension RequestDelegate {
    
    /// `No-op`
    public func prepare(_ request: URLRequest, requestable: Configurable) -> URLRequest {
        return request
    }
    
    /// `No-op`
    public func didSend(_ request: Request, requestable: Configurable) {}
    
}
