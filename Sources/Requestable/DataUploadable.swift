//
//  DataUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// Represents a `DataUploadable` for Alamofire.
///
/// ### Create custom DataUploadable
/// ```swift
/// protocol HTTPBinUploadService: DataUploadable {
///
///     typealias Response = Data
///
///     var path: String? = "post"
///     var data: Data = {
///         return "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
///            .data(using: .utf8, allowLossyConversion: false)!
///     }()
///
/// }
/// ```
public protocol DataUploadable: Uploadable {
    
    /// The data.
    var data: Data { get }
    
}

public extension DataUploadable {
    
    /// Creates a `UploadRequest` to retrieve the contents of a URL based on the specified `Requestable`
    ///
    /// - returns: The created `UploadRequest`.
    func asRequest() throws -> UploadRequest {
        return RestofireRequest.dataUploadRequest(
            fromRequestable: self,
            withUrlRequest: try asUrlRequest()
        )
    }
    
}
