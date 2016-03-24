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

class GenericPersonGETService: RestofireProtocol {

    var path: String = "56c2d24d1200007d2773f1b9"

    func executeRequest(completionHandler: Response<GenericResponse<Person>, NSError> -> Void) {
        return Restofire().executeRequest(self, completionHandler: completionHandler)
    }

}
