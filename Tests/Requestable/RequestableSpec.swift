//
//  RequestableSpec.swift
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

class RequestableSpec: BaseSpec {
    
    static var progressValues: [Double] = []
    
    override func spec() {
        describe("Requestable") {
            
            it("request should succeed") {
                // Given
                struct HTTPBin: Decodable {
                    let url: URL
                }
                
                waitUntil(timeout: self.timeout) { done in
                    struct Request: Requestable {
                        typealias Response = HTTPBin
                        
                        var path: String? = "get"
                        var responseSerializer: DataResponseSerializer<HTTPBin> = DataRequest.JSONDecodableResponseSerializer()
                        
                        func request(_ request: DataRequest, didDownloadProgress progress: Progress) {
                            RequestableSpec.progressValues.append(progress.fractionCompleted)
                        }

                        func request(_ request: DataRequest, didCompleteWithValue value: HTTPBin) {
                            expect(value.url.absoluteString).to(equal("https://httpbin.org/get"))
                        }
                        
                        func request(_ request: DataRequest, didFailWithError error: Error) {
                            fail(error.localizedDescription)
                        }
                    }
                    
                    let request = Request()
                    
                    // When
                    request
                        .response { response in
                            defer { done() }
                            
                            // Then
                            if let statusCode = response.response?.statusCode,
                                statusCode != 200 {
                                fail("Response status code should be 200")
                            }
                            
                            expect(response.request).toNot(beNil())
                            expect(response.response).toNot(beNil())
                            expect(response.data).toNot(beNil())
                            expect(response.error).to(beNil())
                            
                            var previousProgress: Double = RequestableSpec.progressValues.first ?? 0.0
                            
                            for progress in RequestableSpec.progressValues {
                                expect(progress).to(beGreaterThanOrEqualTo(previousProgress))
                                previousProgress = progress
                            }
                            
                            if let lastProgressValue = RequestableSpec.progressValues.last {
                                expect(lastProgressValue).to(equal(1.0))
                            } else {
                                fail("last item in progressValues should not be nil")
                            }
                    }
                }
            }
            
        }
    }
    
}

