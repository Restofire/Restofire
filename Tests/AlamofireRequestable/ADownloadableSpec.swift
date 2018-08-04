//
//  ADownloadableSpec.swift
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

class ADownloadableSpec: BaseSpec {
    
    static var startDelegateCalled = false
    
    override func spec() {
        describe("Download") {
            
            it("request should succeed") {
                // Given
                struct Download: ADownloadable {
                    var path: String? = "bytes/\(4 * 1024 * 1024)"
                    var destination: DownloadRequest.Destination?
                    
                    init(destination: @escaping DownloadRequest.Destination) {
                        self.destination = destination
                    }
                    
                    func prepare(_ request: URLRequest, requestable: ARequestable) -> URLRequest {
                        var request = request
                        let header = HTTPHeaders.authorization(username: "user", password: "password")
                        header.forEach {
                            request.setValue($0.value, forHTTPHeaderField: $0.key)
                        }
                        expect(request.value(forHTTPHeaderField: "Authorization"))
                            .to(equal("Basic dXNlcjpwYXNzd29yZA=="))
                        return request
                    }
                    
                    func didSend(_ request: Request, requestable: ARequestable) {
                        expect(request.request?.value(forHTTPHeaderField: "Authorization")!)
                            .to(equal("Basic dXNlcjpwYXNzd29yZA=="))
                        ADownloadableSpec.startDelegateCalled = true
                    }
                    
                }
                
                let request = Download(destination: { _, _ in (BaseSpec.jsonFileURL, []) }).request
                print(request.debugDescription)
                
                expect(ADownloadableSpec.startDelegateCalled).to(beTrue())
                
                var progressValues: [Double] = []
                
                // When
                waitUntil(timeout: self.timeout)  { done in
                    request
                        .downloadProgress { progress in
                            progressValues.append(progress.fractionCompleted)
                        }
                        .response { response in
                            defer { done() }
                            
                            // Then
                            if let statusCode = response.response?.statusCode,
                                statusCode != 200 {
                                fail("Response status code should be 200")
                            }
                            
                            expect(response.request).toNot(beNil())
                            expect(response.response).toNot(beNil())
                            expect(response.fileURL).toNot(beNil())
                            expect(response.resumeData).to(beNil())
                            expect(response.error).to(beNil())
                            
                            var previousProgress: Double = progressValues.first ?? 0.0
                            
                            for progress in progressValues {
                                expect(progress).to(beGreaterThanOrEqualTo(previousProgress))
                                previousProgress = progress
                            }
                            
                            if let lastProgressValue = progressValues.last {
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
