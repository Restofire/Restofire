## Reactofire

[![Travis](https://img.shields.io/travis/RahulKatariya/Reactofire.svg)](https://img.shields.io/travis/RahulKatariya/Reactofire.svg)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/Reactofire.svg)](https://img.shields.io/cocoapods/v/Reactofire.svg)
[![Platforms](https://img.shields.io/cocoapods/p/Reactofire.svg)](http://cocoapods.org/pods/Reactofire)
[![License](https://img.shields.io/cocoapods/l/Reactofire.svg)](https://raw.githubusercontent.com/rahulkatariya/Reactofire/master/LICENSE)

Reactofire is a protocol oriented networking library in swift that is built on top of Alamofire, Gloss and ReactiveCocoa to use services in a declartive way

## Requirements

- iOS 8.0+ / Mac OS X 10.9+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 7.2+

## Installation

* [CocoaPods](https://github.com/RahulKatariya/Reactofire/wiki/Installation-Guide#cocoapods)
* [Carthage](https://github.com/RahulKatariya/Reactofire/wiki/Installation-Guide#carthage)
* [Swift Package Manager](https://github.com/RahulKatariya/Reactofire/wiki/Installation-Guide#swift-package-manager)

## Usage

### Configuring
```swift
import Reactofire

class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.

    ReactofireConfiguration.defaultConfiguration.baseURL = "http://www.mocky.io/v2/"
    ReactofireConfiguration.defaultConfiguration.headers = ["Content-Type": "application/json"]
    ReactofireConfiguration.defaultConfiguration.logging = true

    return true
  }

}
```
### Creating a Gloss Object
```swift

import Gloss

struct Person: Glossy {

    var id: String
    var name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    init?(json: JSON) {
        guard let id: String = "args.id" <~~ json,
            let name: String = "args.name" <~~ json else { return nil }

        self.id = id
        self.name = name
    }

    func toJSON() -> JSON? {
        return jsonify([
            "id" ~~> self.id,
            "name" ~~> self.name
        ])
    }

}

extension Person: Equatable { }

func == (lhs: Person, rhs: Person) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
}
```

### Creating a Get Service
```swift
import Reactofire
import Alamofire
import ReactiveCocoa

class PersonGETService: ReactofireProtocol {

    var path: String = "get"
    var parameters: AnyObject?
    var encoding = Alamofire.ParameterEncoding.URLEncodedInURL

    func executeRequest(params params: AnyObject?) -> SignalProducer<PersonArgs, NSError> {
        parameters = params
        return Reactofire().executeRequest(self)
    }

}
```

### Calling a Service
```swift
import Restofire
import Alamofire
import ReactiveCocoa

class ViewController: UIViewController {

  var person: PersonArgs!

  override func viewDidLoad {
      super.viewDidLoad()
      PersonGETService().executeRequest(params: ["id" : "123456789", "name" : "Rahul"])
          .on(next: {
              person = $0
          })
          .start()
  }

}
```

## Examples

* [String Response Service](https://github.com/RahulKatariya/Reactofire/wiki/String-Response-Service-Example)
* [Int Response Service](https://github.com/RahulKatariya/Reactofire/wiki/Int-Response-Service-Example)
* [Float Response Service](https://github.com/RahulKatariya/Reactofire/wiki/Float-Response-Service-Example)
* [Bool Response Service](https://github.com/RahulKatariya/Reactofire/wiki/Bool-Response-Service-Example)
* [Void Response Service](https://github.com/RahulKatariya/Reactofire/wiki/Void-Response-Service-Example)
* [Array Response Service](https://github.com/RahulKatariya/Reactofire/wiki/Array-Response-Service-Example)
* [Gloss Response Service](https://github.com/RahulKatariya/Reactofire/wiki/Gloss-Response-Service-Example)
* [Gloss Array Response Service](https://github.com/RahulKatariya/Reactofire/wiki/Gloss-Array-Response-Service-Example)

## TODO

- [x] Add Default Protocol Implementations in Swift 2.0
- [ ] Add Authentication
- [ ] Add Request Validations
- [ ] Add Download Task
- [ ] Add Upload Task


## License

Reactofire is released under the MIT license. See [LICENSE](https://github.com/RahulKatariya/Reactofire/blob/master/LICENSE) for details.
