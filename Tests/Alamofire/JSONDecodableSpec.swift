//
//  JSONDecodableSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Restofire

class JSONDecodableSpec: BaseSpec {

    override func spec() {
        describe("JSONDecodable") {
            
            it("request should decode json response to decodable object") {
                // Given
                struct Response: Decodable {
                    let url: URL
                }
                
                struct Request: Requestable {
                    var path: String? = "get"
                }
                
                let request = Request().request()
                
                // When
                waitUntil(timeout: self.timeout) { done in
                    request.responseJSONDecodable(completionHandler: { (response: DataResponse<Response>) in
                        defer { done() }
                        
                        //Then
                        expect(response.request).to(beNonNil())
                        expect(response.response).to(beNonNil())
                        expect(response.result.value?.url.absoluteString)
                            .to(equal("https://httpbin.org/get"))
                        expect(response.data).to(beNonNil())
                        expect(response.error).to(beNil())
                    })
                }
            }
            
        }
    }

}
