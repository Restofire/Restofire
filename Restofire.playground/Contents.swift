//: Playground - noun: a place where people can play

import Restofire
import Alamofire
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

Alamofire.request("https://httpbin.org/get")
    .response { response in
        print(response.response)
}

Configuration.default.scheme = "https://"
Configuration.default.baseURL = "httpbin.org"

struct RequestGETService: Requestable {
    typealias Response = Any
    var path: String = "get"
}

let service = RequestGETService()
service.request().response { response in
    print(response.response)
}
