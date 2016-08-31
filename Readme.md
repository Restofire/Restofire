![Restofire: A Protocol Oriented Networking Abstraction Layer in Swift](https://raw.githubusercontent.com/Restofire/Restofire/master/.github/restofire.png)

## Restofire

[![Platforms](https://img.shields.io/cocoapods/p/Restofire.svg)](https://cocoapods.org/pods/Restofire)
[![License](https://img.shields.io/cocoapods/l/Restofire.svg)](https://raw.githubusercontent.com/Restofire/Restofire/master/LICENSE)

[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/Restofire.svg)](https://cocoapods.org/pods/Restofire)

[![Travis](https://img.shields.io/travis/Restofire/Restofire/master.svg)](https://travis-ci.org/Restofire/Restofire/branches)

[![Join the chat at https://gitter.im/Restofire/Restofire](https://badges.gitter.im/Restofire/Restofire.svg)](https://gitter.im/Restofire/Restofire?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Restofire is a protocol oriented network abstraction layer in swift that is built on top of [Alamofire](https://github.com/Alamofire/Alamofire) to use services in a declartive way.

## Features

- [x] No Learning Curve
- [x] Default Configuration for Base URL / headers / parameters etc
- [x] Multiple Configurations
- [x] Single Request Configuration
- [x] Custom Response Serializer
- [x] Authentication
- [x] Response Validations
- [x] Request NSOperation
- [x] RequestEventuallyOperation with Auto Retry
- [x] [Complete Documentation](http://cocoadocs.org/docsets/Restofire)
- [x] [Tutorial](http://blog.rahulkatariya.me/2016/05/11/getting-started-swifter-http-networking-with-restofire/)

## Requirements

- iOS 8.0+ / Mac OS X 10.9+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 7.3+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build Restofire 1.1.0+.

To integrate Restofire into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Restofire', '~> 1.1'
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

To integrate Restofire into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "RahulKatariya/Restofire" ~> 1.1
```
### Swift Package Manager

To use Restofire as a [Swift Package Manager](https://swift.org/package-manager/) package just add the following in your Package.swift file.

``` swift
import PackageDescription

let package = Package(
    name: "HelloRestofire",
    dependencies: [
        .Package(url: "https://github.com/Restofire/Restofire.git", versions: Version(1, 1, 0)..<Version(1, 2, 0))
    ]
)
```
### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate Restofire into your project manually.

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

```bash
$ git init
```

- Add Restofire as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

```bash
$ git submodule add https://github.com/Restofire/Restofire.git
$ git submodule update --init --recursive
```

- Open the new `Restofire` folder, and drag the `Restofire.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `Restofire.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `Restofire.xcodeproj` folders each with two different versions of the `Restofire.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from.

- Select the `Restofire.framework`.

- And that's it!

> The `Restofire.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

---

### Manually
1. Install [Alamofire](https://github.com/Alamofire/Alamofire)
2. Download and drop ```/Sources```folder in your project.  
3. Congratulations! 

## Usage

### Global Configuration

```swift
import Restofire

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        Restofire.defaultConfiguration.baseURL = "http://www.mocky.io/v2/"
        Restofire.defaultConfiguration.headers = ["Content-Type": "application/json"]
        Restofire.defaultConfiguration.logging = true
        Restofire.defaultConfiguration.authentication.credential = NSURLCredential(user: "user", password: "password", persistence: .ForSession)
        Restofire.defaultConfiguration.validation.acceptableStatusCodes = [200..<300]
        Restofire.defaultConfiguration.validation.acceptableContentTypes = ["application/json"]
        Restofire.defaultConfiguration.retry.retryErrorCodes = [NSURLErrorTimedOut,NSURLErrorNetworkConnectionLost]
        Restofire.defaultConfiguration.retry.retryInterval = 20
        Restofire.defaultConfiguration.retry.maxRetryAttempts = 10
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfiguration.timeoutIntervalForRequest = 7
        sessionConfiguration.timeoutIntervalForResource = 7
        sessionConfiguration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        Restofire.defaultConfiguration.manager = Alamofire.Manager(configuration: sessionConfiguration)

        return true
  }

}
```

### Creating a Service

```swift

import Restofire

struct PersonGETService: Requestable {

    typealias Model = [String: AnyObject]
    var path: String = "56c2cc70120000c12673f1b5"

}

```

### Consuming the Service

```swift
import Restofire

class ViewController: UIViewController {

    var person: [String: AnyObject]!
    var requestOp: RequestOperation<PersonGETService>!

    func getPerson() {
        requestOp = PersonGETService().executeTask() {
            if let value = $0.result.value {
                person = value
            }
        }
    }

    deinit {
        requestOp.cancel()
    }

}
```

### URL Level Configuration

```swift

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
    validation.acceptableStatusCodes = [200..<300]
    validation.acceptableContentTypes = ["application/json"]
    return validation
  }

}


protocol HTTPBinRetryable: Retryable { }

extension HTTPBinRetryable {

  var retry: Retry {
    var retry = Retry()
    retry.retryErrorCodes = [NSURLErrorTimedOut,NSURLErrorNetworkConnectionLost]
    retry.retryInterval = 20
    retry.maxRetryAttempts = 10
    return retry
  }

}

```

### Creating the Service

```swift

import Restofire
import Alamofire

struct HTTPBinPersonGETService: Requestable, HTTPBinConfigurable, HTTPBinValidatable, HTTPBinRetryable {

    typealias Model = [String: AnyObject]
    let path: String = "get"
    let encoding: ParameterEncoding = .URLEncodedInURL
    var parameters: AnyObject?

    init(parameters: AnyObject?) {
        self.parameters = parameters
    }

}


```

### Consuming the Service

```swift
import Restofire

class ViewController: UIViewController {

    var person: [String: AnyObject]!
    var requestOp: RequestOperation<PersonGETService>!

    func getPerson() {
        requestOp = HTTPBinPersonGETService(parameters: ["name": "Rahul Katariya"]).executeTask() {
            if let value = $0.result.value {
                person = value
            }
        }
    }

    deinit {
        requestOp.cancel()
    }

}
```

### Request Level Configuration

```swift

import Restofire
import Alamofire

struct MoviesReviewGETService: Requestable {

    typealias Model = AnyObject
    var baseURL: String = "http://api.nytimes.com/svc/movies/v2/"
    var path: String = "reviews/"
    var parameters: AnyObject?
    var encoding: ParameterEncoding = .URLEncodedInURL
    var method: Alamofire.Method = .GET
    var headers: [String: String]? = ["Content-Type": "application/json"]
    var manager: Alamofire.Manager = {
      let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
      sessionConfiguration.timeoutIntervalForRequest = 7
      sessionConfiguration.timeoutIntervalForResource = 7
      sessionConfiguration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
      return Alamofire.Manager(configuration: sessionConfiguration)
    }()
    var queue: dispatch_queue_t? = dispatch_get_main_queue()
    var logging: Bool = Restofire.defaultConfiguration.logging
    var credential: NSURLCredential? = NSURLCredential(user: "user", password: "password", persistence: .ForSession)
    var acceptableStatusCodes: [Range<Int>]? = [200..<300]
    var acceptableContentTypes: [String]? = ["application/json"]
    var retryErrorCodes: Set<Int> = [NSURLErrorTimedOut,NSURLErrorNetworkConnectionLost]
    var retryInterval: NSTimeInterval = 20
    var maxRetryAttempts: Int = 10

    init(path: String, parameters: AnyObject) {
        self.path += path
        self.parameters = parameters
    }

}

// MARK: - Caching
import RealmSwift
import SwiftyJSON

extension MoviesReviewGETService {

    func didCompleteRequestWithResponse(response: Response<Model, NSError>) {
        guard let model = response.result.value else { return }
        let realm = try! Realm()
        let jsonMovieReview = JSON(model)
        if let results = jsonMovieReview["results"].array {
            for result in results {
                let movieReview = MovieReview()
                movieReview.displayTitle = result["display_title"].stringValue
                movieReview.summary = result["summary_short"].stringValue
                try! realm.write {
                    realm.add(movieReview, update: true)
                }
            }
        }
    }

}

```

### RequestEventually Service

```swift

import Restofire

class MoviesReviewTableViewController: UITableViewController {

  let realm = try! Realm()
  var results: Results<MovieReview>!
  var notificationToken: NotificationToken? = nil

  override func viewDidLoad() {
      super.viewDidLoad()

      MoviesReviewGETService(path: "all.json", parameters: ["api-key":"sample-key"])
          .executeTaskEventually()

      results = realm.objects(MovieReview)

      notificationToken = results.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
          guard let _self = self else { return }
          switch changes {
          case .Initial, .Update(_, deletions: _, insertions: _, modifications: _):
              _self.results = _self.realm.objects(MovieReview)
              _self.tableView.reloadData()
          default:
              break
          }
      }

  }

  deinit {
      notificationToken = nil
  }

}

```

## Examples

* [String Response Service](https://github.com/Restofire/Restofire/wiki/String-Response-Service-Example)

    ```json
    "Restofire is Awesome"
    ```
* [Int Response Service](https://github.com/Restofire/Restofire/wiki/Int-Response-Service-Example)

    ```json
    123456789
    ```
* [Float Response Service](https://github.com/Restofire/Restofire/wiki/Float-Response-Service-Example)

    ```json
    12345.6789
    ```
* [Bool Response Service](https://github.com/Restofire/Restofire/wiki/Bool-Response-Service-Example)

    ```json
    true
    ```
* [Void Response Service](https://github.com/Restofire/Restofire/wiki/Void-Response-Service-Example)

    ```json
    {}
    ```
* [Array Response Service](https://github.com/Restofire/Restofire/wiki/Array-Response-Service-Example)

    ```json
    ["Restofire","is","Awesome"]
    ```
* [JSON Response Service](https://github.com/Restofire/Restofire/wiki/JSON-Response-Service-Example)

    ```json
    {
      "id" : 12345,
      "name" : "Rahul Katariya"
    }
    ```
* [JSON Array Response Service](https://github.com/Restofire/Restofire/wiki/JSON-Array-Response-Service-Example)

    ```json
    [
      {
        "id" : 12345,
        "name" : "Rahul Katariya"
      },
      {
        "id" : 12346,
        "name" : "Aar Kay"
      }
    ]
    ```

## License

Restofire is released under the MIT license. See [LICENSE](https://github.com/Restofire/Restofire/blob/master/LICENSE) for details.
