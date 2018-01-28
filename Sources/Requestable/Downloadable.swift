//
//  Downloadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public protocol Downloadable: _Requestable {
    
    var destination: DownloadFileDestination? { get }
    
    /// The Alamofire data request validation.
    var validationBlock: DownloadRequest.Validation? { get }
}

public extension Downloadable {
    
    /// `nil`
    public var destination: DownloadFileDestination? {
        return nil
    }
    
    /// `configuration.downloadValidation`
    public var validationBlock: DownloadRequest.Validation? {
        return configuration.downloadValidation
    }
    
}

public extension Downloadable {
    
    public func request() -> DownloadRequest {
        return RestofireRequest.downloadRequest(fromRequestable: self)
    }
    
}
