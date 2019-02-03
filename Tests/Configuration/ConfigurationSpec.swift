//
//  ConfigurationSpec.swift
//  Restofire
//
//  Created by Rahul Katariya on 31/01/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Alamofire
@testable import Restofire

protocol MockyConfigurable: Configurable {}

extension MockyConfigurable {
    
    public var configuration: Restofire.Configuration {
        var mockyConfiguration = Restofire.Configuration()
        mockyConfiguration.scheme = "http"
        mockyConfiguration.host = "mocky.io"
        mockyConfiguration.version = "v2"
        return mockyConfiguration
    }
    
}

protocol MockyRetryable: Retryable {}

extension MockyRetryable {
    
    public var retry: Retry {
        var mockyRetry = Retry()
        mockyRetry.maxRetryAttempts = 100
        mockyRetry.retryInterval = 25
        return mockyRetry
    }
    
}

protocol MockyRequestable: Requestable, MockyConfigurable {}

class ConfigurationSpec: BaseSpec {
    
    override func spec() {
        describe("Configurable") {
            
            it("should use global configuration") {
                // Given
                struct Service: Requestable {
                    typealias Response = Data
                    var path: String? = "get"
                }
                
                let service = Service()
                let urlRequest = try? service.asUrlRequest()
                expect(urlRequest?.url?.absoluteString)
                    .to(equal("https://httpbin.org/get"))
                expect(service.maxRetryAttempts).to(equal(5))
                expect(service.retryInterval).to(equal(10))
            }
            
            it("should apply group configuration") {
                // Given
                struct Service: MockyRequestable {
                    typealias Response = Data
                    var path: String? = "get"
                }
                
                let service = Service()
                let urlRequest = try? service.asUrlRequest()
                expect(urlRequest?.url?.absoluteString)
                    .to(equal("http://mocky.io/v2/get"))
                expect(service.maxRetryAttempts).to(equal(5))
                expect(service.retryInterval).to(equal(10))
            }
            
            it("should apply request configuration") {
                // Given
                struct Service: MockyRequestable, MockyRetryable {
                    typealias Response = Data
                    var scheme: String = "https"
                    var path: String? = "get"
                }
                
                let service = Service()
                let urlRequest = try? service.asUrlRequest()
                expect(urlRequest?.url?.absoluteString)
                    .to(equal("https://mocky.io/v2/get"))
                expect(service.maxRetryAttempts).to(equal(100))
                expect(service.retryInterval).to(equal(25))
            }
            
        }
    }
}

