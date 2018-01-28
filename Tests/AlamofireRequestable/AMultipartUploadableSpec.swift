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
@testable import Restofire

class AMultipartUploadableSpec: BaseSpec {
  
    override func spec() {
        describe("AMultipartUpload") {
            
            it("request should succeed") {
                // Given
                struct Upload: AMultipartUploadable {
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

