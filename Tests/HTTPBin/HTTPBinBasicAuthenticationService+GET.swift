//
//  HTTPBinBasicAuthenticationService+GET.swift
//  Restofire
//
//  Created by Rahul Katariya on 16/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Restofire
import Alamofire

class HTTPBinBasicAuthenticationGETService: Requestable, HTTPBinConfigurable {
    
    typealias Model = [String: AnyObject]
    let path: String = "basic-auth/user/password"
    let credential: URLCredential? = URLCredential(user: "user", password: "password", persistence: .forSession)
    
}
