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

                let actual: [String: Any] = ["name": "Rahul Katariya"]
                var expected: NSDictionary!

                HTTPBinStringGETService(queryParameters: ["name": "Rahul Katariya"]).executeTask() {
                    if let response = $0.result.value, let value = response["args"] as? [String: Any] {
                        expected = NSDictionary(dictionary: value)
                    }
                }

                expect(expected).toEventually(equal(NSDictionary(dictionary: actual)), timeout: self.timeout, pollInterval: self.pollInterval)

            }
            
            it("executeRequestOperation") {
                
                let actual: [String: Any] = ["name": "Rahul Katariya"]
                var expected: NSDictionary!
                
                let requestOperation = HTTPBinStringGETService(queryParameters: ["name": "Rahul Katariya"]).requestOperation() {
                    if let response = $0.result.value, let value = response["args"] as? [String: Any] {
                        expected = NSDictionary(dictionary: value)                    }
                }
                
                requestOperation.start()
                
                expect(expected).toEventually(equal(NSDictionary(dictionary: actual)), timeout: self.timeout, pollInterval: self.pollInterval)
                
            }
        }
    }

}
