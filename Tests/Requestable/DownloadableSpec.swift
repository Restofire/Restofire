//
//  DownloadableSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Restofire

class DownloadableSpec: BaseSpec {
    
    override func spec() {
        describe("Download") {
            
            it("request should succeed") {
                // Given
                struct Download: Downloadable {
                    var path: String? = "bytes/\(4 * 1024 * 1024)"
                    var destination: DownloadFileDestination?
                    
                    init(destination: @escaping DownloadFileDestination) {
                        self.destination = destination
                    }
                }
                
                let request = Download(destination: { _, _ in (self.jsonFileURL, []) }).request()
                var progressValues: [Double] = []
                
                // When
                waitUntil(timeout: self.timeout)  { done in
                    request
                        .downloadProgress { progress in
                            progressValues.append(progress.fractionCompleted)
                        }
                        .response { response in
                            defer { done() }
                            
                            //Then
                            expect(response.request).to(beNonNil())
                            expect(response.response).to(beNonNil())
                            expect(response.destinationURL).to(beNonNil())
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
