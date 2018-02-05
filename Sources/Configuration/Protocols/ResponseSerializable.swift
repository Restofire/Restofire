//
//  ResponseSerializable.swift
//  Restofire
//
//  Created by Rahul Katariya on 29/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public protocol _ResponseSerializable {
    
    /// The response type.
    associatedtype Response
    
    /// The keypath.
    var keypath: String? { get }
    
    /// context.
    var context: [String: Any]? { get }
    
}

extension _ResponseSerializable {
    
    /// `nil`
    public var keypath: String? {
        return nil
    }
    
    /// `nil`
    public var context: [String: Any]? {
        return nil
    }
    
}

/// Represents a `Alamofire.DataResponseSerializer` that is associated with `Requestable`.
public protocol DataResponseSerializable: _ResponseSerializable {
    
    /// The data response serializer.
    var responseSerializer: DataResponseSerializer<Response> { get }
    
}

public extension DataResponseSerializable where Response == Data {
    
    /// `Alamofire.DataRequest.dataResponseSerializer()`
    public var responseSerializer: DataResponseSerializer<Response> {
        return DataRequest.dataResponseSerializer()
    }
    
}

/// Represents a `Alamofire.DownloadResponseSerializer` that is associated with `Downloadable`.
public protocol DownloadResponseSerializable: _ResponseSerializable {
    
    /// The download response serializer.
    var responseSerializer: DownloadResponseSerializer<Response> { get }
    
}

public extension DownloadResponseSerializable where Response == Data {
    
    /// `Alamofire.DownloadRequest.dataResponseSerializer()`
    public var responseSerializer: DownloadResponseSerializer<Response> {
        return DownloadRequest.dataResponseSerializer()
    }
    
}
