//
//  FileUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation

/// Represents a `FileUploadable` for Alamofire.
///
/// ### Create custom FileUploadable
/// ```swift
/// protocol HTTPBinUploadService: FileUploadable {
///
///     typealias Response = Data
///
///     var path: String? = "post"
///     let url: URL = FileManager.url(forResource: "rainbow", withExtension: "jpg")
///
/// }
/// ```
public protocol FileUploadable: Uploadable {
    
    /// The url.
    var url: URL { get }
    
}

public extension FileUploadable {
    
    /// Creates a `UploadRequest` to retrieve the contents of a URL based on the specified `Requestable`
    ///
    /// - returns: The created `UploadRequest`.
    func asRequest() throws -> UploadRequest {
        return RestofireRequest.fileUploadRequest(
            fromRequestable: self,
            withUrlRequest: try asUrlRequest()
        )
    }
    
}
