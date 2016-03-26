//
//  RestofireSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 01/02/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Quick
import Nimble
@testable import Restofire

class RestofireSpec: QuickSpec {
    
    override func spec() {
        
        beforeEach { 
            Configuration.defaultConfiguration.baseURL = "http://www.mocky.io/v2/"
            Configuration.defaultConfiguration.headers = ["Content-Type": "application/json"]
            Configuration.defaultConfiguration.logging = true
        }
        
        describe("I dont Know") {
            
            class SampleService: RequestType {
                var path: String = "Yo/"
                var headers: [String : String]?
                
                func execute() -> Void {
                    path = path + "Yo"
                    headers = ["ContentType": "application/json"]
                }
            }
            
            it("Dont Know") {
                let service = SampleService()
                service.execute()
                
                expect(service.path).to(equal("Yo/Yo"))
                expect(service.baseURL).to(equal("http://www.mocky.io/v2/"))
                expect(service.headers).to(equal(["Content-Type": "application/json", "ContentType": "application/json"]))
            }
            
        }
        
    }
    
}
