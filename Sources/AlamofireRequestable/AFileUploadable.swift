//
//  FileUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public protocol AFileUploadable: _AUploadable {
    
    /// The url.
    var url: URL { get }
    
}

public extension AFileUploadable {
    
    public func request() -> UploadRequest {
        return RestofireRequest.fileUploadRequest(fromRequestable: self)
    }
    
}
