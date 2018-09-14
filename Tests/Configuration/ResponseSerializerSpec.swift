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
import Alamofire
@testable import Restofire

class ResponseSerializerSpec: BaseSpec {
    
    override func spec() {
        describe("ResponseSerializer") {
            
            it("should work with the default data serializer") {
                // Given
                struct Service: Requestable {
                    typealias Response = Data
                    var path: String? = "get"
                }
                
                let service = Service()
                
                // When
                waitUntil(timeout: self.timeout) { done in
                    service.execute { response in
                        defer { done() }
                        
                        // Then
                        expect(response.request).toNot(beNil())
                        expect(response.response).toNot(beNil())
                        expect(response.data).toNot(beNil())
                        expect(response.error).to(beNil())
                    }
                }
            }
            
            it("should work with the json serializer") {
                // Given
                struct Service: Requestable {
                    
                    typealias Response = Any
                    var responseSerializer: AnyResponseSerializer<Result<Response>> = AnyResponseSerializer<Result<Response>>.init(dataSerializer: { (request, response, data, error) -> Result<Response> in
                        return Result { try JSONResponseSerializer().serialize(request: request,
                                                                               response: response,
                                                                               data: data,
                                                                               error: error)}
                    })
                
                    var path: String? = "get"
                }
                
                let service = Service()
                
                // When
                waitUntil(timeout: self.timeout) { done in
                    service.execute { response in
                        defer { done() }
                        
                        // Then
                        expect(response.request).toNot(beNil())
                        expect(response.response).toNot(beNil())
                        expect(response.data).toNot(beNil())
                        expect(response.error).to(beNil())
                        
                        if let value = response.result.value as? [String: Any],
                            let url = value["url"] as? String {
                            expect(url).to(equal("https://httpbin.org/get"))
                        } else {
                            fail("response.result.value should not be nil")
                        }
                    }
                }
            }
            
            it("should work with the data serializer") {
                // Given
                
                struct HTTPBin: Decodable {
                    let url: URL
                }

                struct Service: Requestable {
                    typealias Response = HTTPBin
                    var responseSerializer: AnyResponseSerializer<Result<Response>> = AnyResponseSerializer<Result<Response>>.init(dataSerializer: { (request, response, data, error) -> Result<Response> in
                        return Result { try JSONDecodableResponseSerializer().serialize(request: request,
                                                                                        response: response,
                                                                                        data: data,
                                                                                        error: error)}
                    })
                    
                    var path: String? = "get"
                }

                let service = Service()

                // When
                waitUntil(timeout: self.timeout) { done in
                    service.execute { response in
                        defer { done() }

                        // Then
                        expect(response.request).toNot(beNil())
                        expect(response.response).toNot(beNil())
                        expect(response.data).toNot(beNil())
                        expect(response.error).to(beNil())
                        if let value = response.result.value {
                            expect(value.url.absoluteString)
                                .to(equal("https://httpbin.org/get"))
                        } else {
                            fail("response.result.value should not be nil")
                        }
                        
                    }
                }
            }
            
        }
    }
    
}
