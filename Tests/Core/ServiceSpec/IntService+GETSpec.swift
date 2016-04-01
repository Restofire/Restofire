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

class IntGETServiceSpec: ServiceSpec {

    override func spec() {
        describe("IntGETService") {

            it("should succeed") {

                let actual = 123456789
                var expected: Int!

                IntGETService().executeTask() { (response: Response<Int, NSError>) in
                    if let value = response.result.value {
                        expected = value
                    }
                }

                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)

            }
        }
    }

}
