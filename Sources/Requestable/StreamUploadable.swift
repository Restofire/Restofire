//
//  StreamUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation

/// Represents a `StreamUploadable` for Alamofire.
///
/// ### Create custom StreamUploadable
/// ```swift
/// protocol HTTPBinUploadService: StreamUploadable {
///
///     typealias Response = Data
///
///     var path: String? = "post"
///     var stream: InputStream = InputStream(url: FileManager.imageURL)!
///
/// }
/// ```
public protocol StreamUploadable: Uploadable {
    
    /// The stream.
    var stream: InputStream { get }

}

public extension StreamUploadable {
    
    /// Creates a `UploadRequest` to retrieve the contents of a URL based on the specified `Requestable`
    ///
    /// - returns: The created `UploadRequest`.
    func asRequest<T: Encodable>(
        parametersType: ParametersType<T>
    ) throws -> () -> UploadRequest {
        let urlRequest = try asUrlRequest(parametersType: parametersType)
        return {
            RestofireRequest.streamUploadRequest(
                fromRequestable: self,
                withUrlRequest: urlRequest
            )
        }
    }
    
}
