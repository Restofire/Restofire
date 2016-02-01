//
//  RestofireSpec.swift
//  Reactofire
//
//  Created by Rahul Katariya on 01/02/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Quick
import Nimble
@testable import Reactofire

class ReactofireSpec: QuickSpec {
    
    override func spec() {
        
        beforeSuite {
            ReactofireConfiguration.defaultConfiguration.baseURL = "http://httpbin.org/"
            ReactofireConfiguration.defaultConfiguration.headers = ["Content-Type": "application/json"]
            ReactofireConfiguration.defaultConfiguration.logging = true
        }
        
    }
    
}
