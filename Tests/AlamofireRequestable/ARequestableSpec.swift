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
    
    static var startDelegateCalled = false
    static var completeDelegateCalled = false
    
    override func spec() {
        describe("ARequestable") {
            
            it("request should succeed") {
                // Given
                struct Service: ARequestable {
                    var path: String? = "get"
                    
                    func prepare(_ request: URLRequest, requestable: Configurable) -> URLRequest {
                        var request = request
                        let header = Request.authorizationHeader(user: "user", password: "password")!
                        request.setValue(header.value, forHTTPHeaderField: header.key)
                        return request
                    }
                    
                    func didSend(_ request: Request, requestable: Configurable) {
                        expect(request.request?.value(forHTTPHeaderField: "Authorization"))
                            .to(equal("Basic dXNlcjpwYXNzd29yZA=="))
                        ARequestableSpec.startDelegateCalled = true
                    }
                    
                    func didComplete(_ request: Request, requestable: Configurable) {
                        ARequestableSpec.completeDelegateCalled = true
                    }
                    
                }
                
                let request = Service().request
                print(request.debugDescription)
                
                expect(ARequestableSpec.startDelegateCalled).to(beTrue())
                
                var progressValues: [Double] = []
                
                // When
                waitUntil(timeout: self.timeout) { done in
                    request
                        .downloadProgress { progress in
                            progressValues.append(progress.fractionCompleted)
                        }
                        .responseJSON { response in
                            defer { done() }
                            
                            expect(ARequestableSpec.completeDelegateCalled).to(beTrue())
                            
                            // Then
                            if let statusCode = response.response?.statusCode,
                                statusCode != 200 {
                                fail("Response status code should be 200")
                            }
                            
                            expect(response.request).toNot(beNil())
                            expect(response.response).toNot(beNil())
                            expect(response.data).toNot(beNil())
                            expect(response.error).to(beNil())
                            
                            if let value = response.value as? [String: Any],
                                let url = value["url"] as? String {
                                expect(url).to(equal("https://httpbin.org/get"))
                            } else {
                                fail("response value should not be nil")
                            }
                            
                            var previousProgress: Double = progressValues.first ?? 0.0
                            
                            for progress in progressValues {
                                expect(progress).to(beGreaterThanOrEqualTo(previousProgress))
                                previousProgress = progress
                            }
                            
                            if let lastProgressValue = progressValues.last {
                                expect(lastProgressValue).to(equal(1.0))
                            } else {
                                fail("last item in progressValues should not be nil")
                            }
                    }
                }
            }
            
        }
    }
    
}
