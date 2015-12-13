//
//  Reactofire.swift
//  Reactofire
//
//  Created by Rahul Katariya on 23/10/15.
//  Copyright © 2015 AarKay. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveCocoa
import Gloss

public class ReactofireConfiguration {
    
    public static let defaultConfiguration = ReactofireConfiguration()
    
    public var baseURL: String!
    public var encoding: Alamofire.ParameterEncoding
    public var headers: [String : String]?
    
    init() {
        encoding = .JSON
    }
    
}

public protocol ReactofireProtocol {
    
    var baseURL: String { get set }
    var path: String { get set }
    var method: Alamofire.Method { get set }
    var encoding: Alamofire.ParameterEncoding { get set }
    var headers: [String : String]? { get set }
    var parameters: [String : AnyObject]? { get set }
}

public extension ReactofireProtocol {
    
    public var baseURL: String {
        get { return ReactofireConfiguration.defaultConfiguration.baseURL }
        set {}
    }
    public var method: Alamofire.Method {
        get { return .GET }
        set {}
    }
    public var encoding: Alamofire.ParameterEncoding {
        get { return ReactofireConfiguration.defaultConfiguration.encoding }
        set {}
    }
    public var headers: [String: String]? {
        get { return ReactofireConfiguration.defaultConfiguration.headers }
        set { headers = newValue } //TODO:+ ReactofireConfiguration.defaultConfiguration.headers }
    }
    public var parameters: [String: AnyObject]? {
        get { return nil }
        set {}
    }
    
}

public class Reactofire {
    
    public init() { }
    
    public func executeRequest<T: Gloss.Decodable>(rootKey:String? = nil, object: ReactofireProtocol) -> SignalProducer<T, NSError> {
        return SignalProducer { sink, disposable in
            let request = Alamofire.request(object.method, object.baseURL + object.path, parameters: object.parameters, encoding: object.encoding, headers: object.headers)
            
            print(request.debugDescription)
            
            request.responseGLOSS(rootKey: rootKey, completionHandler: { (response: Response<T, NSError>) -> Void in
                if let GLOSS = response.result.value {
                    sink.sendNext(GLOSS)
                    sink.sendCompleted()
                } else {
                    sink.sendFailed(response.result.error!)
                }
            })
            
        }
    }
    
    public func executeRequest<T: Gloss.Decodable>(rootKey:String? = nil, object: ReactofireProtocol) -> SignalProducer<[T], NSError> {
        return SignalProducer { sink, disposable in
            let request = Alamofire.request(object.method, object.baseURL + object.path, parameters: object.parameters, encoding: object.encoding, headers: object.headers)
            
            print(request.debugDescription)
            
            request.responseGLOSS(rootKey: rootKey, completionHandler: { (response: Response<[T], NSError>) -> Void in
                if let GLOSS = response.result.value {
                    sink.sendNext(GLOSS)
                    sink.sendCompleted()
                } else {
                    sink.sendFailed(response.result.error!)
                }
            })
            
            
        }
    }
    
}
