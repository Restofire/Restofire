//
//  ResponseSerializable.swift
//  Restofire
//
//  Created by Rahul Katariya on 29/01/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation

/// Represents a `Alamofire.DataResponseSerializer` that is associated with `Requestable`.
public protocol ResponseSerializable {
    /// The response type.
    associatedtype Response

    /// The data response serializer.
    var responseSerializer: AnyResponseSerializer<RFResult<Response>> { get }

    /// context.
    var context: [String: Any]? { get }
}

extension ResponseSerializable {
    /// `nil`
    public var context: [String: Any]? {
        return nil
    }
}

extension ResponseSerializable where Response == Data {
    /// `Alamofire.DataRequest.dataResponseSerializer()`
    public var responseSerializer: AnyResponseSerializer<RFResult<Response>> {
        return AnyResponseSerializer<RFResult<Data>>
            .init(dataSerializer: { (request, response, data, error) -> RFResult<Data> in
                Result<Data, RFError>.serialize { try DataResponseSerializer()
                    .serialize(
                        request: request,
                        response: response,
                        data: data,
                        error: error
                    )
                }
            })
    }
}
