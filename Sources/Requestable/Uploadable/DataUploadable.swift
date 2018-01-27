//
//  DataUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public protocol DataUploadable: Requestable {
    
    /// The data.
    var data: Data { get }
    
}

public extension DataUploadable {
    
    /// `.post`
    public var method: HTTPMethod {
        return .post
    }
    
}

public extension DataUploadable {
    
    public func request() -> UploadRequest {
        return Restofire.dataUploadRequest(fromRequestable: self)
    }
    
}
