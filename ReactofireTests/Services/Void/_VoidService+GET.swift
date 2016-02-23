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

class VoidGETService: ReactofireProtocol {

    var path: String = "56c31578120000743173f22e"

    func executeRequest() -> SignalProducer<Dictionary<String, String>, NSError> { 
        return Reactofire().executeRequest(self)
    }

}
