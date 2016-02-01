## Reactofire [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Reactofire is a protocol oriented networking library in swift that is built on top of Alamofire, Gloss and ReactiveCocoa to use services in a declartive way

## Requirements

- iOS 8.0+
- Xcode 7.0+

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Reactofire into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "RahulKatariya/Reactofire" ~> 0.1
```

## Usage

### Configuring
```swift
import Reactofire

class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.

    ReactofireConfiguration.defaultConfiguration.baseURL = "http://httpbin.org/"
    ReactofireConfiguration.defaultConfiguration.headers = ["Content-Type": "application/json"]
    ReactofireConfiguration.defaultConfiguration.logging = true

    return true
  }

}
```
### Creating a Gloss Object
```swift

import Gloss

struct PersonArgs: Glossy {

    var args: Person

    init(args: Person) {
        self.args = args
    }

    init?(json: JSON) {
        guard let args: Person = "args" <~~ json else { return nil }

        self.args = args
    }

    func toJSON() -> JSON? {
        return jsonify([
            "args" ~~> self.args
        ])
    }

}

struct Person: Glossy {

    var id: String
    var name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    init?(json: JSON) {
        guard let id: String = "id" <~~ json,
            let name: String = "name" <~~ json else { return nil }

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

## TODO

- [x] Add Default Protocol Implementations in Swift 2.0
- [ ] Add Authentication
- [ ] Add Request Validations
- [ ] Add Download Task
- [ ] Add Upload Task


## License

Reactofire is released under the MIT license. See LICENSE for details.
