//: Playground - noun: a place where people can play

import Restofire
import Alamofire

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

Restofire.defaultConfiguration.scheme = "https://"
Restofire.defaultConfiguration.baseURL = "httpbin.org"

Alamofire.request("https://httpbin.org/get")
    .response { response in
        print(response.response)
}

struct Request: Requestable {
    typealias Response = Any
    var path: String = "get"
}

let request = Request()
request.execute { (response: DefaultDataResponse) in
    print(response.response)
}
