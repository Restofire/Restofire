//
//  HTTPBinRequestType.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

@testable import Restofire

protocol HTTPBinRequestType: RequestType { }

extension HTTPBinRequestType {

    var configuration: Configuration {
        
        var config = Configuration()
        config.baseURL = "https://httpbin.org/"
        config.logging = true
        return config
        
    }
    
}