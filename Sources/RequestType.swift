//
//  RequestType.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import enum Alamofire.Method
import enum Alamofire.ParameterEncoding

public protocol RestofireProtocol {
    
    var baseURL: String { get set }
    var path: String { get set }
    var method: Alamofire.Method { get set }
    var encoding: Alamofire.ParameterEncoding { get set }
    var headers: [String : String]? { get set }
    var parameters: AnyObject? { get set }
    var rootKey: String? { get set }
    var logging: Bool { get set }
    
}

public extension RestofireProtocol {
    
    public var baseURL: String {
        get { return Configuration.defaultConfiguration.baseURL }
        set {}
    }
    public var method: Alamofire.Method {
        get { return .GET }
        set {}
    }
    public var encoding: Alamofire.ParameterEncoding {
        get { return Configuration.defaultConfiguration.encoding }
        set {}
    }
    public var headers: [String: String]? {
        get { return nil }
        set {}
    }
    public var parameters: AnyObject? {
        get { return nil }
        set {}
    }
    public var rootKey: String? {
        get { return nil }
        set {}
    }
    public var logging: Bool {
        get { return Configuration.defaultConfiguration.logging }
        set {}
    }
    
}
