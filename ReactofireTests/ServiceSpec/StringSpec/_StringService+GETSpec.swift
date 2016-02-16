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

class StringGETServiceSpec: ServiceSpec {

    override func spec() {
        describe("StringGetService") {
            
            it("should succeed") {
                
                let actual = "Reactofire is Awesome"
                var expected: String!
                
                StringGETService().executeRequest()
                    .startWithNext {
                        expected = $0
                    }
                
                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)
                
            }
        }
    }

}
