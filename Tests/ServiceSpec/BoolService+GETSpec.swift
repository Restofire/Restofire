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
            
            it("executeTask") {
                
                let actual = true
                var expected: Bool!
                
                BoolGETService().executeTask() {
                    if let value = $0.result.value as? Bool {
                        expected = value
                    }
                }
                
                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)
                
            }
            
            it("executeRequestOperation") {
                
                let actual = true
                var expected: Bool!
                
                let requestOperation = BoolGETService().requestOperation() {
                    if let value = $0.result.value as? Bool {
                        expected = value
                    }
                }
                
                requestOperation.start()
                
                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)
                
            }
            
            it("executeRequestOperation__withoutCompletionHandler") {
                
                let actual = true
                
                let requestOperation = BoolGETService().requestOperation()
                requestOperation.start()
                
                expect(requestOperation.finished).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)
                
            }
        }
    }

}
