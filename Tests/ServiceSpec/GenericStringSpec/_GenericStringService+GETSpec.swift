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

class GenericStringGETServiceSpec: ServiceSpec {

    override func spec() { 
        describe("GenericStringGETService") {
            
            it("should succeed") {
                
                let actual = GenericResponse(args: "Reactofire is Awesome")
                var expected: GenericResponse<String>!
                
                GenericStringGETService().executeRequest() {
                    if let value = $0.result.value {
                        expected = value
                    }
                }
                
                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)
                
            }
        }
    }

}
