//
//  ResponseSerializable.swift
//  Restofire
//
//  Created by Rahul Katariya on 29/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

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
public protocol ResponseSerializable: _ResponseSerializable {
    
    /// The data response serializer.
    var responseSerializer: AnyResponseSerializer<Result<Response>> { get }
    
}

public extension ResponseSerializable where Response == Data {
    
    /// `Alamofire.DataRequest.dataResponseSerializer()`
    public var responseSerializer: AnyResponseSerializer<Result<Response>> {
        return AnyResponseSerializer<Result<Response>>.init(dataSerializer: { (request, response, data, error) -> Result<Response> in
            return Result { try DataResponseSerializer().serialize(
                request: request, response: response, data: data, error: error
            )}
        })
    }
    
}
