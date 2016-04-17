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

class RootKeyPathGETServiceSpec: ServiceSpec {

    override func spec() {
        describe("RootKeyPathGETService") {

            it("executeTask") {

                let actual = "Restofire is awesome."
                var expected: String!

                RootKeyPathGETService().executeTask() {
                    if let value = $0.result.value as? String {
                        expected = value
                    }
                }

                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)

            }
            
            it("executeRequestOperation") {
                
                let actual = "Restofire is awesome."
                var expected: String!
                
                let requestOperation = RootKeyPathGETService().requestOperation() {
                    if let value = $0.result.value as? String {
                        expected = value
                    }
                }
                
                requestOperation.start()
                
                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)
                
            }
        }
    }

}
