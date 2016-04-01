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
import Alamofire

class PersonGETServiceSpec: ServiceSpec {

    override func spec() {
        describe("PersonGETService") {

            it("should succeed") {

                let actual: NSDictionary = ["id": 12345, "name": "Rahul Katariya"]
                var expected: [String: AnyObject]!

                PersonGETService().executeTask() { (result: Result<[String: AnyObject], NSError>) in
                    if let value = result.value {
                        expected = value
                    }
                }

                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)

            }
        }
    }

}
