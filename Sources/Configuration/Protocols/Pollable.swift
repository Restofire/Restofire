//
//  Pollable.swift
//  Restofire
//
//  Created by RahulKatariya on 09/12/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation

/// Represents a `Pollable` that is associated with `Requestable`.
public protocol Pollable {
    
    /// The `poll`.
    var poll: Poll { get }
    
    /// Called to check if it requires retry even if the request succeeded.
    func shouldPoll<R: BaseRequestable>(_ request: Request, requestable: R, response: DataResponse<R.Response>) -> Bool
    
    /// Called to check if it requires retry even if the request succeeded.
    func shouldPoll<R: BaseRequestable>(_ request: Request, requestable: R, response: DownloadResponse<R.Response>) -> Bool
    
}

extension Pollable where Self: Configurable {
    
    /// `Poll.default`
    public var poll: Poll {
        return Poll.default
    }
    
    /// `false`
    public func shouldPoll<R: BaseRequestable>(_ request: Request, requestable: R, response: DataResponse<R.Response>) -> Bool {
        return false
    }
    
    /// `false`
    public func shouldPoll<R: BaseRequestable>(_ request: Request, requestable: R, response: DownloadResponse<R.Response>) -> Bool {
        return false
    }
    
}
