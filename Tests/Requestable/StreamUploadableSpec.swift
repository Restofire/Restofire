//
//  StreamUploadableSpec.swift
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

class StreamUploadableSpec: BaseSpec {
    
    override func spec() {
        describe("StreamUpload") {
            
            it("request should succeed") {
                // Given
                struct Upload: StreamUploadable {
                    var stream: InputStream = InputStream(url: BaseSpec.url(forResource: "rainbow", withExtension: "jpg"))!
                }
                
                let request = Upload()
                
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

