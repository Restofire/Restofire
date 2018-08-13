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
    
    static var prepareDelegateCalled = false
    static var startDelegateCalled = false
    
    override func spec() {
        describe("ARequestable") {
            
            it("request should succeed") {
                // Given
                struct Service: ARequestable {
                    var path: String? = "get"
                    
                    func prepare(_ request: URLRequest, requestable: ARequestable) -> URLRequest {
                        var request = request
                        let header = HTTPHeaders.authorization(username: "user", password: "password")
                        header.forEach {
                            request.setValue($0.value, forHTTPHeaderField: $0.key)
                        }
                        expect(request.value(forHTTPHeaderField: "Authorization"))
                            .to(equal("Basic dXNlcjpwYXNzd29yZA=="))
                        ARequestableSpec.prepareDelegateCalled = true
                        return request
                    }
                    
                    func didSend(_ request: Request, requestable: ARequestable) {
                        expect(request.request?.value(forHTTPHeaderField: "Authorization"))
                            .to(equal("Basic dXNlcjpwYXNzd29yZA=="))
                        ARequestableSpec.startDelegateCalled = true
                    }
                    
                }
                
                let request = Service().request
                print(request.debugDescription)
                
                
                expect(ARequestableSpec.prepareDelegateCalled).to(beTrue())
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
