//
//  RequestableSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 27/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Restofire

class RequestableSpec: BaseSpec {
    
    struct Request: Requestable {
        typealias Response = Any
        var path: String = ""
    }
    
    override func spec() {
        describe("Requestable") {
            let request = Request()
            
        }
    }
    
}
