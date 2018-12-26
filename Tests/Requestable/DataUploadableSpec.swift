//
//  DataUploadableSpec.swift
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

class DataUploadableSpec: BaseSpec {
    
    static var startDelegateCalled = false
    static var successDelegateCalled = false
    static var errorDelegateCalled = false
    
    override func spec() {
        describe("DataUploadable") {
            
            it("request should succeed") {
                
                waitUntil(timeout: self.timeout) { done in
                    struct Service: DataUploadable {
                        
                        typealias Response = Any
                        var responseSerializer = AnyResponseSerializer<Result<Response>>
                            .init(dataSerializer: { (request, response, data, error) -> Result<Response> in
                                return Result { try JSONResponseSerializer()
                                    .serialize(request: request,
                                               response: response,
                                               data: data,
                                               error: error)
                                }
                            })
                        
                        var path: String? = "post"
                        var data: Data = {
                            return "Lorem ipsum dolor sit amet, consectetur adipiscing elit.".data(using: .utf8, allowLossyConversion: false)!
                        }()
                        
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
                            DataUploadableSpec.startDelegateCalled = true
                        }
                        
                        func request(_ request: UploadOperation<Service>, didCompleteWithValue value: Response) {
                            DataUploadableSpec.successDelegateCalled = true
                            expect(value).toNot(beNil())
                        }
                        
                        func request(_ request: UploadOperation<Service>, didFailWithError error: Error) {
                            DataUploadableSpec.errorDelegateCalled = true
                            fail(error.localizedDescription)
                        }
                    }
                    
                    let service = Service()
                    var uploadProgressValues: [Double] = []
                    
                    var callbacks: Int = 0 {
                        didSet {
                            if callbacks == 2 {
                                expect(DataUploadableSpec.startDelegateCalled).to(beTrue())
                                expect(DataUploadableSpec.successDelegateCalled).to(beTrue())
                                expect(DataUploadableSpec.errorDelegateCalled).to(beFalse())
                                done()
                            }
                        }
                    }
                    
                    // When
                    do {
                        let operation = try service.execute(uploadProgressHandler: { progress in
                                uploadProgressValues.append(progress.fractionCompleted)
                        }) { value, response in
                            
                            defer { callbacks = callbacks + 1 }
                            
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
                                let form = value["form"] as? [String: Any] {
                                expect(form["Lorem ipsum dolor sit amet, consectetur adipiscing elit."]).toNot(beNil())
                            } else {
                                fail("response value should not be nil")
                            }
                            
                            var previousUploadProgress: Double = uploadProgressValues.first ?? 0.0
                            
                            for uploadProgress in uploadProgressValues {
                                expect(uploadProgress).to(beGreaterThanOrEqualTo(previousUploadProgress))
                                previousUploadProgress = uploadProgress
                            }
                            
                            if let lastUploadProgressValue = uploadProgressValues.last {
                                expect(lastUploadProgressValue).to(equal(1.0))
                            } else {
                                fail("last item in uploadProgressValues should not be nil")
                            }
                        }
                        
                        operation.completionBlock = { callbacks = callbacks + 1 }
                    } catch {
                        fail(error.localizedDescription)
                    }
                }
            }
            
        }
    }
    
}
