//
//  FileUploadableSpec.swift
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

class FileUploadableSpec: BaseSpec {
    
    override func spec() {
        describe("FileUpload") {
            
            it("request should succeed") {
                // Given
                struct Upload: FileUploadable {
                    let url: URL = BaseSpec.url(forResource: "rainbow", withExtension: "jpg")
                }
                
                let request = Upload()
                var uploadProgressValues: [Double] = []
                var downloadProgressValues: [Double] = []
                
                // When
                waitUntil(timeout: self.timeout) { done in
                    request
                        .response { response in
                            defer { done() }
                            
                            //Then
                            expect(response.request).to(beNonNil())
                            expect(response.response).to(beNonNil())
                            expect(response.data).to(beNonNil())
                            expect(response.error).to(beNil())
                    }
                }
            }
            
        }
    }
    
}
