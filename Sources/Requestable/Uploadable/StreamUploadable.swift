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
    
    @discardableResult
    public func execute(_ completionHandler: @escaping ((DefaultDataResponse) -> Void)) -> UploadRequest {
        let request = Restofire.streamUploadRequest(fromRequestable: self)
        request.response(completionHandler: completionHandler)
        return request
    }
    
}
