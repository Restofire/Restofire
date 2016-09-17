//: Playground - noun: a place where people can play

import Restofire
import Alamofire

//: Global Configuration
Restofire.defaultConfiguration.baseURL = "http://www.mocky.io/v2/"
Restofire.defaultConfiguration.headers = ["Content-Type": "application/json"]
Restofire.defaultConfiguration.validation.acceptableStatusCodes = Array(200..<201)
Restofire.defaultConfiguration.validation.acceptableContentTypes = ["application/json"]
Restofire.defaultConfiguration.logging = true
Restofire.defaultConfiguration.dataResponseSerializer = Alamofire.DataRequest.jsonResponseSerializer()

let sessionConfiguration = URLSessionConfiguration.default
sessionConfiguration.timeoutIntervalForRequest = 10
sessionConfiguration.timeoutIntervalForResource = 10
sessionConfiguration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
Restofire.defaultConfiguration.sessionManager = Alamofire.SessionManager(configuration: sessionConfiguration)