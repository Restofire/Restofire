//
//  RequestableSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 29/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Alamofire
@testable import Restofire

class RequestableSpec: BaseSpec {
    
    static var successDelegateCalled = false
    static var errorDelegateCalled = false
    
    override func spec() {
        describe("Requestable") {
            
            it("request should succeed") {
                // Given
                struct HTTPBin: Decodable {
                    let url: URL
                }
                
                waitUntil(timeout: self.timeout) { done in
                    struct Request: Requestable {
                        typealias Response = HTTPBin
                        
                        var path: String? = "get"
                        var responseSerializer: AnyResponseSerializer<Result<Response>> = AnyResponseSerializer<Result<Response>>.init(dataSerializer: { (request, response, data, error) -> Result<Response> in
                            return Result { try JSONDecodableResponseSerializer().serialize(request: request,
                                                                                            response: response,
                                                                                            data: data,
                                                                                            error: error)}
                        })
                        
                        func request(_ request: RequestOperation<Request>, didCompleteWithValue value: HTTPBin) {
                            RequestableSpec.successDelegateCalled = true
                            expect(value.url.absoluteString).to(equal("https://httpbin.org/get"))
                        }
                        
                        func request(_ request: RequestOperation<Request>, didFailWithError error: Error) {
                            RequestableSpec.errorDelegateCalled = true
                            fail(error.localizedDescription)
                        }
                        
                    }
                    
                    let request = Request()
                    
                    // When
                    let operation = request.execute { response in
                        
                        // Then
                        if let statusCode = response.response?.statusCode,
                            statusCode != 200 {
                            fail("Response status code should be 200")
                        }
                        
                        expect(response.request).toNot(beNil())
                        expect(response.response).toNot(beNil())
                        expect(response.data).toNot(beNil())
                        expect(response.error).to(beNil())
                        
                    }
                    
                    operation.completionBlock = {
                        expect(RequestableSpec.successDelegateCalled).to(beTrue())
                        expect(RequestableSpec.errorDelegateCalled).to(beFalse())
                        done()
                    }
                }
            }
            
        }
    }
    
}
