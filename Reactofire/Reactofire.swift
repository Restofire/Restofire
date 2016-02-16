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
    public var encoding: Alamofire.ParameterEncoding = .JSON
    public var headers: [String : String]?
    
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
    
}

public class Reactofire {
    
    public init() { }
    
    public func executeRequest<T>(object: ReactofireProtocol) -> SignalProducer<T, NSError> {
        return SignalProducer { sink, disposable in
            
            let request = self.alamofireRequest(object)
            
            request.responseGLOSS(rootKey: object.rootKey) { (response: Response<T, NSError>) -> Void in
                if ReactofireConfiguration.defaultConfiguration.logging {
                    print(request.debugDescription)
                    print(response)
                }
                if let GLOSS = response.result.value {
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
    
    public func executeRequest<T: Decodable>(object: ReactofireProtocol) -> SignalProducer<T, NSError> {
        return SignalProducer { sink, disposable in
            
            let request = self.alamofireRequest(object)
            
            request.responseGLOSS(rootKey: object.rootKey) { (response: Response<T, NSError>) -> Void in
                if ReactofireConfiguration.defaultConfiguration.logging {
                    print(request.debugDescription)
                    print(response)
                }
                if let GLOSS = response.result.value {
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
            
            let request = self.alamofireRequest(object)
            
            request.responseGLOSS(rootKey: object.rootKey) { (response: Response<[T], NSError>) -> Void in
                if ReactofireConfiguration.defaultConfiguration.logging {
                    print(request.debugDescription)
                    print(response)
                }
                if let GLOSS = response.result.value {
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
    
    func alamofireRequest(object: ReactofireProtocol) -> Alamofire.Request {
        var request: Alamofire.Request!
        
        request = Alamofire.request(object.method, object.baseURL + object.path, parameters: object.parameters as? [String: AnyObject], encoding: object.encoding, headers: object.headers + ReactofireConfiguration.defaultConfiguration.headers)
        
        if let parameters = object.parameters as? [AnyObject] where object.method != .GET {
            let encodedURLRequest = self.encode(object, URLRequest: request.request!, parameters: parameters).0
            request = Alamofire.request(encodedURLRequest)
        }

        return request
    }
    
    func encode(object: ReactofireProtocol, URLRequest: URLRequestConvertible, parameters: [AnyObject]?) -> (NSMutableURLRequest, NSError?) {
        let mutableURLRequest = URLRequest.URLRequest
        
        guard let parameters = parameters where !parameters.isEmpty else {
            return (mutableURLRequest, nil)
        }
        
        var encodingError: NSError? = nil
        
        switch object.encoding {
        case .JSON:
            do {
                let options = NSJSONWritingOptions()
                let data = try NSJSONSerialization.dataWithJSONObject(parameters, options: options)
                
                mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                mutableURLRequest.HTTPBody = data
            } catch {
                encodingError = error as NSError
            }
        case .PropertyList(let format, let options):
            do {
                let data = try NSPropertyListSerialization.dataWithPropertyList(
                    parameters,
                    format: format,
                    options: options
                )
                mutableURLRequest.setValue("application/x-plist", forHTTPHeaderField: "Content-Type")
                mutableURLRequest.HTTPBody = data
            } catch {
                encodingError = error as NSError
            }
        default:
            break
        }
        
        return (mutableURLRequest, encodingError)
    }
    
}
