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

class PersonArrayGETServiceSpec: ServiceSpec {

    override func spec() {
        describe("PersonArrayGETService") {

            it("should succeed") {

                let actual: [NSDictionary] = [
                    ["id": 12345, "name": "Rahul Katariya"],
                    ["id": 12346, "name": "Aar Kay"]
                ]
                var expected: [[String: AnyObject]]!

                PersonArrayGETService().executeTask() {
                    if let value = $0.result.value {
                        expected = value as! [[String : AnyObject]]
                    }
                }

                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)

            }
        }
    }

}
