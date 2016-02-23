## Reactofire



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

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build Reactofire 0.3.0+.

To integrate Reactofire into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Reactofire', '~> 0.3'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Reactofire into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "RahulKatariya/Reactofire" ~> 0.2
```
### Swift Package Manager

To use Reactofire as a [Swift Package Manager](https://swift.org/package-manager/) package just add the following in your Package.swift file.

``` swift
import PackageDescription

let package = Package(
    name: "HelloReactofire",
    dependencies: [
        .Package(url: "https://github.com/RahulKatariya/Reactofire.git", majorVersion: 0)
    ]
)
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

## TODO

- [x] Add Default Protocol Implementations in Swift 2.0
- [ ] Add Authentication
- [ ] Add Request Validations
- [ ] Add Download Task
- [ ] Add Upload Task


## License

Reactofire is released under the MIT license. See LICENSE for details.
