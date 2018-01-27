//
//  FileUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public protocol FileUploadable: Requestable {
    
    /// The url.
    var url: URL { get }
    
}

extension FileUploadable {
    
    /// `.post`
    public var method: HTTPMethod {
        return .post
    }
}

public extension FileUploadable {
    
    @discardableResult
    public func execute(_ completionHandler: @escaping ((DefaultDataResponse) -> Void)) -> UploadRequest {
        let request = Restofire.fileUploadRequest(fromRequestable: self)
        request.response(completionHandler: completionHandler)
        return request
    }
    
}
