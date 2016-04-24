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

    let timeout: NSTimeInterval = 21
    let pollInterval: NSTimeInterval = 3

    override func spec() {

        beforeSuite {
            Restofire.defaultConfiguration.baseURL = "http://www.mocky.io/v2/"
            Restofire.defaultConfiguration.headers = ["Content-Type": "application/json"]
            Restofire.defaultConfiguration.validation.acceptableStatusCodes = [200..<201]
            Restofire.defaultConfiguration.validation.acceptableContentTypes = ["application/json"]
            Restofire.defaultConfiguration.logging = true
            
            let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
            sessionConfiguration.timeoutIntervalForRequest = 10
            sessionConfiguration.timeoutIntervalForResource = 10
            sessionConfiguration.HTTPAdditionalHeaders = Alamofire.Manager.defaultHTTPHeaders
            Restofire.defaultConfiguration.manager = Alamofire.Manager(configuration: sessionConfiguration)
        }

    }

}
