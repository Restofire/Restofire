//
//  ResponseSerializable.swift
//  Restofire
//
//  Created by Rahul Katariya on 29/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// Represents a `Alamofire.DataResponseSerializer` that is associated with `Requestable`.
public protocol ResponseSerializable {
    
    /// The response type.
    associatedtype Response
    
    /// The data response serializer.
    var responseSerializer: AnyResponseSerializer<Result<Response>> { get }
    
    /// context.
    var context: [String: Any]? { get }
    
}


public extension ResponseSerializable {
    
    /// `nil`
    public var context: [String: Any]? {
        return nil
    }
    
}

public extension ResponseSerializable where Response == Data {
    
    /// `Alamofire.DataRequest.dataResponseSerializer()`
    public var responseSerializer: AnyResponseSerializer<Result<Response>> {
        return AnyResponseSerializer<Result<Data>>
            .init(dataSerializer: { (request, response, data, error) -> Result<Data> in
                return Result { try DataResponseSerializer()
                    .serialize(request: request,
                               response: response,
                               data: data,
                               error: error)
                }
        })
    }
    
}
