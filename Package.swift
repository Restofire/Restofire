// swift-tools-version:5.3
//
//  Restofire.swift
//  Restofire
//
//  Created by Rahul Katariya on 23/10/15.
//  Copyright © 2015-present RahulKatariya. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import PackageDescription

let package = Package(
    name: "Restofire",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        .library(name: "Restofire", targets: ["Restofire"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.1")),
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "3.1.2")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "9.0.0")),
    ],
    targets: [
        .target(
            name: "Restofire",
            dependencies: ["Alamofire"],
            path: "Sources"
        ),
        .testTarget(
            name: "RestofireTests",
            dependencies: [
                "Restofire",
                "Quick",
                "Nimble",
            ],
            path: "Tests"
        ),
    ],
    swiftLanguageVersions: [.v4, .v5]
)
