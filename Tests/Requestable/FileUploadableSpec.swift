//
//  FileUploadableSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 31/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Alamofire
@testable import Restofire

class FileUploadableSpec: BaseSpec {
    
    static var downloadProgressValues: [Double] = []
    static var uploadProgressValues: [Double] = []
    static var successDelegateCalled = false
    static var errorDelegateCalled = false
    
    override func spec() {
        describe("FileUploadable") {
            
            it("request should succeed") {
                
                waitUntil(timeout: self.timeout) { done in
                    struct Upload: FileUploadable {
                        
                        typealias Response = Data
                        var path: String? = "post"
                        let url: URL = BaseSpec.url(forResource: "rainbow", withExtension: "jpg")
                        
                        func request(_ request: UploadRequest, didDownloadProgress progress: Progress) {
                            FileUploadableSpec.downloadProgressValues.append(progress.fractionCompleted)
                        }
                        
                        func request(_ request: UploadRequest, didUploadProgress progress: Progress) {
                            FileUploadableSpec.uploadProgressValues.append(progress.fractionCompleted)
                        }
                        
                        func request(_ request: UploadRequest, didCompleteWithValue value: Data) {
                            FileUploadableSpec.successDelegateCalled = true
                            expect(value).toNot(beNil())
                        }
                        
                        func request(_ request: UploadRequest, didFailWithError error: Error) {
                            FileUploadableSpec.errorDelegateCalled = true
                            fail(error.localizedDescription)
                        }
                    }
                    
                    let request = Upload()
                    
                    // When
                    let operation = request
                        .response { response in
                            
                            // Then
                            if let statusCode = response.response?.statusCode,
                                statusCode != 200 {
                                fail("Response status code should be 200")
                            }
                            
                            expect(response.request).toNot(beNil())
                            expect(response.response).toNot(beNil())
                            expect(response.data).toNot(beNil())
                            expect(response.error).to(beNil())
                            
                            var previousUploadProgress: Double = FileUploadableSpec.uploadProgressValues.first ?? 0.0
                            
                            for uploadProgress in FileUploadableSpec.uploadProgressValues {
                                expect(uploadProgress).to(beGreaterThanOrEqualTo(previousUploadProgress))
                                previousUploadProgress = uploadProgress
                            }
                            
                            if let lastUploadProgressValue = FileUploadableSpec.uploadProgressValues.last {
                                expect(lastUploadProgressValue).to(equal(1.0))
                            } else {
                                fail("last item in progressValues should not be nil")
                            }
                            
                            var previousDownloadProgress: Double = FileUploadableSpec.downloadProgressValues.first ?? 0.0
                            
                            for downloadProgress in FileUploadableSpec.downloadProgressValues {
                                expect(downloadProgress).to(beGreaterThanOrEqualTo(previousDownloadProgress))
                                previousDownloadProgress = downloadProgress
                            }
                            
                            if let lastDownloadProgressValue = FileUploadableSpec.downloadProgressValues.last {
                                expect(lastDownloadProgressValue).to(equal(1.0))
                            } else {
                                fail("last item in progressValues should not be nil")
                            }
                    }
                    
                    operation.completionBlock = {
                        expect(FileUploadableSpec.successDelegateCalled).to(beTrue())
                        expect(FileUploadableSpec.errorDelegateCalled).to(beFalse())
                        done()
                    }
                }
            }
            
        }
    }
    
}
