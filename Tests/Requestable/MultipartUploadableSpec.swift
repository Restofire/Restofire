//
//  MultipartUploadableSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 29/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Alamofire
@testable import Restofire

class MultipartUploadableSpec: BaseSpec {
    
    override func spec() {
        describe("MultipartUpload") {
            
            it("request should succeed") {
                // Given
                struct Upload: MultipartUploadable {
                    var path: String? = "post"
                    var multipartFormData: (MultipartFormData) -> Void = { multipartFormData in
                        multipartFormData.append("français".data(using: .utf8, allowLossyConversion: false)!, withName: "french")
                        multipartFormData.append("日本語".data(using: .utf8, allowLossyConversion: false)!, withName: "japanese")
                    }
                }
                
                // When
                waitUntil(timeout: self.timeout) { done in
                    Upload().request(encodingCompletion: { result in
                        switch result {
                        case .success(let upload, _, _):
                            upload.response { response in
                                defer { done() }
                                
                                //Then
                                expect(response.request).to(beNonNil())
                                expect(response.response).to(beNonNil())
                                expect(response.data).to(beNonNil())
                                expect(response.error).to(beNil())
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
