//
//  RequestableBase.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

public protocol RequestableBase: Authenticable, Configurable, ResponseSerializable, Retryable, SessionManagable, Queueable {
    
    /// The scheme.
    var scheme: String { get }
    
    /// The base URL.
    var baseURL: String { get }
    
    /// The version.
    var version: String? { get }
    
    /// The path relative to base URL.
    var path: String { get }
    
    /// The url request parameters.
    var queryParameters: [String: Any]? { get }
    
    /// The HTTP Method.
    var method: HTTPMethod { get }
    
    /// The request parameter encoding.
    var encoding: ParameterEncoding { get }
    
    /// The HTTP headers.
    var headers: [String : String]? { get }
    
    /// The request parameters.
    var parameters: Any? { get }
    
    /// The Alamofire Session Manager.
    var sessionManager: SessionManager { get }
    
    /// The queue on which reponse will be delivered.
    var queue: DispatchQueue? { get }
    
    /// The credential.
    var credential: URLCredential? { get }
    
    /// The retry error codes.
    var retryErrorCodes: Set<URLError.Code> { get }
    
    /// The retry interval.
    var retryInterval: TimeInterval { get }
    
    /// The max retry attempts.
    var maxRetryAttempts: Int { get }
    
}

// MARK: - Default Implementation
public extension RequestableBase {
    
    /// `configuration.scheme`
    public var scheme: String {
        return configuration.scheme
    }
    
    /// `configuration.BaseURL`
    public var baseURL: String {
        return configuration.baseURL
    }
    
    /// `configuration.version`
    public var version: String? {
        return configuration.version
    }
    
    /// `nil`
    public var queryParameters: [String: Any]? {
        return nil
    }
    
    /// `configuration.method`
    public var method: HTTPMethod {
        return configuration.method
    }
    
    /// `configuration.encoding`
    public var encoding: ParameterEncoding {
        return configuration.encoding
    }
    
    /// `nil`
    public var headers: [String: String]? {
        return nil
    }
    
    /// `nil`
    public var parameters: Any? {
        return nil
    }
    
    /// `configuration.sessionManager`
    public var sessionManager: SessionManager {
        return configuration.sessionManager
    }
    
    /// `configuration.queue`
    public var queue: DispatchQueue? {
        return configuration.queue
    }
    
    /// `authentication.credential`
    public var credential: URLCredential? {
        return authentication.credential
    }
    
    /// `retry.retryErrorCodes`
    public var retryErrorCodes: Set<URLError.Code> {
        return retry.retryErrorCodes
    }
    
    /// `retry.retryInterval`
    public var retryInterval: TimeInterval {
        return retry.retryInterval
    }
    
    /// `retry.maxRetryAttempts`
    public var maxRetryAttempts: Int {
        return retry.maxRetryAttempts
    }
    
}

// MARK: - URL Request
public extension RequestableBase {
    
    public func asUrlRequest() -> URLRequest? {
        let url = [scheme + baseURL, version, path]
            .flatMap { $0 }
            .joined(separator: "/")
        
        let allHeaders = headers + configuration.headers
        var request = try! URLRequest(url: url, method: method, headers: allHeaders)
        
        let allQueryParameters = queryParameters + configuration.queryParameters
        request = try! URLEncoding.queryString.encode(request, with: allQueryParameters)
        
        if let parameters = parameters as? [String: Any] {
            request = try! encoding.encode(request, with: parameters)
        } else if let parameters = parameters as? [Any],
            let encoding = encoding as? ArrayParameterEncoding {
            request = try! encoding.encode(request, with: parameters)
        }
        return request
    }
    
}

