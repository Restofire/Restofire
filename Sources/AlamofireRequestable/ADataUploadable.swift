//
//  DataUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public protocol ADataUploadable: _AUploadable {
    
    /// The data.
    var data: Data { get }
    
}

public extension ADataUploadable {
    
    public func request() -> UploadRequest {
        return RestofireRequest.dataUploadRequest(fromRequestable: self)
    }
    
}
