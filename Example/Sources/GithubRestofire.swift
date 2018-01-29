//
//  GithubRestofire.swift
//  Example
//
//  Created by Rahul Katariya on 29/01/18.
//  Copyright © 2018 Rahul Katariya. All rights reserved.
//

import Restofire

class GithubRestofire {
    
    static func bootstrap() {
        Restofire.Configuration.default.scheme = "https://"
        Restofire.Configuration.default.baseURL = "api.github.com"
    }
    
}

extension Restofire.DataResponseSerializable where Response == Any {
    
    public var responseSerializer: DataResponseSerializer<Response> {
        return DataRequest.jsonResponseSerializer()
    }
    
}

extension Restofire.DownloadResponseSerializable where Response == Any {
    
    public var responseSerializer: DownloadResponseSerializer<Response> {
        return DownloadRequest.jsonResponseSerializer()
    }
    
}
