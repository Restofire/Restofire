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

struct Repo: Decodable {
    var name: String
}

struct ReposGETService: ARequestable {

    var path: String? = "user/repos"
    var eventually: Bool = true

    var operation: AOperation<ReposGETService> {
        return AOperation(configurable: self, request: self.request)
    }
}
