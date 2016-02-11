//     _____                  ____  __.
//    /  _  \ _____ _______  |    |/ _|____  ___.__.
//   /  /_\  \\__  \\_  __ \ |      < \__  \<   |  |
//  /    |    \/ __ \|  | \/ |    |  \ / __ \\___  |
//  \____|__  (____  /__|    |____|__ (____  / ____|
//          \/     \/                \/    \/\/
//
//  Copyright (c) 2015 RahulKatariya. All rights reserved.
//

import Quick
import Nimble

class PersonGETServiceSpec: ServiceSpec {

    override func spec() { 

        describe("PersonGETService") {

            let requestJSONString = "{\"id\":\"123456789\",\"name\":\"Rahul\"}"
            let requestJSON = try! NSJSONSerialization.JSONObjectWithData(requestJSONString.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as! [String : AnyObject]

            let responseJSONString = "{\"args\":{\"id\":\"123456789\",\"name\":\"Rahul\"}}"
            let responseJSON = try! NSJSONSerialization.JSONObjectWithData(responseJSONString.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as! [String : AnyObject]

            let actual = PersonArgs(json: responseJSON)!
            var expected: PersonArgs!


            it("should Execute", closure: {

                PersonGETService().executeRequest(params: requestJSON)
                    .on(next: {
                        expected = $0
                    })
                    .start()

                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)

            })
        }

    }

}
