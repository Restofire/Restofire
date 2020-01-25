//
//  StreamUploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 31/01/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Alamofire
@testable import Restofire

class StreamUploadableSpec: BaseSpec {
    
    static var startDelegateCalled = false
    static var successDelegateCalled = false
    static var errorDelegateCalled = false
    
    struct Service: StreamUploadable {
        
        typealias Response = Data
        var path: String? = "post"
        let stream: InputStream = InputStream(url: BaseSpec.url(forResource: "rainbow", withExtension: "png"))!
        
        func prepare<R: BaseRequestable>(_ request: URLRequest, requestable: R) -> URLRequest {
            var request = request
            let header = HTTPHeader.authorization(username: "user", password: "password")
            request.setValue(header.value, forHTTPHeaderField: header.name)
            expect(request.value(forHTTPHeaderField: "Authorization"))
                .to(equal("Basic dXNlcjpwYXNzd29yZA=="))
            return request
        }
        
        func willSend<R: BaseRequestable>(_ request: Request, requestable: R) {
            let value = request.request?.value(forHTTPHeaderField: "Authorization")!
            expect(value).to(equal("Basic dXNlcjpwYXNzd29yZA=="))
            StreamUploadableSpec.startDelegateCalled = true
        }
        
        func request(_ request: UploadOperation<Service>, didCompleteWithValue value: Data) {
            StreamUploadableSpec.successDelegateCalled = true
            expect(value).toNot(beNil())
        }
        
        func request(_ request: UploadOperation<Service>, didFailWithError error: Error) {
            StreamUploadableSpec.errorDelegateCalled = true
            fail(error.localizedDescription)
        }
    }
    
    var operation: UploadOperation<Service>!
    
    override func spec() {
        describe("StreamUploadable") {
            it("request should succeed") {
                waitUntil(timeout: self.timeout) { done in
                    // Given
                    let service = Service()
                    
                    var callbacks: Int = 0 {
                        didSet {
                            if callbacks == 2 {
                                expect(StreamUploadableSpec.startDelegateCalled).to(beTrue())
                                expect(StreamUploadableSpec.successDelegateCalled).to(beTrue())
                                expect(StreamUploadableSpec.errorDelegateCalled).to(beFalse())
                                done()
                            }
                        }
                    }
                    
                    // When
                    do {
                        self.operation = try service.operation { response in
                            
                            defer { callbacks = callbacks + 1 }
                            
                            // Then
                            expect(response.value).toNot(beNil())
                            expect(response.request).toNot(beNil())
                            expect(response.response).toNot(beNil())
                            expect(response.data).toNot(beNil())
                            expect(response.error).to(beNil())
                        }
                        
                        self.operation.start()
                        self.operation.completionBlock = { callbacks = callbacks + 1 }
                    } catch {
                        fail(error.localizedDescription)
                    }
                }
            }
        }
    }
}
