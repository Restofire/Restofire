//
//  StreamUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public protocol AStreamUploadable: ARequestable {
    
    /// The stream.
    var stream: InputStream { get }
    
}

public extension AStreamUploadable {
    
    /// `.post`
    public var method: HTTPMethod {
        return .post
    }
    
}

public extension AStreamUploadable {
    
    public func request() -> UploadRequest {
        return RestofireRequest.streamUploadRequest(fromRequestable: self)
    }
    
}
