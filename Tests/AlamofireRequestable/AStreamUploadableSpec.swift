//
//  AStreamUploadableSpec.swift
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

class AStreamUploadableSpec: BaseSpec {
    
    static var startDelegateCalled = false

    override func spec() {
        describe("AStreamUpload") {
            
            it("request should succeed") {
                // Given
                struct Upload: StreamUploadable {
                    typealias Response = Data
                    
                    var path: String? = "post"
                    var stream: InputStream = InputStream(url: BaseSpec.url(forResource: "rainbow", withExtension: "jpg"))!
                    
                    func prepare<R: _Requestable>(_ request: URLRequest, requestable: R) -> URLRequest {
                        var request = request
                        let header = HTTPHeader.authorization(username: "user", password: "password")
                        request.setValue(header.value, forHTTPHeaderField: header.name)
                        expect(request.value(forHTTPHeaderField: "Authorization"))
                            .to(equal("Basic dXNlcjpwYXNzd29yZA=="))
                        return request
                    }
                    
                    func didSend<R: _Requestable>(_ request: Request, requestable: R) {
                        expect(request.request?.value(forHTTPHeaderField: "Authorization")!)
                            .to(equal("Basic dXNlcjpwYXNzd29yZA=="))
                        AStreamUploadableSpec.startDelegateCalled = true
                    }
                    
                }
                
                do {
                    let request = try Upload().asRequest()
                    print(request.debugDescription)
                    
                    // When
                    waitUntil(timeout: self.timeout) { done in
                        
                        request
                            .response { response in
                                defer {
                                    expect(AStreamUploadableSpec.startDelegateCalled).to(beTrue())
                                    done()
                                }
                                
                                // Then
                                expect(response.request).toNot(beNil())
                                expect(response.response).toNot(beNil())
                                expect(response.data).toNot(beNil())
                                expect(response.error).to(beNil())
                        }
                    }
                } catch {
                    fail(error.localizedDescription)
                }
            }
            
        }
    }
    
}

