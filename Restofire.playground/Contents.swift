//: Playground - noun: a place where people can play

import UIKit
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

//: Creating a Service

import Restofire

struct PersonGETService: Requestable {
    
    typealias Model = [String: Any]
    var path: String = "56c2cc70120000c12673f1b5"
    
}



//: Consuming the Service

import Restofire

class ViewController: UIViewController {
    
    var person: [String: Any]!
    var requestOp: DataRequestOperation<PersonGETService>!
    
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


//: URL Level Configuration

protocol HTTPBinConfigurable: Configurable { }

extension HTTPBinConfigurable {
    
    var configuration: Configuration {
        var config = Configuration()
        config.baseURL = "https://httpbin.org/"
        config.logging = Restofire.defaultConfiguration.logging
        return config
    }
    
}

protocol HTTPBinValidatable: Validatable { }

extension HTTPBinValidatable {
    
    var validation: Validation {
        var validation = Validation()
        validation.acceptableStatusCodes = Array(200..<300)
        validation.acceptableContentTypes = ["application/json"]
        return validation
    }
    
}


protocol HTTPBinRetryable: Retryable { }

extension HTTPBinRetryable {
    
    var retry: Retry {
        var retry = Retry()
        retry.retryErrorCodes = [.timedOut,.networkConnectionLost]
        retry.retryInterval = 20
        retry.maxRetryAttempts = 10
        return retry
    }
    
}



//: Creating the Service

import Restofire
import Alamofire

struct HTTPBinPersonGETService: Requestable, HTTPBinConfigurable, HTTPBinValidatable, HTTPBinRetryable {
    
    typealias Model = [String: Any]
    let path: String = "get"
    let encoding: ParameterEncoding = URLEncoding.default
    var parameters: Any?
    
    init(parameters: Any?) {
        self.parameters = parameters
    }
    
}




//: Consuming the Service

import Restofire

class PersonViewController: UIViewController {
    
    var person: [String: Any]!
    var requestOp: DataRequestOperation<HTTPBinPersonGETService>!
    
    func getPerson() {
        requestOp = HTTPBinPersonGETService(parameters: ["name": "Rahul Katariya"]).executeTask() {
            if let value = $0.result.value {
                self.person = value
            }
        }
    }
    
    deinit {
        requestOp.cancel()
    }
    
}


//: Request Level Configuration

import Restofire
import Alamofire

struct MoviesReviewGETService: Requestable {
    
    typealias Model = Any
    var host: String = "http://api.nytimes.com/svc/movies/v2/"
    var path: String = "reviews/"
    var parameters: Any?
    var encoding: ParameterEncoding = URLEncoding.default
    var method: Alamofire.HTTPMethod = .get
    var headers: [String: String]? = ["Content-Type": "application/json"]
    var manager: Alamofire.SessionManager = {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 7
        sessionConfiguration.timeoutIntervalForResource = 7
        sessionConfiguration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return Alamofire.SessionManager(configuration: sessionConfiguration)
    }()
    var queue: DispatchQueue? = DispatchQueue.main
    var logging: Bool = Restofire.defaultConfiguration.logging
    var credential: URLCredential? = URLCredential(user: "user", password: "password", persistence: .forSession)
    var acceptableStatusCodes: [Int]? = Array(200..<300)
    var acceptableContentTypes: [String]? = ["application/json"]
    var retryErrorCodes: Set<URLError.Code> = [.timedOut,.networkConnectionLost]
    var retryInterval: TimeInterval = 20
    var maxRetryAttempts: Int = 10
    
    init(path: String, parameters: Any) {
        self.path += path
        self.parameters = parameters
    }
    
}


//: RequestEventually Service

import Restofire

class MoviesReviewTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MoviesReviewGETService(path: "all.json", parameters: ["api-key":"sample-key"])
            .executeTaskEventually()
        
        
    }
    
}
