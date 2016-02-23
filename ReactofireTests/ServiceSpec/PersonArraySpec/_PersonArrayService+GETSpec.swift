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

class PersonArrayGETServiceSpec: ServiceSpec {

    override func spec() { 
        describe("PersonArrayGETService") {
            
            it("should succeed") {
                
                let actual = [
                                Person(id: 12345, name: "Rahul Katariya"),
                                Person(id: 12346, name: "Aar Kay")
                            ]
                var expected: [Person]!
                
                PersonArrayGETService().executeRequest()
                    .startWithNext {
                        expected = $0
                }
                
                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)
                
            }
        }
    }

}
