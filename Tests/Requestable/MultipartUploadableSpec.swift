//
//  MultipartUploadableSpec.swift
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

class MultipartUploadableSpec: BaseSpec {
    
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
                    
                    struct Upload: MultipartUploadable {
                        typealias Response = HTTPBin
                        var path: String? = "post"
                        var multipartFormData: (MultipartFormData) -> Void = { multipartFormData in
                            multipartFormData.append("français".data(using: .utf8, allowLossyConversion: false)!, withName: "french")
                            multipartFormData.append("日本語".data(using: .utf8, allowLossyConversion: false)!, withName: "japanese")
                            multipartFormData.append(BaseSpec.url(forResource: "rainbow", withExtension: "jpg"), withName: "image")
                            multipartFormData.append(BaseSpec.url(forResource: "unicorn", withExtension: "png"), withName: "image")
                        }
                        var responseSerializer: DataResponseSerializer<HTTPBin> = DataRequest.JSONDecodableResponseSerializer()
                        
                        func request(_ request: UploadOperation<Upload>, didCompleteWithValue value: HTTPBin) {
                            MultipartUploadableSpec.successDelegateCalled = true
                            expect(value.form.french).to(equal("français"))
                            expect(value.form.japanese).to(equal("日本語"))
                        }
                        
                        func request(_ request: UploadOperation<Upload>, didFailWithError error: Error) {
                            MultipartUploadableSpec.errorDelegateCalled = true
                            fail(error.localizedDescription)
                        }
                    }
                    
                    // When
                    let uploadable = Upload()
                    uploadable.request(encodingCompletion: { result in
                        switch result {
                        case .success(let upload, _, _):
                            
                            print(upload.debugDescription)
                            
                            let operation = uploadable.response(request: upload, completionHandler: { (response: DataResponse<HTTPBin>) in

                                // Then
                                if let statusCode = response.response?.statusCode,
                                    statusCode != 200 {
                                    fail("Response status code should be 200")
                                }

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
                            
                            })
                            
                            operation.completionBlock = {
                                expect(MultipartUploadableSpec.successDelegateCalled).to(beTrue())
                                expect(MultipartUploadableSpec.errorDelegateCalled).to(beFalse())
                                done()
                            }

                        case .failure(let error):
                            fail("Encoding Completion Failed with \(error.localizedDescription)")
                            done()
                        }
                        
                    })
                }
            }
            
        }
    }
    
}
