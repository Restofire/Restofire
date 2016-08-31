//: Playground - noun: a place where people can play

import UIKit
import Alamofire
import Restofire

Restofire.defaultConfiguration.baseURL = "http://www.mocky.io/v2/"
Restofire.defaultConfiguration.headers = ["Content-Type": "application/json"]
Restofire.defaultConfiguration.logging = true
Restofire.defaultConfiguration.authentication.credential = URLCredential(user: "user", password: "password", persistence: .forSession)
Restofire.defaultConfiguration.validation.acceptableStatusCodes = [200..<300]
Restofire.defaultConfiguration.validation.acceptableContentTypes = ["application/json"]
Restofire.defaultConfiguration.retry.retryErrorCodes = [.timedOut,.networkConnectionLost]
Restofire.defaultConfiguration.retry.retryInterval = 20
Restofire.defaultConfiguration.retry.maxRetryAttempts = 10
let sessionConfiguration = URLSessionConfiguration.default
sessionConfiguration.timeoutIntervalForRequest = 7
sessionConfiguration.timeoutIntervalForResource = 7
sessionConfiguration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
Restofire.defaultConfiguration.sessionManager = Alamofire.SessionManager(configuration: sessionConfiguration)

struct PersonGETService: Requestable {
    
    typealias Model = [String: Any]
    var path: String = "56c2cc70120000c12673f1b5"
    
}

class ViewController: UIViewController {
    
    var person: [String: Any]!
    var requestOp: RequestOperation<PersonGETService>!
    
    func getPerson() {
        requestOp = PersonGETService().executeTask() {
            if let value = $0.result.value {
                self.person = value
            }
        }
    }
    
    deinit {
        requestOp.cancel()
    }
    
}


