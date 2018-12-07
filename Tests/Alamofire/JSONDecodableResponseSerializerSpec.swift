//
//  JSONDecodableResponseSerializerSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Alamofire
@testable import Restofire

class JSONDecodableResponseSerializerSpec: BaseSpec {

    override func spec() {
        describe("JSONDecodable") {
            
            it("request should decode json response to decodable object") {
                // Given
                struct HTTPBin: Decodable {
                    let url: URL
                }
                
                struct Service: ARequestable {
                    var path: String? = "get"
                }
                
                let request = Service().request
                print(request.debugDescription)
                
                // When
                waitUntil(timeout: self.timeout) { done in
                    request.responseDecodable(completionHandler: { (response: DataResponse<HTTPBin>) in
                        defer { done() }
                        
                        // Then
                        expect(response.request).toNot(beNil())
                        expect(response.response).toNot(beNil())
                        expect(response.result.value?.url.absoluteString)
                            .to(equal("https://httpbin.org/get"))
                        expect(response.data).toNot(beNil())
                        expect(response.error).to(beNil())
                    })
                }
            }
            
        }
    }

}
