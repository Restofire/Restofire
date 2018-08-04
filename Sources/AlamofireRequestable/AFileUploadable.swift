//
//  FileUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// Represents a `FileUploadable` for Alamofire.
///
/// ### Create custom FileUploadable
/// ```swift
/// protocol HTTPBinUploadService: AFileUploadable {
///
///     var path: String? = "post"
///     let url: URL = FileManager.url(forResource: "rainbow", withExtension: "jpg")
///
/// }
/// ```
public protocol AFileUploadable: _AUploadable {
    
    /// The url.
    var url: URL { get }
    
}

public extension AFileUploadable {
    
    /// Creates a `UploadRequest` to retrieve the contents of a URL based on the specified `Requestable`
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - returns: The created `UploadRequest`.
    public var request: UploadRequest {
        return RestofireRequest.fileUploadRequest(fromRequestable: self, withUrlRequest: urlRequest)
    }
    
}
