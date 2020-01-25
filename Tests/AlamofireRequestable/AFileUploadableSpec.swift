//
//  AFileUploadableSpec.swift
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

class AFileUploadableSpec: BaseSpec {
    
    static var startDelegateCalled = false
    
    override func spec() {
        describe("AFileUpload") {
            
            it("request should succeed") {
                // Given
                struct Upload: AFileUploadable {
                    var path: String? = "post"
                    let url: URL = BaseSpec.url(forResource: "rainbow", withExtension: "png")
                    
                    func prepare(_ request: URLRequest, requestable: AConfigurable) -> URLRequest {
                        var request = request
                        let header = Request.authorizationHeader(user: "user", password: "password")!
                        request.setValue(header.value, forHTTPHeaderField: header.key)
                        return request
                    }
                    
                    func didSend(_ request: Request, requestable: AConfigurable) {
                        expect(request.request?.value(forHTTPHeaderField: "Authorization"))
                            .to(equal("Basic dXNlcjpwYXNzd29yZA=="))
                        AFileUploadableSpec.startDelegateCalled = true
                    }
                    
                }
                
                let request = Upload().request
                print(request.debugDescription)
                
                expect(AFileUploadableSpec.startDelegateCalled).to(beTrue())
                
                // When
                waitUntil(timeout: self.timeout) { done in
                    request
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
                                let data = value["data"] as? String {
                                expect(data).toNot(beEmpty())
                            } else {
                                fail("response value should not be nil")
                            }
                    }
                }
            }
            
        }
    }
    
}

