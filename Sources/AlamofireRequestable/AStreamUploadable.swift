//
//  StreamUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// Represents a `StreamUploadable` for Alamofire.
///
/// ### Create custom StreamUploadable
/// ```swift
/// protocol HTTPBinUploadService: AStreamUploadable {
///
///     var path: String? = "post"
///     var stream: InputStream = InputStream(url: FileManager.imageURL)!
///
/// }
/// ```
public protocol AStreamUploadable: _AUploadable {
    
    /// The stream.
    var stream: InputStream { get }

}

public extension AStreamUploadable {
    
    /// Creates a `UploadRequest` to retrieve the contents of a URL based on the specified `Requestable`
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - returns: The created `UploadRequest`.
    public func request() -> UploadRequest {
        return RestofireRequest.streamUploadRequest(fromRequestable: self, withUrlRequest: urlRequest)
    }
    
}
