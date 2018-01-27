//
//  RequestableSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Alamofire
@testable import Restofire

class RequestableSpec: BaseSpec {
    
    override func spec() {
        describe("Requestable") {
            
            it("request should succeed") {
                // Given
                struct Request: Requestable {
                    var path: String? = "get"
                }
                
                let request = Request().request()
                var response: DefaultDataResponse?
                
                // When
                waitUntil(timeout: self.timeout) { done in
                    request
                        .response { resp in
                            response = resp
                            
                            //Then
                            expect(response?.request).to(beNonNil())
                            expect(response?.response).to(beNonNil())
                            expect(response?.data).to(beNonNil())
                            expect(response?.error).to(beNil())
                            done()
                    }
                }
            }
            
        }
    }
    
}
