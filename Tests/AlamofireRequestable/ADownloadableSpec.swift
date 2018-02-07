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
    static var completeDelegateCalled = false
    
    override func spec() {
        describe("Download") {
            
            it("request should succeed") {
                // Given
                struct Download: ADownloadable {
                    var path: String? = "bytes/\(4 * 1024 * 1024)"
                    var destination: DownloadFileDestination?
                    
                    init(destination: @escaping DownloadFileDestination) {
                        self.destination = destination
                    }
                    
                    func prepare(_ request: URLRequest, requestable: Configurable) -> URLRequest {
                        var request = request
                        let header = Request.authorizationHeader(user: "user", password: "password")!
                        request.setValue(header.value, forHTTPHeaderField: header.key)
                        return request
                    }
                    
                    func didSend(_ request: Request, requestable: Configurable) {
                        expect(request.request?.value(forHTTPHeaderField: "Authorization"))
                            .to(equal("Basic dXNlcjpwYXNzd29yZA=="))
                        ADownloadableSpec.startDelegateCalled = true
                    }
                    
                    func didComplete(_ request: Request, requestable: Configurable) {
                        ADownloadableSpec.completeDelegateCalled = true
                    }
                    
                }
                
                let request = Download(destination: { _, _ in (BaseSpec.jsonFileURL, []) }).request()
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
                            expect(ADownloadableSpec.completeDelegateCalled).to(beTrue())
                            
                            if let statusCode = response.response?.statusCode,
                                statusCode != 200 {
                                fail("Response status code should be 200")
                            }
                            
                            expect(response.request).toNot(beNil())
                            expect(response.response).toNot(beNil())
                            expect(response.destinationURL).toNot(beNil())
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
