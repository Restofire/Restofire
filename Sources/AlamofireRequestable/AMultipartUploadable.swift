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
    
    /// Use request(encodingCompletion:) method for MultipartUpload instead
    public func request() -> DataRequest {
        fatalError("Use request(encodingCompletion:((MultipartFormDataEncodingResult) -> Void)) method for MultipartUpload instead")
    }
    
    /// Encodes `multipartFormData` using `encodingMemoryThreshold` and calls `encodingCompletion` with new
    /// `UploadRequest` using the `uploadable`.
    public func response(encodingCompletion: ((MultipartFormDataEncodingResult) -> Void)? = nil) {
        RestofireRequest.multipartUploadRequest(fromRequestable: self, encodingCompletion: encodingCompletion)
    }
    
}
