//
//  HTTPBinBasicAuthenticationService+GETSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 16/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Quick
import Nimble
import Alamofire

class HTTPBinBasicAuthenticationGETServiceSpec: ServiceSpec {
    
    override func spec() {
        describe("HTTPBinBasicAuthenticationGETService") {
            
            it("executeTask") {
                
                let actual = true
                var expected: Bool!
                
                HTTPBinBasicAuthenticationGETService().executeTask() {
                    if let response = $0.result.value, let value = response["authenticated"] as? Bool {
                        expected = value
                    }
                }
                
                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)
                
            }
            
            it("executeRequestOperation") {
                let actual = true
                var expected: Bool!
                
                let requestOperation = HTTPBinBasicAuthenticationGETService().requestOperation() {
                    if let response = $0.result.value, let value = response["authenticated"] as? Bool {
                        expected = value
                    }
                }
                
                requestOperation.start()
                
                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)
                
            }
        }
    }
    
}
