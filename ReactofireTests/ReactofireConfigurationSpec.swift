//
//  ReactofireConfigurationSpec.swift
//  Reactofire
//
//  Created by Rahul Katariya on 01/02/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Quick
import Nimble
import Gloss
import ReactiveCocoa
import Alamofire
@testable import Reactofire

class ReactofireConfigurationSpec: ReactofireSpec {
    
    override func spec() {
        
        describe("ReactofireConfiguration") {
            
            it("has baseURL") {
                expect(ReactofireConfiguration.defaultConfiguration.baseURL) == "http://httpbin.org/"
            }
            
            it("has default headers") {
                expect(ReactofireConfiguration.defaultConfiguration.headers) == ["Content-Type": "application/json"]
            }
            
            it("has default headers") {
                expect(ReactofireConfiguration.defaultConfiguration.logging) == true
            }
            
        }
        
    }
    
}
