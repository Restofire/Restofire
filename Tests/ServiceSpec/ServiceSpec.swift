//     _____                  ____  __.
//    /  _  \ _____ _______  |    |/ _|____  ___.__.
//   /  /_\  \\__  \\_  __ \ |      < \__  \<   |  |
//  /    |    \/ __ \|  | \/ |    |  \ / __ \\___  |
//  \____|__  (____  /__|    |____|__ (____  / ____|
//          \/     \/                \/    \/\/
//
//  Copyright (c) 2015 RahulKatariya. All rights reserved.
//

import Quick
import Nimble
import Alamofire
@testable import Restofire

class ServiceSpec: QuickSpec {

    let timeout: TimeInterval = 21
    let pollInterval: TimeInterval = 3

    override func spec() {

        beforeSuite {
            Restofire.defaultConfiguration.baseURL = "www.mocky.io"
            Restofire.defaultConfiguration.version = "v2"
            Restofire.defaultConfiguration.headers = ["Content-Type": "application/json"]
            Restofire.defaultConfiguration.validation.acceptableStatusCodes = Array(200..<201)
            Restofire.defaultConfiguration.validation.acceptableContentTypes = ["application/json"]
            Restofire.defaultConfiguration.dataResponseSerializer = Alamofire.DataRequest.jsonResponseSerializer()
            
            let sessionConfiguration = URLSessionConfiguration.default
            sessionConfiguration.timeoutIntervalForRequest = 10
            sessionConfiguration.timeoutIntervalForResource = 10
            sessionConfiguration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
            Restofire.defaultConfiguration.sessionManager = Alamofire.SessionManager(configuration: sessionConfiguration)
        }

    }

}
