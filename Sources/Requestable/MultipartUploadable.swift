//
//  MultipartUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 31/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// Represents a `MultipartUploadable` for Restofire.
///
/// ### Create custom MultipartUploadable
/// ```swift
/// protocol HTTPBinUploadService: MultipartUploadable {
///
///     var path: String? = "post"
///     var multipartFormData: (MultipartFormData) -> Void = { multipartFormData in
///         multipartFormData.append("français".data(using: .utf8)!, withName: "french")
///         multipartFormData.append("日本語".data(using: .utf8)!, withName: "japanese")
///     }
///
/// }
/// ```
public protocol MultipartUploadable: AMultipartUploadable, Uploadable {}

public extension MultipartUploadable {
    
    /// Use response(request: UploadRequest, completionHandler:
    /// ((DataResponse<Response>) -> Void)? = nil) method for MultipartUpload instead
    public func response(_ completionHandler: ((DataResponse<Response>) -> Void)?) -> UploadOperation<Self> {
        fatalError("Use response(request: UploadRequest, completionHandler: ((DataResponse<Response>) -> Void)? = nil) method for MultipartUpload instead")
    }
    
    /// Creates a `UploadOperation` for the specified `Uploadable` object and
    /// asynchronously executes it.
    ///
    /// - parameter request: An `Alamofire.UploadRequest`.
    /// - parameter completionHandler: A closure to be executed once the download
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `UploadOperation`.
    @discardableResult
    public func response(request: UploadRequest, completionHandler: ((DataResponse<Response>) -> Void)? = nil) -> UploadOperation<Self> {
        let uploadOperation = UploadOperation(uploadable: self, request: request, completionHandler: completionHandler)
        uploadOperation.start()
        return uploadOperation
    }
    
}

