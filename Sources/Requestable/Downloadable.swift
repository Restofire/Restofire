//
//  Downloadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public protocol Downloadable: RequestableBase {
    
    var destination: DownloadFileDestination? { get }
    
}

public extension Downloadable {
    
    public var destination: DownloadFileDestination? {
        return nil
    }
    
}

public extension Downloadable {
    
    @discardableResult
    public func execute(_ completionHandler: @escaping ((DefaultDownloadResponse) -> Void)) -> DownloadRequest {
        let request = Restofire.downloadRequest(fromRequestable: self)
        request.response(completionHandler: completionHandler)
        return request
    }
    
}
