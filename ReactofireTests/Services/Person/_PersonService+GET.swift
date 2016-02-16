//     _____                  ____  __.
//    /  _  \ _____ _______  |    |/ _|____  ___.__.
//   /  /_\  \\__  \\_  __ \ |      < \__  \<   |  |
//  /    |    \/ __ \|  | \/ |    |  \ / __ \\___  |
//  \____|__  (____  /__|    |____|__ (____  / ____|
//          \/     \/                \/    \/\/
//
//  Copyright (c) 2016 RahulKatariya. All rights reserved.
//

import Reactofire
import Alamofire
import ReactiveCocoa

class PersonGETService: ReactofireProtocol {

    var path: String = "56c2cc70120000c12673f1b5"
    var encoding = Alamofire.ParameterEncoding.URLEncodedInURL

    func executeRequest() -> SignalProducer<Person, NSError> { 
        return Reactofire().executeRequest(self)
    }

}
