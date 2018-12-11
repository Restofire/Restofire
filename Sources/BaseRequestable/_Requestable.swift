//
//  Requestable.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 Restofire. All rights reserved.
//

import Foundation
import Alamofire

/// Represents an abstract `_Requestable`.
///
/// Instead implement Requestable, Downloadable, FileUploadable, DataUploadable, StreamUploadable,
/// MultipartUplodable protocols.
public protocol _Requestable: Configurable, ResponseSerializable {

    /// The path relative to base URL.
    var path: String? { get }
    
}

public extension _Requestable {
    
    /// `nil`
    public var path: String? {
        return nil
    }
    
}

public extension _Requestable {
    
    /// Creates a `URLRequest` to retrieve the contents of a URL based on the specified `Requestable`
    ///
    /// - returns: The created `URLRequest`.
    func asUrlRequest() throws -> URLRequest {
        let url = [scheme + host, version, path]
            .compactMap { $0 }
            .joined(separator: "/")
        
        var allHeaders = headers ?? HTTPHeaders()
        configuration.headers.forEach { (header: HTTPHeader) in
            allHeaders.add(header)
        }
        var request = try URLRequest(url: url, method: method, headers: allHeaders)
        
        let allQueryParameters = queryParameters + configuration.queryParameters
        request = try URLEncoding.queryString.encode(request, with: allQueryParameters)
        
        if let parameters = parameters as? [String: Any] {
            request = try encoding.encode(request, with: parameters)
        } else if let parameters = parameters as? [Any],
            let encoding = encoding as? ArrayParameterEncoding {
            request = try encoding.encode(request, with: parameters)
        }
        return request
    }
    
}
