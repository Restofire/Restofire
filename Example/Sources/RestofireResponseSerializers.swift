//
//  GithubRestofire.swift
//  Example
//
//  Created by Rahul Katariya on 29/01/18.
//  Copyright © 2018 Rahul Katariya. All rights reserved.
//

import Restofire
import Alamofire

// MARK:- Decodable Response Serializer
extension Restofire.ResponseSerializable where Response == Any {
    
    public var responseSerializer: AnyResponseSerializer<Result<Response>> {
        return AnyResponseSerializer<Result<Response>>.init(
            dataSerializer: { (request, response, data, error) -> Result<Response> in
                return Result { try JSONResponseSerializer()
                    .serialize(request: request,
                               response: response,
                               data: data,
                               error: error)
                }
            }
        )
    }
    
}

extension Restofire.ResponseSerializable where Response: Decodable {
    
    public var responseSerializer: AnyResponseSerializer<Result<Response>> {
        return AnyResponseSerializer<Result<Response>>.init(
            dataSerializer: { (request, response, data, error) -> Result<Response> in
                return Result { try DecodableResponseSerializer<Response>()
                    .serialize(request: request,
                               response: response,
                               data: data,
                               error: error)
                }
            }
        )
    }
    
}
