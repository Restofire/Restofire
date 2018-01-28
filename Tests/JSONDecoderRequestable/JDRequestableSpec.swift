//
//  JDRequestableSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Restofire

class JDRequestableSpec: BaseSpec {
    
    override func spec() {
        describe("JDRequestable") {
            
            it("request should decode json response to decodable object") {
                // Given
                struct HTTPBin: Decodable {
                    let url: URL
                }
                
                struct Request: JDRequestable {
                    typealias Response = HTTPBin
                    var path: String? = "get"
                }
                
                let request = Request()
                
                // When
                waitUntil(timeout: self.timeout) { done in
                    request.response(completionHandler: { response in
                        defer { done() }
                        
                        //Then
                        expect(response.request).to(beNonNil())
                        expect(response.response).to(beNonNil())
                        expect(response.result.value?.url.absoluteString)
                            .to(equal("https://httpbin.org/get"))
                        expect(response.data).to(beNonNil())
                        expect(response.error).to(beNil())
                    })
                }
            }
            
        }
    }
    
}

