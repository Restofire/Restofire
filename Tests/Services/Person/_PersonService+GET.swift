//     _____                  ____  __.
//    /  _  \ _____ _______  |    |/ _|____  ___.__.
//   /  /_\  \\__  \\_  __ \ |      < \__  \<   |  |
//  /    |    \/ __ \|  | \/ |    |  \ / __ \\___  |
//  \____|__  (____  /__|    |____|__ (____  / ____|
//          \/     \/                \/    \/\/
//
//  Copyright (c) 2016 RahulKatariya. All rights reserved.
//

import Restofire
import Alamofire

class PersonGETService: RestofireProtocol {

    var path: String = "56c2cc70120000c12673f1b5"

    func executeRequest(completionHandler: Response<Person, NSError> -> Void) { 
        return Restofire().executeRequest(self, completionHandler: completionHandler)
    }

}
