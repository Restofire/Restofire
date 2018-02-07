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
    
    static var startDelegateCalled = false
    static var completeDelegateCalled = false
    
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
                    
                    func prepare(_ request: URLRequest, requestable: Configurable) -> URLRequest {
                        var request = request
                        let header = Request.authorizationHeader(user: "user", password: "password")!
                        request.setValue(header.value, forHTTPHeaderField: header.key)
                        return request
                    }
                    
                    func didSend(_ request: Request, requestable: Configurable) {
                        expect(request.request?.value(forHTTPHeaderField: "Authorization"))
                            .to(equal("Basic dXNlcjpwYXNzd29yZA=="))
                        AMultipartUploadableSpec.startDelegateCalled = true
                    }
                    
                    func didComplete(_ request: Request, requestable: Configurable) {
                        AMultipartUploadableSpec.completeDelegateCalled = true
                    }
                    
                }
                
                // When
                waitUntil(timeout: self.timeout) { done in
                    Upload().response(encodingCompletion: { result in
                        switch result {
                        case .success(let upload, _, _):
                            
                            print(upload.debugDescription)
                            
                            expect(AMultipartUploadableSpec.startDelegateCalled).to(beTrue())
                            
                            var uploadProgressValues: [Double] = []
                            var downloadProgressValues: [Double] = []
                            
                            upload
                                .uploadProgress { progress in
                                    uploadProgressValues.append(progress.fractionCompleted)
                                }
                                .downloadProgress { progress in
                                    downloadProgressValues.append(progress.fractionCompleted)
                                }
                                .responseJSON { response in
                                    defer { done() }
                                    
                                    // Then
                                    expect(AMultipartUploadableSpec.completeDelegateCalled).to(beTrue())
                                    
                                    if let statusCode = response.response?.statusCode,
                                        statusCode != 200 {
                                        fail("Response status code should be 200")
                                    }
                                    
                                    expect(response.request).toNot(beNil())
                                    expect(response.response).toNot(beNil())
                                    expect(response.data).toNot(beNil())
                                    expect(response.error).to(beNil())
                                    
                                    if let value = response.value as? [String: Any],
                                        let form = value["form"] as? [String: Any],
                                        let french = form["french"] as? String,
                                        let japanese = form["japanese"] as? String {
                                        expect(french).to(equal("français"))
                                        expect(japanese).to(equal("日本語"))
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

