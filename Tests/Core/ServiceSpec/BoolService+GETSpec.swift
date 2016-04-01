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

class BoolGETServiceSpec: ServiceSpec {

    override func spec() {
        describe("BoolGETService") {

            it("should succeed") {

                let actual = true
                var expected: Bool!

                BoolGETService().executeTask() { (response: Response<Bool, NSError>) in
                    if let value = response.result.value {
                        expected = value
                    }
                }
                
                

                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)

            }
        }
    }

}
