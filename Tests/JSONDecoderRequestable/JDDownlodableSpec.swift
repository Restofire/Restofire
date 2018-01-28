//
//  JDDownloadableSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Restofire

class JDDownlodableSpec: BaseSpec {
    
    override func spec() {
        describe("JDRequestable") {
            
            it("request should decode json response to decodable object") {
                // Given
                struct HTTPBin: Decodable {
                    let url: URL
                }
                
                struct Download: JDDownloadable {
                    typealias Response = HTTPBin
                    var path: String? = "get"
                    var destination: DownloadFileDestination?
                    
                    init(destination: @escaping DownloadFileDestination) {
                        self.destination = destination
                    }
                }
                
                let request = Download(destination: { _, _ in (self.jsonFileURL, []) })
                
                // When
                waitUntil(timeout: self.timeout)  { done in
                    request
                        .response { response in
                            defer { done() }
                            //Then
                            expect(response.request).to(beNonNil())
                            expect(response.response).to(beNonNil())
                            expect(response.destinationURL).to(beNonNil())
                            expect(response.resumeData).to(beNil())
                            expect(response.error).to(beNil())
                    }
                }
            }
            
        }
    }
    
}

