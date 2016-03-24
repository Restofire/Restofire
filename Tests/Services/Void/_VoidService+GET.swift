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

class VoidGETService: RestofireProtocol {

    var path: String = "56c31578120000743173f22e"

    func executeRequest(completionHandler: Response<NSDictionary, NSError> -> Void) {
        return Restofire().executeRequest(self, completionHandler: completionHandler)
    }

}
