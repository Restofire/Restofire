//
//  Downloadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public protocol ADownloadable: _Requestable, AConfigurable {
    
    var destination: DownloadFileDestination? { get }
    
    /// The Alamofire data request validation.
    var validationBlock: DownloadRequest.Validation? { get }
}

public extension ADownloadable {
    
    /// `nil`
    public var destination: DownloadFileDestination? {
        return nil
    }
    
    /// `configuration.downloadValidation`
    public var validationBlock: DownloadRequest.Validation? {
        return validation.downloadValidation
    }
    
}

public extension ADownloadable {
    
    public func request() -> DownloadRequest {
        return RestofireRequest.downloadRequest(fromRequestable: self)
    }
    
}
