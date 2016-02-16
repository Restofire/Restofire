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

class FloatGETService: ReactofireProtocol {

    var path: String = "56c2bfd61200006c2473f1a0"
    var encoding = Alamofire.ParameterEncoding.URLEncodedInURL

    func executeRequest() -> SignalProducer<Float, NSError> { 
        return Reactofire().executeRequest(self)
    }

}
