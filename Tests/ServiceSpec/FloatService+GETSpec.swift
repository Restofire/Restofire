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

class FloatGETServiceSpec: ServiceSpec {

    override func spec() {
        describe("FloatGETService") {

            it("executeTask") {

                let actual: Float = 12345.6789
                var expected: Float!

                FloatGETService().executeTask() {
                    if let value = $0.result.value {
                        expected = value as! Float
                    }
                }

                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)

            }
            
            it("executeRequestOperation") {
                
                let actual: Float = 12345.6789
                var expected: Float!
                
                let requestOperation = FloatGETService().requestOperation() {
                    if let value = $0.result.value {
                        expected = value as! Float
                    }
                }
                
                requestOperation.start()
                
                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)
                
            }
            
        }
    }

}
