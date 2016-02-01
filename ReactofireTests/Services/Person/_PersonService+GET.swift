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

class PersonGETService: ReactofireProtocol {

    var path: String = "get"
    var parameters: AnyObject?
    var encoding = Alamofire.ParameterEncoding.URLEncodedInURL

    func executeRequest(params params: AnyObject?) -> SignalProducer<PersonArgs, NSError> { 
        parameters = params
        return Reactofire().executeRequest(self)
    }

}
