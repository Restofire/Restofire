//
//  DataUploadableSpec.swift
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

class DataUploadableSpec: BaseSpec {
    
    override func spec() {
        describe("DataUpload") {
            
            it("request should succeed") {
                // Given
                struct Upload: DataUploadable {
                    var path: String? = "post"
                    var data: Data = {
                        var text = ""
                        for _ in 1...3_000 {
                            text += "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                        }
                        
                        return text.data(using: .utf8, allowLossyConversion: false)!
                    }()
                }
                
                let request = Upload()
                var uploadProgressValues: [Double] = []
                var downloadProgressValues: [Double] = []
                
                // When
                waitUntil(timeout: self.timeout) { done in
                    request.response { response in
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

