//
//  Requestable.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// Represents a `Requestable` for Alamofire.
///
/// ### Create custom Requestable
/// ```swift
/// protocol HTTPBinGETService: ARequestable {
///
///     var path: String? = "get"
///
/// }
/// ```
public protocol ARequestable: _Requestable, Configurable {
    
    /// The Alamofire data request validation.
    var validationBlock: DataRequest.Validation? { get }

}

public extension ARequestable {
    
    /// `Validation.default.dataValidation`
    public var validationBlock: DataRequest.Validation? {
        return validation.dataValidation
    }
    
}

public extension ARequestable {
    
    /// Creates a `DataRequest` to retrieve the contents of a URL based on the specified `Requestable`
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - returns: The created `DataRequest`.
    public var request: DataRequest {
        return RestofireRequest.dataRequest(fromRequestable: self, withUrlRequest: urlRequest)
    }
    
}
