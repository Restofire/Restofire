//
//  JSONEncoding+Alamofire.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation

/// A type used to define how a set of array parameters are applied to a `URLRequest`.
public protocol ArrayParameterEncoding {
    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `AFError.parameterEncodingFailed` error if encoding fails.
    ///
    /// - returns: The encoded request.
    func encode(_ urlRequest: URLRequestConvertible, with parameters: [Any]?) throws -> URLRequest
}

/// An extension of Alamofire.JSONEncoding to support [Any] parameters
extension JSONEncoding: ArrayParameterEncoding {
    /// Creates a URL request by encoding array parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `AFError.parameterEncodingFailed` error if encoding fails.
    ///
    /// - returns: The encoded request.
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: [Any]?) throws -> URLRequest {
        return try encode(urlRequest, withJSONObject: parameters)
    }
}
