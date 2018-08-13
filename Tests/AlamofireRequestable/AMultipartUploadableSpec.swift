//
//  AMultipartUploadableSpec.swift
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

class AMultipartUploadableSpec: BaseSpec {
    
    static var prepareDelegateCalled = false
    static var startDelegateCalled = false
    
    override func spec() {
        describe("AMultipartUpload") {
            
            it("request should succeed") {
                // Given
                struct Upload: AMultipartUploadable {
                    var path: String? = "post"
                    var multipartFormData: (MultipartFormData) -> Void = { multipartFormData in
                        multipartFormData.append("français".data(using: .utf8, allowLossyConversion: false)!, withName: "french")
                        multipartFormData.append("日本語".data(using: .utf8, allowLossyConversion: false)!, withName: "japanese")
                        multipartFormData.append(BaseSpec.url(forResource: "rainbow", withExtension: "jpg"), withName: "image")
                        multipartFormData.append(BaseSpec.url(forResource: "unicorn", withExtension: "png"), withName: "image")
                    }
                    
                    func prepare(_ request: URLRequest, requestable: ARequestable) -> URLRequest {
                        var request = request
                        let header = HTTPHeaders.authorization(username: "user", password: "password")
                        header.forEach {
                            request.setValue($0.value, forHTTPHeaderField: $0.key)
                        }
                        expect(request.value(forHTTPHeaderField: "Authorization"))
                            .to(equal("Basic dXNlcjpwYXNzd29yZA=="))
                        AMultipartUploadableSpec.prepareDelegateCalled = true
                        return request
                    }
                    
                    func didSend(_ request: Request, requestable: ARequestable) {
                        expect(request.request?.value(forHTTPHeaderField: "Authorization"))
                            .to(equal("Basic dXNlcjpwYXNzd29yZA=="))
                        AMultipartUploadableSpec.startDelegateCalled = true
                    }
                    
                }
                
                let request = Upload().request
                print(request.debugDescription)
                
                
                expect(AMultipartUploadableSpec.prepareDelegateCalled).to(beTrue())
                expect(AMultipartUploadableSpec.startDelegateCalled).to(beTrue())
                
                var uploadProgressValues: [Double] = []
                var downloadProgressValues: [Double] = []
                
                // When
                waitUntil(timeout: self.timeout) { done in
                    request
                        .uploadProgress { progress in
                            uploadProgressValues.append(progress.fractionCompleted)
                        }
                        .downloadProgress { progress in
                            downloadProgressValues.append(progress.fractionCompleted)
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
                                let data = value["data"] as? String {
                                expect(data).toNot(beEmpty())
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
                            
                            var previousDownloadProgress: Double = downloadProgressValues.first ?? 0.0
                            
                            for downloadProgress in downloadProgressValues {
                                expect(downloadProgress).to(beGreaterThanOrEqualTo(previousDownloadProgress))
                                previousDownloadProgress = downloadProgress
                            }
                            
                            if let lastDownloadProgressValue = downloadProgressValues.last {
                                expect(lastDownloadProgressValue).to(equal(1.0))
                            } else {
                                fail("last item in downloadProgressValues should not be nil")
                            }
                    }
                }
            }
            
        }
    }
    
}
