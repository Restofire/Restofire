//
//  MultipartUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation

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
    var multipartFormData: MultipartFormData { get }
    
    /// The encoding memory threashold.
    var encodingMemoryThreshold: UInt64 { get }

}

extension MultipartUploadable {
    
    /// `SessionManager.multipartFormDataEncodingMemoryThreshold`
    public var encodingMemoryThreshold: UInt64 {
        return MultipartFormData.encodingMemoryThreshold
    }
    
}

extension MultipartUploadable {
    
    /// Creates a `UploadRequest` to retrieve the contents of a URL based on the specified `Requestable`
    ///
    /// - returns: The created `UploadRequest`.
    func asRequest<T: Encodable>(
        parametersType: ParametersType<T>
    ) throws -> () -> UploadRequest {
        let urlRequest = try asUrlRequest(parametersType: parametersType)
        return {
            RestofireRequest.multipartUploadRequest(
                fromRequestable: self,
                withUrlRequest: urlRequest
            )
        }
    }
    
}
