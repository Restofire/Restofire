//
//  MultipartUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// Represents a `MultipartUploadable` for Alamofire.
///
/// ### Create custom MultipartUploadable
/// ```swift
/// protocol HTTPBinUploadService: AMultipartUploadable {
///
///     var path: String? = "post"
///     var multipartFormData: (MultipartFormData) -> Void = { multipartFormData in
///         multipartFormData.append("français".data(using: .utf8)!, withName: "french")
///         multipartFormData.append("日本語".data(using: .utf8)!, withName: "japanese")
///     }
///
/// }
/// ```
public protocol AMultipartUploadable: _AUploadable {
    
    /// The multipart form data.
    var multipartFormData: (MultipartFormData) -> Void { get }
    
    /// The encoding memory threashold.
    var encodingMemoryThreshold: UInt64 { get }

}

extension AMultipartUploadable {
    
    /// `SessionManager.multipartFormDataEncodingMemoryThreshold`
    public var encodingMemoryThreshold: UInt64 {
        return SessionManager.multipartFormDataEncodingMemoryThreshold
    }
    
}

extension AMultipartUploadable {
    
    /// Use request(encodingCompletion:) method for MultipartUpload instead
    public var request: UploadRequest {
        fatalError("Use request(encodingCompletion:((RFMultipartFormDataEncodingResult) -> Void)) method for MultipartUpload instead")
    }
    
    /// Encodes `multipartFormData` using `encodingMemoryThreshold` and calls `encodingCompletion` with new
    /// `UploadRequest` using the `uploadable`.
    public func request(encodingCompletion: ((RFMultipartFormDataEncodingResult) -> Void)? = nil) {
        RestofireRequest.multipartUploadRequest(fromRequestable: self, withUrlRequest: urlRequest, encodingCompletion: encodingCompletion)
    }
    
}
