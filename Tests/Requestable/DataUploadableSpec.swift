//
//  DataUploadableSpec.swift
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

class DataUploadableSpec: BaseSpec {
    
    static var successDelegateCalled = false
    static var errorDelegateCalled = false
    
    override func spec() {
        describe("DataUploadable") {
            
            it("request should succeed") {
                
                waitUntil(timeout: self.timeout) { done in
                    struct Upload: DataUploadable {
                        
                        typealias Response = Data
                        var path: String? = "post"
                        var data: Data = {
                            return "Lorem ipsum dolor sit amet, consectetur adipiscing elit.".data(using: .utf8, allowLossyConversion: false)!
                        }()
                        
                        func request(_ request: UploadOperation<Upload>, didCompleteWithValue value: Data) {
                            DataUploadableSpec.successDelegateCalled = true
                            expect(value).toNot(beNil())
                        }
                        
                        func request(_ request: UploadOperation<Upload>, didFailWithError error: Error) {
                            DataUploadableSpec.errorDelegateCalled = true
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
                            
                    }
                    
                    operation.completionBlock = {
                        expect(DataUploadableSpec.successDelegateCalled).to(beTrue())
                        expect(DataUploadableSpec.errorDelegateCalled).to(beFalse())
                        done()
                    }
                }
            }
            
        }
    }
    
}
