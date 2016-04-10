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

class StringArrayGETServiceSpec: ServiceSpec {

    override func spec() {
        describe("StringArrayGETService") {

            it("should succeed") {

                let actual = ["Reactofire","is","Awesome"]
                var expected: [String]!

                StringArrayGETService().executeTask() {
                    if let value = $0.result.value {
                        expected = value as! [String]
                    }
                }

                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)

            }
        }
    }

}
