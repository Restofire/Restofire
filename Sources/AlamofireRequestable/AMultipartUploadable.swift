//
//  MultipartUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public protocol AMultipartUploadable: _AUploadable {
    
    /// The multipart form data.
    var multipartFormData: (MultipartFormData) -> Void { get }
    
    /// The threashold.
    var threshold: UInt64 { get }

}

extension AMultipartUploadable {
    
    /// `SessionManager.multipartFormDataEncodingMemoryThreshold`
    public var threshold: UInt64 {
        return SessionManager.multipartFormDataEncodingMemoryThreshold
    }
    
}

public extension AMultipartUploadable {
    
    public func request(encodingCompletion: ((MultipartFormDataEncodingResult) -> Void)? = nil) {
        RestofireRequest.multipartUploadRequest(fromRequestable: self, encodingCompletion: encodingCompletion)
    }
    
}
