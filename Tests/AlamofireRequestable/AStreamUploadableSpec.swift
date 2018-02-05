//
//  AStreamUploadableSpec.swift
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

class AStreamUploadableSpec: BaseSpec {
    
    static var startDelegateCalled = false
    static var completeDelegateCalled = false

    override func spec() {
        describe("AStreamUpload") {
            
            it("request should succeed") {
                // Given
                struct Upload: AStreamUploadable {
                    var path: String? = "post"
                    var stream: InputStream = InputStream(url: BaseSpec.url(forResource: "rainbow", withExtension: "jpg"))!
                    
                    func didStart(_ request: Request) {
                        AStreamUploadableSpec.startDelegateCalled = true
                    }
                    
                    func didComplete(_ request: Request) {
                        AStreamUploadableSpec.completeDelegateCalled = true
                    }
                    
                }
                
                let request = Upload().request
                print(request.debugDescription)
                
                expect(AStreamUploadableSpec.startDelegateCalled).to(beTrue())
                
                // When
                waitUntil(timeout: self.timeout) { done in
                    request
                        .response { response in
                            defer { done() }
                            
                            // Then
                            expect(AStreamUploadableSpec.completeDelegateCalled).to(beTrue())
                            
                            expect(response.request).toNot(beNil())
                            expect(response.response).toNot(beNil())
                            expect(response.data).toNot(beNil())
                            expect(response.error).to(beNil())
                    }
                }
            }
            
        }
    }
    
}

