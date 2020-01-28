//
//  Requestable.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 Restofire. All rights reserved.
//

import Foundation

/// Represents an abstract `BaseRequestable`.
///
/// Instead implement Requestable, Downloadable, FileUploadable, DataUploadable, StreamUploadable,
/// MultipartUplodable protocols.
public protocol BaseRequestable: Configurable, ResponseSerializable {
    /// The path relative to base URL.
    var path: String? { get }
}

extension BaseRequestable {
    /// `nil`
    public var path: String? {
        return nil
    }
}

extension BaseRequestable {
    func asUrlRequest(parameters: Any? = nil) throws -> URLRequest {
        let parametersType = ParametersType<EmptyCodable>.any(parameters)
        return try asUrlRequest(parametersType: parametersType)
    }

    func asUrlRequest<T: Encodable>(parameters: T) throws -> URLRequest {
        let parametersType = ParametersType<T>.encodable(parameters)
        return try asUrlRequest(parametersType: parametersType)
    }

    /// Creates a `URLRequest` to retrieve the contents of a URL based on the specified `Requestable`
    ///
    /// - returns: The created `URLRequest`.
    func asUrlRequest<T: Encodable>(parametersType: ParametersType<T>) throws -> URLRequest {
        let url = scheme + "://" + [host, version, path]
            .compactMap { $0 }
            .joined(separator: "/")

        var allHeaders = headers ?? HTTPHeaders()
        configuration.headers.forEach { (header: HTTPHeader) in
            allHeaders.add(header)
        }
        var request = try URLRequest(url: url, method: method, headers: allHeaders)

        let allQueryParameters = queryParameters + configuration.queryParameters
        request = try URLEncoding.queryString.encode(request, with: allQueryParameters)

        switch parametersType {
        case .any(let parameters):
            if let parameters = parameters as? [String: Any] {
                request = try encoding.encode(request, with: parameters)
            } else if let parameters = parameters as? [Any],
                let encoding = encoding as? ArrayParameterEncoding {
                request = try encoding.encode(request, with: parameters)
            }
        case .encodable(let parameters):
            request = try parameterEncoder.encode(parameters, into: request)
            return request
        }

        return request
    }
}
