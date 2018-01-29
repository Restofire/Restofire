//
//  GithubRestofire.swift
//  Example
//
//  Created by Rahul Katariya on 29/01/18.
//  Copyright © 2018 Rahul Katariya. All rights reserved.
//

import Restofire

// MARK:- Decodable Response Serializer
extension Restofire.DataResponseSerializable where Response: Decodable {
    
    public var responseSerializer: DataResponseSerializer<Response> {
        return DataRequest.JSONDecodableResponseSerializer()
    }
    
}

extension Restofire.DownloadResponseSerializable where Response: Decodable {
    
    public var responseSerializer: DownloadResponseSerializer<Response> {
        return DownloadRequest.JSONDecodableResponseSerializer()
    }
    
}
