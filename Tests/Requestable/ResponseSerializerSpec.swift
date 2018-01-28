//
//  ResponseSerializerSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Restofire

class ResponseSerializerSpec: BaseSpec {
    
    override func spec() {
        describe("ResponseSerializer") {
            
            it("should work with the default json serializer") {
                // Given
                struct Service: Requestable {
                    typealias Response = Any
                    var path: String? = "get"
                    var dataResponseSerializer: DataResponseSerializer<Any> = DataRequest.jsonResponseSerializer()
                }
                
                let service = Service()
                
                // When
                waitUntil(timeout: self.timeout) { done in
                    service.executeTask({ response in
                        defer { done() }
                        
                        // Then
                        expect(response.request).to(beNonNil())
                        expect(response.response).to(beNonNil())
                        expect(response.data).to(beNonNil())
                        expect(response.error).to(beNil())
                        if let value = response.result.value as? [String: Any],
                            let url = value["url"] as? String {
                            expect(url).to(equal("https://httpbin.org/get"))
                        } else {
                            fail("response.result.value should not be nil")
                        }
                    })
                }
            }
            
            it("should work with the data serializer") {
                // Given
                
                struct HTTPBin: Decodable {
                    let url: URL
                }

                struct Service: Requestable {
                    typealias Response = HTTPBin
                    var path: String? = "get"
                }

                let service = Service()

                // When
                waitUntil(timeout: self.timeout) { done in
                    service.executeTask({ response in
                        defer { done() }

                        // Then
                        expect(response.request).to(beNonNil())
                        expect(response.response).to(beNonNil())
                        expect(response.data).to(beNonNil())
                        expect(response.error).to(beNil())
                        if let value = response.result.value {
                            expect(value.url.absoluteString).to(equal("https://httpbin.org/get"))
                        } else {
                            fail("response.result.value should not be nil")
                        }
                        
                    })
                }
            }
            
        }
    }
    
}
