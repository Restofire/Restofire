//
//  StreamUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public protocol StreamUploadable: Requestable {
    
    /// The stream.
    var stream: InputStream { get }
    
}

public extension StreamUploadable {
    
    /// `.post`
    public var method: HTTPMethod {
        return .post
    }
    
}

public extension StreamUploadable {
    
    public func request() -> UploadRequest {
        return RestofireRequest.streamUploadRequest(fromRequestable: self)
    }
    
}
