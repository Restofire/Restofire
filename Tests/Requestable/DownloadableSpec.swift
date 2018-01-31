//
//  DownloadableSpec.swift
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

class DownloadableSpec: BaseSpec {
    
    static var progressValues: [Double] = []
    static var successDelegateCalled = false
    static var errorDelegateCalled = false
    
    override func spec() {
        describe("Downloadable") {
            
            it("request should succeed") {
                // Given
                struct HTTPBin: Decodable {
                    let url: URL
                }
                
                waitUntil(timeout: self.timeout) { done in
                    struct Request: Downloadable {
                        typealias Response = HTTPBin
                        
                        var path: String? = "get"
                        var destination: DownloadFileDestination? = { _, _ in (BaseSpec.jsonFileURL, []) }
                        
                        var responseSerializer: DownloadResponseSerializer<HTTPBin> = DownloadRequest.JSONDecodableResponseSerializer()
                        
                        func request(_ request: DownloadRequest, didDownloadProgress progress: Progress) {
                            DownloadableSpec.progressValues.append(progress.fractionCompleted)
                        }
                        
                        func request(_ request: DownloadRequest, didCompleteWithValue value: HTTPBin) {
                            DownloadableSpec.successDelegateCalled = true
                            expect(value.url.absoluteString).to(equal("https://httpbin.org/get"))
                        }
                        
                        func request(_ request: DownloadRequest, didFailWithError error: Error) {
                            DownloadableSpec.errorDelegateCalled = true
                            fail(error.localizedDescription)
                        }
                    }
                    
                    let request = Request()
                    
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
                            expect(response.destinationURL).toNot(beNil())
                            expect(response.resumeData).to(beNil())
                            expect(response.error).to(beNil())
                    }
                    
                    operation.completionBlock = {
                        expect(DownloadableSpec.successDelegateCalled).to(beTrue())
                        expect(DownloadableSpec.errorDelegateCalled).to(beFalse())
                        
                        var previousProgress: Double = DownloadableSpec.progressValues.first ?? 0.0
                        
                        for progress in DownloadableSpec.progressValues {
                            expect(progress).to(beGreaterThanOrEqualTo(previousProgress))
                            previousProgress = progress
                        }
                        
                        if let lastProgressValue = DownloadableSpec.progressValues.last {
                            expect(lastProgressValue).to(equal(1.0))
                        } else {
                            fail("last item in progressValues should not be nil")
                        }
                        
                        done()
                    }
                }
            }
            
        }
    }
    
}


