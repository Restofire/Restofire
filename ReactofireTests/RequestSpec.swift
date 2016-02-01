//
//  RequestSpec.swift
//  Reactofire
//
//  Created by Rahul Katariya on 01/02/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Quick
import Nimble
import Gloss
import ReactiveCocoa
import Alamofire
@testable import Reactofire

class RequestSpec: ReactofireSpec {
    
    override func spec() {
        
        describe("Request") {
            
            it("PersonGetRequest should succeed", closure: { () -> () in
                var person: PersonArgs!
                
                PersonGETService().executeRequest(params: ["id" : "123456789", "name" : "Rahul"])
                    .on(next: {
                        person = $0
                    })
                    .start()
                
                expect(person?.args).toEventually(equal(Person(id: "123456789", name: "Rahul")), timeout: 10, pollInterval: 3)
                
            })
            
        }
        
    }
    
}