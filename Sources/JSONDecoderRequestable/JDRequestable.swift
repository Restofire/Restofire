//
//  JDRequestable.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public protocol JDRequestable: Requestable {
    
    associatedtype Response: Decodable
  
}

extension JDRequestable {
    
    func response(completionHandler: @escaping (DataResponse<Response>) -> Void) {
        request().responseJSONDecodable(completionHandler: completionHandler)
    }
    
}
