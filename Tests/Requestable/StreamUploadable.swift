//
//  StreamUploadable.swift
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

class StreamUploadableSpec: BaseSpec {
    
    static var downloadProgressValues: [Double] = []
    static var uploadProgressValues: [Double] = []
    static var successDelegateCalled = false
    static var errorDelegateCalled = false
    
    override func spec() {
        describe("StreamUploadable") {
            
            it("request should succeed") {
                
                waitUntil(timeout: self.timeout) { done in
                    struct Upload: StreamUploadable {
                        
                        typealias Response = Data
                        var path: String? = "post"
                        let stream: InputStream = InputStream(url: BaseSpec.url(forResource: "rainbow", withExtension: "jpg"))!
                        
                        func request(_ request: UploadRequest, didDownloadProgress progress: Progress) {
                            StreamUploadableSpec.downloadProgressValues.append(progress.fractionCompleted)
                        }
                        
                        func request(_ request: UploadRequest, didUploadProgress progress: Progress) {
                            StreamUploadableSpec.uploadProgressValues.append(progress.fractionCompleted)
                        }
                        
                        func request(_ request: UploadRequest, didCompleteWithValue value: Data) {
                            StreamUploadableSpec.successDelegateCalled = true
                            expect(value).toNot(beNil())
                        }
                        
                        func request(_ request: UploadRequest, didFailWithError error: Error) {
                            StreamUploadableSpec.errorDelegateCalled = true
                            fail(error.localizedDescription)
                        }
                    }
                    
                    let request = Upload()
                    
                    // When
                    let operation = request
                        .response { response in
                            
                            // Then
                            expect(response.request).toNot(beNil())
                            expect(response.response).toNot(beNil())
                            expect(response.data).toNot(beNil())
                            expect(response.error).to(beNil())
                    }
                    
                    operation.completionBlock = {
                        expect(StreamUploadableSpec.successDelegateCalled).to(beTrue())
                        expect(StreamUploadableSpec.errorDelegateCalled).to(beFalse())
                        done()
                    }
                }
            }
            
        }
    }
    
}
