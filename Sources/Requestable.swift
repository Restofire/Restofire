//
//  Requestable.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation
import Alamofire

public protocol Requestable {

    var path: String { get set }
    
    //Optionals
    var baseURL: String { get }
    var method: Alamofire.Method { get }
    var encoding: Alamofire.ParameterEncoding { get }
    var headers: [String : String]? { get }
    var parameters: AnyObject? { get }
    var rootKeyPath: String? { get }
    var logging: Bool { get }
    var sessionConfiguration: NSURLSessionConfiguration { get }
    
    var configuration: Configuration { get }
    
}

public extension Requestable {

    public var configuration: Configuration {
        get { return Restofire.defaultConfiguration }
    }
    
    public var baseURL: String {
        get { return configuration.baseURL }
    }
    
    public var method: Alamofire.Method {
        get { return configuration.method }
    }
    
    public var encoding: Alamofire.ParameterEncoding {
        get { return configuration.encoding }
    }
    
    public var headers: [String: String]? {
        get { return configuration.headers }
    }
    
    public var parameters: AnyObject? {
        get { return nil }
    }
    
    public var rootKeyPath: String? {
        get { return configuration.rootKeyPath }
    }
    
    public var logging: Bool {
        get { return configuration.logging }
    }
    
    public var sessionConfiguration: NSURLSessionConfiguration {
        get { return configuration.sessionConfiguration }
    }
    
}

public extension Requestable {
    
    public func executeTask(completionHandler: Response<AnyObject, NSError> -> Void) {
        let request = Request(requestable: self)
        request.executeTask { (response: Response<AnyObject, NSError>) in
            completionHandler(response)
        }
    }
    
    public func executeTaskEvenually(completionHandler: Response<AnyObject, NSError> -> Void) {
        let request = Request(requestable: self)
        request.executeTaskEventually { (response: Response<AnyObject, NSError>) in
            completionHandler(response)
        }
    }

}
