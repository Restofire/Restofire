//
//  TypeAliases.swift
//  Restofire
//
//  Created by Rahul Katariya on 02/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Alamofire

public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias SessionManager = Alamofire.SessionManager

// Encoding
public typealias ParameterEncoding = Alamofire.ParameterEncoding
public typealias JSONEncoding = Alamofire.JSONEncoding
public typealias URLEncoding = Alamofire.URLEncoding
public typealias PropertyListEncoding = Alamofire.PropertyListEncoding

// Request
public typealias Request = Alamofire.Request
public typealias DataRequest = Alamofire.DataRequest
public typealias DownloadRequest = Alamofire.DownloadRequest
public typealias DownloadFileDestination = Alamofire.DownloadRequest.DownloadFileDestination
public typealias UploadRequest = Alamofire.UploadRequest

// Response
public typealias DefaultDataResponse = Alamofire.DefaultDataResponse
public typealias DataResponse = Alamofire.DataResponse
public typealias DefaultDownloadResponse = Alamofire.DefaultDownloadResponse
public typealias DownloadResponse = Alamofire.DownloadResponse

// Features
public typealias DataResponseSerializerProtocol = Alamofire.DataResponseSerializerProtocol
public typealias DataResponseSerializer = Alamofire.DataResponseSerializer
public typealias DownloadResponseSerializerProtocol = Alamofire.DownloadResponseSerializerProtocol
public typealias DownloadResponseSerializer = Alamofire.DownloadResponseSerializer
public typealias MultipartFormData = Alamofire.MultipartFormData
public typealias MultipartFormDataEncodingResult = SessionManager.MultipartFormDataEncodingResult
public typealias Result = Alamofire.Result


#if !os(watchOS)
public typealias NetworkReachabilityManager = Alamofire.NetworkReachabilityManager
#endif
