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
extension Restofire.ResponseSerializable where Response: Decodable {
    
    public var responseSerializer: AnyResponseSerializer<Response> {
        return AnyResponseSerializer<Response>.init(
            dataSerializer: { (request, response, data, error) -> Response in
                return try! JSONDecodableResponseSerializer<Response>()
                    .serialize(request: request, response: response, data: data, error: error)
            }
        )
    }
    
}
