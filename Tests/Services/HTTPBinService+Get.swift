//
//  HTTPBinService+Get.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Restofire
import Alamofire

class HTTPBinStringGETService: HTTPBinRequestable {
    
    typealias Model = String
    var path: String = "get"
    var rootKeyPath: String? = "args.name"
    var encoding: ParameterEncoding = .URLEncodedInURL
    var parameters: AnyObject?
    
}
