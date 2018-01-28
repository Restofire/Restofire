//
//  FileUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public protocol AFileUploadable: ARequestable {
    
    /// The url.
    var url: URL { get }
    
}

extension AFileUploadable {
    
    /// `.post`
    public var method: HTTPMethod {
        return .post
    }
    
}

public extension AFileUploadable {
    
    public func request() -> UploadRequest {
        return RestofireRequest.fileUploadRequest(fromRequestable: self)
    }
    
}
