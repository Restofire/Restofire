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

class GenericPersonGETServiceSpec: ServiceSpec {

    override func spec() { 
        describe("GenericPersonGETService") {
            
            it("should succeed") {
                
                let person = Person(id: 12345, name: "Rahul Katariya")
                let actual = GenericResponse(args: person)
                var expected: GenericResponse<Person>!
                
                GenericPersonGETService().executeRequest()
                    .startWithNext {
                        expected = $0
                }
                
                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)
                
            }
        }
    }

}
