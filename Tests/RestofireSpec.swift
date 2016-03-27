//
//  RestofireSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 01/02/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Quick
import Nimble
@testable import Restofire

class RestofireSpec: QuickSpec {
    
    override func spec() {
        
        beforeEach { 
            Configuration.defaultConfiguration.baseURL = "http://www.mocky.io/v2/"
            Configuration.defaultConfiguration.headers = ["Content-Type": "application/json"]
            Configuration.defaultConfiguration.logging = true
        }
    }
    
}
