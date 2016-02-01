//
//  ReactofireTests.swift
//  ReactofireTests
//
//  Created by Rahul Katariya on 07/11/15.
//  Copyright © 2015 AarKay. All rights reserved.
//

import XCTest
import Gloss
import ReactiveCocoa
import Alamofire
@testable import Reactofire

class ReactofireTests: XCTestCase {
    
    class PersonGetService: ReactofireProtocol {
        
        var path: String = "get"
        var parameters: AnyObject?
        var encoding = Alamofire.ParameterEncoding.URLEncodedInURL
        
        func executeRequest() -> SignalProducer<PersonArgs, NSError> {
            let service = PersonGetService()
            service.parameters = ["id" : "123456789", "name" : "Rahul"]
            return Reactofire().executeRequest(service)
        }
    }
    
    struct PersonArgs: Decodable {
        
        let person: Person?
        
        // MARK: - Deserialization
        
        init?(json: JSON) {
            self.person = "args" <~~ json
        }
        
    }
    
    struct Person: Decodable {
        
        let id: String?
        let name: String?
        
        // MARK: - Deserialization
        
        init?(json: JSON) {
            self.id = "id" <~~ json
            self.name = "name" <~~ json
        }
        
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ReactofireConfiguration.defaultConfiguration.baseURL = "http://httpbin.org/"
        ReactofireConfiguration.defaultConfiguration.logging = true
        ReactofireConfiguration.defaultConfiguration.headers = ["Content-Type":"application/json"]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let expectation = expectationWithDescription("GET request should succeed")
        
        PersonGetService().executeRequest()
            .on(next: {
                print($0)
                expectation.fulfill()
            })
            .start()
        
        waitForExpectationsWithTimeout(10, handler: nil)
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
