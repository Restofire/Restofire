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
    
    /// `nil`
    public var destination: DownloadFileDestination? {
        return nil
    }

}

public extension Downloadable {
    
    public func request() -> DownloadRequest {
        return Restofire.downloadRequest(fromRequestable: self)
    }
    
}
