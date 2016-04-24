//
//  HTTPBinService+Get.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Restofire
import Alamofire

class HTTPBinStringGETService: Requestable, HTTPBinConfigurable {
    
    typealias Model = [String: AnyObject]
    let path: String = "get"
    let encoding: ParameterEncoding = .URLEncodedInURL
    var parameters: AnyObject?
    
    init(parameters: AnyObject?) {
        self.parameters = parameters
    }
    
}
