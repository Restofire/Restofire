//
//  DataUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// Represents a `DataUploadable` for Alamofire.
///
/// ### Create custom DataUploadable
/// ```swift
/// protocol HTTPBinUploadService: ADataUploadable {
///
///     var path: String? = "post"
///     var data: Data = {
///         return "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
///            .data(using: .utf8, allowLossyConversion: false)!
///     }()
///
/// }
/// ```
public protocol ADataUploadable: _AUploadable {
    
    /// The data.
    var data: Data { get }
    
}

public extension ADataUploadable {
    
    /// Creates a `UploadRequest` to retrieve the contents of a URL based on the specified `Requestable`
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - returns: The created `UploadRequest`.
    public func request() -> UploadRequest {
        return RestofireRequest.dataUploadRequest(fromRequestable: self)
    }
    
}
