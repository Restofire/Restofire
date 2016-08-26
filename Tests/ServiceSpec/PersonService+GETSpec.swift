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

class PersonGETServiceSpec: ServiceSpec {

    override func spec() {
        describe("PersonGETService") {

            it("executeTask") {

                let actual: [String: Any] = ["id": 12345, "name": "Rahul Katariya"]
                var expected: [String: Any]!

                PersonGETService().executeTask() {
                    if let value = $0.result.value {
                        expected = value
                    }
                }

                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)

            }
            
            it("executeRequestOperation") {
                
                let actual: [String: Any] = ["id": 12345, "name": "Rahul Katariya"]
                var expected: [String: Any]!
                
                let requestOperation = PersonGETService().requestOperation() {
                    if let value = $0.result.value {
                        expected = value
                    }
                }
                
                requestOperation.start()
                
                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)
                
            }
        }
    }

}
