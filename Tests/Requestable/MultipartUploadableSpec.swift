//
//  MultipartUploadableSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Alamofire
@testable import Restofire

class MultipartUploadableSpec: BaseSpec {
    
    static var startDelegateCalled = false
    static var successDelegateCalled = false
    static var errorDelegateCalled = false
    
    override func spec() {
        describe("MultipartUpload") {
            
            it("request should succeed") {
                waitUntil(timeout: self.timeout) { done in
                    // Given
                    struct HTTPBin: Decodable {
                        let form: Form
                    }
                    
                    struct Form: Decodable {
                        let french: String
                        let japanese: String
                    }
                    
                    struct Service: MultipartUploadable {
                        typealias Response = HTTPBin
                        var responseSerializer = AnyResponseSerializer<Result<Response>>
                            .init(dataSerializer: { (request, response, data, error) -> Result<Response> in
                                return Result { try DecodableResponseSerializer()
                                    .serialize(request: request,
                                               response: response,
                                               data: data,
                                               error: error)
                                }
                        })
                        
                        var path: String? = "post"
                        var multipartFormData: (MultipartFormData) -> Void = { multipartFormData in
                            multipartFormData.append("français".data(using: .utf8, allowLossyConversion: false)!, withName: "french")
                            multipartFormData.append("日本語".data(using: .utf8, allowLossyConversion: false)!, withName: "japanese")
                            multipartFormData.append(BaseSpec.url(forResource: "rainbow", withExtension: "jpg"), withName: "image")
                            multipartFormData.append(BaseSpec.url(forResource: "unicorn", withExtension: "png"), withName: "image")
                        }
                        
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
                            MultipartUploadableSpec.startDelegateCalled = true
                        }
                        
                        func request(_ request: UploadOperation<Service>, didCompleteWithValue value: HTTPBin) {
                            MultipartUploadableSpec.successDelegateCalled = true
                            expect(value.form.french).to(equal("français"))
                            expect(value.form.japanese).to(equal("日本語"))
                        }
                        
                        func request(_ request: UploadOperation<Service>, didFailWithError error: Error) {
                            MultipartUploadableSpec.errorDelegateCalled = true
                            fail(error.localizedDescription)
                        }
                    }
                    
                    let service = Service()
                    var uploadProgressValues: [Double] = []
                    
                    var callbacks: Int = 0 {
                        didSet {
                            if callbacks == 2 {
                                expect(MultipartUploadableSpec.startDelegateCalled).to(beTrue())
                                expect(MultipartUploadableSpec.successDelegateCalled).to(beTrue())
                                expect(MultipartUploadableSpec.errorDelegateCalled).to(beFalse())
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
                            
                            expect(value).toNot(beNil())
                            expect(response.request).toNot(beNil())
                            expect(response.response).toNot(beNil())
                            expect(response.data).toNot(beNil())
                            expect(response.error).to(beNil())
                            
                            if let value = response.value {
                                expect(value.form.french).to(equal("français"))
                                expect(value.form.japanese).to(equal("日本語"))
                            } else {
                                fail("response value should not be nil")
                            }
                            
                            if let form = response.value?.form {
                                expect(form.french).to(equal("français"))
                                expect(form.japanese).to(equal("日本語"))
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
