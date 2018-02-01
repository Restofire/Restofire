//
//  ResponseSerializable.swift
//  Restofire
//
//  Created by Rahul Katariya on 29/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// Represents a `Alamofire.DataResponseSerializer` that is associated with `Requestable`.
public protocol DataResponseSerializable {
    
    associatedtype Response
    
    /// `The responseSerializer`
    var responseSerializer: DataResponseSerializer<Response> { get }
    
}

public extension DataResponseSerializable where Response == Data {
    
    /// `Alamofire.DataRequest.dataResponseSerializer()`
    public var responseSerializer: DataResponseSerializer<Response> {
        return DataRequest.dataResponseSerializer()
    }
    
}

/// Represents a `Alamofire.DownloadResponseSerializer` that is associated with `Downloadable`.
public protocol DownloadResponseSerializable {
    
    associatedtype Response
    
    /// `responseSerializer`
    var responseSerializer: DownloadResponseSerializer<Response> { get }
    
}

public extension DownloadResponseSerializable where Response == Data {
    
    /// `Alamofire.DownloadRequest.dataResponseSerializer()`
    public var responseSerializer: DownloadResponseSerializer<Response> {
        return DownloadRequest.dataResponseSerializer()
    }
    
}
