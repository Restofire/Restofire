//     _____                  ____  __.
//    /  _  \ _____ _______  |    |/ _|____  ___.__.
//   /  /_\  \\__  \\_  __ \ |      < \__  \<   |  |
//  /    |    \/ __ \|  | \/ |    |  \ / __ \\___  |
//  \____|__  (____  /__|    |____|__ (____  / ____|
//          \/     \/                \/    \/\/
//
//  Copyright (c) 2016 RahulKatariya. All rights reserved.
//

import Quick
import Nimble
import Alamofire

class HTTPBinStringGETServiceSpec: ServiceSpec {

    override func spec() {
        describe("HTTPBinStringGETService") {

            it("executeTask") {

                let actual = "Rahul Katariya"
                var expected: String!

                HTTPBinStringGETService(parameters: ["name": "Rahul Katariya"]).executeTask() {
                    if let response = $0.result.value?["args"] as? [String: Any], let value = response["name"] as? String {
                        expected = value
                    }
                }

                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)

            }
            
            it("executeRequestOperation") {
                
                let actual = "Rahul Katariya"
                var expected: String!
                
                let requestOperation = HTTPBinStringGETService(parameters: ["name": "Rahul Katariya"]).requestOperation() {
                    if let response = $0.result.value?["args"] as? [String: Any], let value = response["name"] as? String {
                        expected = value
                    }
                }
                
                requestOperation.start()
                
                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)
                
            }
        }
    }

}
