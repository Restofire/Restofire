## Reactofire

[![Travis](https://img.shields.io/travis/RahulKatariya/Reactofire.svg)](https://img.shields.io/travis/RahulKatariya/Reactofire.svg)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/Reactofire.svg)](https://img.shields.io/cocoapods/v/Reactofire.svg)
[![Platforms](https://img.shields.io/cocoapods/p/Reactofire.svg)](http://cocoapods.org/pods/Reactofire)
[![License](https://img.shields.io/cocoapods/l/Reactofire.svg)](https://raw.githubusercontent.com/rahulkatariya/Reactofire/master/LICENSE)

Reactofire is a protocol oriented networking library in swift that is built on top of Alamofire, Gloss and ReactiveCocoa to use services in a declartive way

## Requirements

- iOS 8.0+ / Mac OS X 10.10+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 7.2+

## Installation

* [CocoaPods](https://github.com/RahulKatariya/Reactofire/wiki/Installation-Guide#cocoapods)
* [Carthage](https://github.com/RahulKatariya/Reactofire/wiki/Installation-Guide#carthage)
* [Swift Package Manager](https://github.com/RahulKatariya/Reactofire/wiki/Installation-Guide#swift-package-manager)

## Usage

* [Configuring Reactofire](https://github.com/RahulKatariya/Reactofire/wiki/Configuring-Reactofire)
* [Creating Gloss Models](https://github.com/RahulKatariya/Reactofire/wiki/Creating-Gloss-Models)
* [Creating Reactofire Service](https://github.com/RahulKatariya/Reactofire/wiki/Creating-Reactofire-Service)

## Examples

* [String Response Service](https://github.com/RahulKatariya/Reactofire/wiki/String-Response-Service-Example)

    ```json
    "Reactofire is Awesome"
    ```
* [Int Response Service](https://github.com/RahulKatariya/Reactofire/wiki/Int-Response-Service-Example)

    ```json
    123456789
    ```
* [Float Response Service](https://github.com/RahulKatariya/Reactofire/wiki/Float-Response-Service-Example)

    ```json
    12345.6789
    ```
* [Bool Response Service](https://github.com/RahulKatariya/Reactofire/wiki/Bool-Response-Service-Example)

    ```json
    true
    ```
* [Void Response Service](https://github.com/RahulKatariya/Reactofire/wiki/Void-Response-Service-Example)

    ```json
    {}
    ```
* [Array Response Service](https://github.com/RahulKatariya/Reactofire/wiki/Array-Response-Service-Example)

    ```json
    ["Reactofire","is","Awesome"]
    ```
* [Gloss Response Service](https://github.com/RahulKatariya/Reactofire/wiki/Gloss-Response-Service-Example)

    ```json
    {
      "id" : 12345,
      "name" : "Rahul Katariya"
    }
    ```
* [Gloss Array Response Service](https://github.com/RahulKatariya/Reactofire/wiki/Gloss-Array-Response-Service-Example)

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

## TODO

- [x] Add Default Protocol Implementations in Swift 2.0
- [ ] Add Authentication
- [ ] Add Request Validations
- [ ] Add Download Task
- [ ] Add Upload Task


## License

Reactofire is released under the MIT license. See [LICENSE](https://github.com/RahulKatariya/Reactofire/blob/master/LICENSE) for details.
