//
//  MultipartUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// Represents a `MultipartUploadable` for Alamofire.
///
/// ### Create custom MultipartUploadable
/// ```swift
/// protocol HTTPBinUploadService: MultipartUploadable {
///
///     typealias Response = Data
///
///     var path: String? = "post"
///     var multipartFormData: (MultipartFormData) -> Void = { multipartFormData in
///         multipartFormData.append("français".data(using: .utf8)!, withName: "french")
///         multipartFormData.append("日本語".data(using: .utf8)!, withName: "japanese")
///     }
///
/// }
/// ```
public protocol MultipartUploadable: Uploadable {
    
    /// The multipart form data.
    var multipartFormData: (MultipartFormData) -> Void { get }
    
    /// The encoding memory threashold.
    var encodingMemoryThreshold: UInt64 { get }

}

extension MultipartUploadable {
    
    /// `SessionManager.multipartFormDataEncodingMemoryThreshold`
    public var encodingMemoryThreshold: UInt64 {
        return MultipartUpload.encodingMemoryThreshold
    }
    
}

public extension MultipartUploadable {
    
    /// Creates a `UploadRequest` to retrieve the contents of a URL based on the specified `Requestable`
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - returns: The created `UploadRequest`.
    func asRequest() throws -> UploadRequest {
        return RestofireRequest.multipartUploadRequest(
            fromRequestable: self,
            withUrlRequest: try asUrlRequest()
        )
    }
    
}
