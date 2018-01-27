//
//  MultipartUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public protocol MultipartUploadable: Requestable {
    
    /// The multipart form data.
    var multipartFormData: (MultipartFormData) -> Void { get }
    
    /// The threashold.
    var threshold: UInt64 { get }
    
    /// The encoding completion
    var encodingCompletion: ((MultipartFormDataEncodingResult) -> Void)? { get }
    
}

extension MultipartUploadable {
    
    /// `.post`
    public var method: HTTPMethod {
        return .post
    }
    
    /// `SessionManager.multipartFormDataEncodingMemoryThreshold`
    public var threshold: UInt64 {
        return SessionManager.multipartFormDataEncodingMemoryThreshold
    }
    
    /// `nil`
    public var encodingCompletion: ((MultipartFormDataEncodingResult) -> Void)? {
        return nil
    }
    
}

public extension MultipartUploadable {
    
    public func request(encodingCompletion: ((MultipartFormDataEncodingResult) -> Void)? = nil) {
        RestofireRequest.multipartUploadRequest(fromRequestable: self, encodingCompletion: encodingCompletion)
    }
    
}
