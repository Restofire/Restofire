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

class GenericPersonGETService: ReactofireProtocol {

    var path: String = "56c2d24d1200007d2773f1b9"
    var encoding = Alamofire.ParameterEncoding.URLEncodedInURL

    func executeRequest() -> SignalProducer<GenericResponse<Person>, NSError> { 
        return Reactofire().executeRequest(self)
    }

}
