//
//  AnyRequestable.swift
//  Restofire
//
//  Created by Rahul Katariya on 23/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

struct AnyRequestable: Requestable {
    
    private let _baseURL: String
    var baseURL: String {
        return self._baseURL
    }
    
    private let _path: String
    var path: String {
        return self._path
    }
    
    private let _method: Alamofire.Method
    var method: Alamofire.Method {
        return self._method
    }
    
    private let _encoding: Alamofire.ParameterEncoding
    var encoding: Alamofire.ParameterEncoding {
        return self._encoding
    }
    
    private let _headers: [String : String]?
    var headers: [String : String]? {
        return self._headers
    }
    
    private let _parameters: AnyObject?
    var parameters: AnyObject? {
        return self._parameters
    }
    
    private let _credential: NSURLCredential?
    var credential: NSURLCredential? {
        return self._credential
    }
    
    private let _validation: Request.Validation?
    var validation: Request.Validation? {
        return self._validation
    }
    
    private let _acceptableStatusCodes: [Range<Int>]?
    var acceptableStatusCodes: [Range<Int>]? {
        return self._acceptableStatusCodes
    }
    
    private let _acceptableContentTypes: [String]?
    var acceptableContentTypes: [String]? {
        return self._acceptableContentTypes
    }
    
    private let _logging: Bool
    var logging: Bool {
        return self._logging
    }
    
    private let _manager: Alamofire.Manager
    var manager: Alamofire.Manager {
        return self._manager
    }
    
    private let _queue: dispatch_queue_t?
    var queue: dispatch_queue_t? {
        return self._queue
    }
    
    private let _retryErrorCodes: Set<Int>
    var retryErrorCodes: Set<Int> {
        return self._retryErrorCodes
    }
    
    private let _retryInterval: NSTimeInterval
    var retryInterval: NSTimeInterval {
        return self._retryInterval
    }
    
    private let _maxRetryAttempts: Int
    var maxRetryAttempts: Int {
        return self._maxRetryAttempts
    }
    
    init<R: Requestable>(_ requestable: R) {
        _baseURL = requestable.baseURL
        _path = requestable.path
        _method = requestable.method
        _encoding = requestable.encoding
        _headers = requestable.headers
        _parameters = requestable.parameters
        _credential = requestable.credential
        _validation = requestable.validation
        _acceptableStatusCodes = requestable.acceptableStatusCodes
        _acceptableContentTypes = requestable.acceptableContentTypes
        _logging = requestable.logging
        _manager = requestable.manager
        _queue = requestable.queue
        _retryErrorCodes = requestable.retryErrorCodes
        _retryInterval = requestable.retryInterval
        _maxRetryAttempts = requestable.maxRetryAttempts
    }
    
}
