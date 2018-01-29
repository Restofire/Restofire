//: Playground - noun: a place where people can play

import Restofire
import Alamofire
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

/// Alamofire
Alamofire.request("https://httpbin.org/get").responseJSON { response in
    print("Alamofire: -", response.value ?? "nil")
}

/// Restofire
Configuration.default.baseURL = "httpbin.org"

struct GetService: ARequestable {
    var path: String? = "get"
}

GetService().request().responseJSON { response in
    print("Restofire: -", response.value ?? "nil")
}
