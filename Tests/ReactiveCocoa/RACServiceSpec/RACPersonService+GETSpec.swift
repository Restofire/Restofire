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
import ReactiveCocoa

class RACPersonGETServiceSpec: RACServiceSpec {

    override func spec() {
        describe("RACPersonGETService") {

            it("should succeed") {

                let actual: NSDictionary = ["id": 12345, "name": "Rahul Katariya"]
                var expected: [String: AnyObject]!

                let service: SignalProducer<Response<[String: AnyObject], NSError>, NSError> = PersonGETService().executeTask()
                service.startWithNext {
                    expected = $0.result.value
                }

                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)

            }
        }
    }

}
