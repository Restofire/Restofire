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

struct GithubLoginGETService: Requestable {
    
    typealias Response = [String: AnyObject]
    var path: String? = "user"
    var headers: [String : String]?
    
    init(user: String, password: String) {
        let auth = Request.authorizationHeader(user: user, password: password)!
        self.headers = [auth.key: auth.value]
    }
    
}

extension GithubLoginGETService {
    
    func didRetryRequest(attempt: Int) {
        
    }
    
    func didCompleteRequestWithDataResponse(_ response: DataResponse<Dictionary<String, AnyObject>>) {
        if response.result.isSuccess {
            let header = response.request!.allHTTPHeaderFields!["Authorization"]!
            Restofire.Configuration.default.headers["Authorization"] = header
            UserDefaults.standard.set(header, forKey: "Authorization")
        }
    }
    
}
