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

class StringGETService: RestofireProtocol {

    var path: String = "56c2bcde120000022473f19b"

    func executeRequest(completionHandler: Response<String, NSError> -> Void) { 
        return Restofire().executeRequest(self, completionHandler: completionHandler)
    }

}
