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
    
    /// The request delegates
    var delegates: [RequestDelegate]? { get }
    
    /// A delegate method called when the request is created.
    func didStart(_ request: Request)
    
    /// A delegate method called when the request is completed.
    func didComplete(_ request: Request)
    
}

extension RequestDelegate {
    
    /// `nil`
    public var delegates: [RequestDelegate]? {
        return nil
    }
    
    /// `Noop`
    public func didStart(_ request: Request) {}
    
    /// `Noop`
    public func didComplete(_ request: Request) {}
    
}
