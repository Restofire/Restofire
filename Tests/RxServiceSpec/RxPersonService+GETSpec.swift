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
import RxSwift

class RXPersonGETServiceSpec: RXServiceSpec {
    
    override func spec() {
        describe("RACPersonGETService") {
            
            it("should succeed") {
            
                let disposeBag = DisposeBag()
                
                let actual: NSDictionary = ["id": 12345, "name": "Rahul Katariya"]
                var expected: [String: AnyObject]!
                
                PersonGETService().executeRequest()
                    .subscribe(onNext: {
                        expected = $0
                    }).addDisposableTo(disposeBag)
                
                expect(expected).toEventually(equal(actual), timeout: self.timeout, pollInterval: self.pollInterval)
                
            }
        }
    }
    
}
