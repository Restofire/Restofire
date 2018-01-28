//
//  ARequestableSpec.swift
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

class ARequestableSpec: BaseSpec {
    
    override func spec() {
        describe("ARequestable") {
            
            it("request should succeed") {
                // Given
                struct Request: ARequestable {
                    var path: String? = "get"
                }
                
                let request = Request().request()
                
                // When
                waitUntil(timeout: self.timeout) { done in
                    request.response { response in
                        defer { done() }
                        
                        //Then
                        expect(response.request).to(beNonNil())
                        expect(response.response).to(beNonNil())
                        expect(response.data).to(beNonNil())
                        expect(response.error).to(beNil())
                    }
                }
            }
            
        }
    }
    
}
