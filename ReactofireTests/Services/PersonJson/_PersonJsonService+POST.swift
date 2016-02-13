//     _____                  ____  __.
//    /  _  \ _____ _______  |    |/ _|____  ___.__.
//   /  /_\  \\__  \\_  __ \ |      < \__  \<   |  |
//  /    |    \/ __ \|  | \/ |    |  \ / __ \\___  |
//  \____|__  (____  /__|    |____|__ (____  / ____|
//          \/     \/                \/    \/\/
//
//  Copyright (c) 2015 RahulKatariya. All rights reserved.
//

import Reactofire
import Alamofire
import ReactiveCocoa

class PersonJsonPOSTService: ReactofireProtocol {

    var path: String = "post"
    var method = Alamofire.Method.POST
    var parameters: AnyObject?

    func executeRequest(params params: AnyObject?) -> SignalProducer<PersonJson, NSError> { 
        parameters = params
        return Reactofire().executeRequest(self)
    }

}
