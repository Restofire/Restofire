//
//  TypeAliases.swift
//  Restofire
//
//  Created by Rahul Katariya on 02/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//
import Alamofire

public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias HTTPHeader = Alamofire.HTTPHeader
public typealias HTTPHeaders = Alamofire.HTTPHeaders
public typealias URLRequestConvertible = Alamofire.URLRequestConvertible

// Encoder
public typealias ParameterEncoder = Alamofire.ParameterEncoder
public typealias JSONParameterEncoder = Alamofire.JSONParameterEncoder
public typealias URLEncodedFormParameterEncoder = Alamofire.URLEncodedFormParameterEncoder

// Encoding
public typealias ParameterEncoding = Alamofire.ParameterEncoding
public typealias JSONEncoding = Alamofire.JSONEncoding
public typealias URLEncoding = Alamofire.URLEncoding

// Request
public typealias Request = Alamofire.Request
public typealias DataRequest = Alamofire.DataRequest
public typealias DownloadRequest = Alamofire.DownloadRequest
public typealias UploadRequest = Alamofire.UploadRequest

// Response
public typealias DataResponse = Alamofire.DataResponse
public typealias DownloadResponse = Alamofire.DownloadResponse

// Features
public typealias Session = Alamofire.Session
public typealias DataResponseSerializer = Alamofire.DataResponseSerializer
//public typealias MultipartUpload = Alamofire.MultipartUpload
public typealias MultipartFormData = Alamofire.MultipartFormData
public typealias Result = Alamofire.AFResult

#if !os(watchOS)
public typealias NetworkReachabilityManager = Alamofire.NetworkReachabilityManager
#endif
