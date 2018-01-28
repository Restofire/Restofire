//
//  JDDownloadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

public protocol JDDownloadable: ADownloadable {
    
    associatedtype Response: Decodable
    
}

extension JDDownloadable {
    
    func response(completionHandler: @escaping (DownloadResponse<Response>) -> Void) {
        request().responseJSONDecodable(completionHandler: completionHandler)
    }
    
}
