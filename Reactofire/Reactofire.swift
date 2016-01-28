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
    
    public var logging: Bool = false
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
    var parameters: AnyObject? { get set }
    var rootKey: String? { get set }
    
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
        get { return [:] }
        set { }
    }
    public var parameters: AnyObject? {
        get { return nil }
        set {}
    }
    public var rootKey: String? {
        get { return nil }
        set {}
    }
    
}

public class Reactofire {
    
    public init() { }
    
    public func executeRequest<T: Decodable>(object: ReactofireProtocol) -> SignalProducer<T, NSError> {
        return SignalProducer { sink, disposable in
            let request = Alamofire.request(object.method, object.baseURL + object.path, parameters: object.parameters as? [String: AnyObject], encoding: object.encoding, headers: object.headers + ReactofireConfiguration.defaultConfiguration.headers)
            
            request.responseGLOSS(rootKey: object.rootKey) { (response: Response<T, NSError>) -> Void in
                if let GLOSS = response.result.value {
                    if ReactofireConfiguration.defaultConfiguration.logging {
                        print(request.debugDescription)
                        print(GLOSS)
                    }
                    sink.sendNext(GLOSS)
                    sink.sendCompleted()
                } else {
                    sink.sendFailed(response.result.error!)
                }
            }
            
            disposable.addDisposable {
                request.task.cancel()
            }
            
        }
    }
    
    public func executeRequest<T: Decodable>(object: ReactofireProtocol) -> SignalProducer<[T], NSError> {
        return SignalProducer { sink, disposable in
            let request = Alamofire.request(object.method, object.baseURL + object.path, parameters: object.parameters as? [String: AnyObject], encoding: object.encoding, headers: object.headers + ReactofireConfiguration.defaultConfiguration.headers)
            
            request.responseGLOSS(rootKey: object.rootKey) { (response: Response<[T], NSError>) -> Void in
                if let GLOSS = response.result.value {
                    if ReactofireConfiguration.defaultConfiguration.logging {
                        print(request.debugDescription)
                        print(GLOSS)
                    }
                    sink.sendNext(GLOSS)
                    sink.sendCompleted()
                } else {
                    sink.sendFailed(response.result.error!)
                }
            }
        
            disposable.addDisposable {
                request.task.cancel()
            }
            
        }
    }
    
}
