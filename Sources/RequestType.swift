//
//  RequestType.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

public protocol RequestType: class {

    var path: String { get set }
    
    //Optionals
    var baseURL: String { get }
    var method: Alamofire.Method { get }
    var encoding: Alamofire.ParameterEncoding { get }
    var headers: [String : String]? { get }
    var parameters: AnyObject? { get }
    var rootKeyPath: String? { get }
    var logging: Bool { get }
    
    var configuration: Configuration { get }
    
}

public extension RequestType {

    public var configuration: Configuration {
        get { return Configuration.defaultConfiguration }
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
    
}

public extension RequestType {
    
    public func executeRequest<Model: Any>(completionHandler: Result<Model, NSError> -> Void) {
        request.response(rootKeyPath: rootKeyPath) { [weak self] (response: Response<Model, NSError>) -> Void in
            completionHandler(response.result)
            guard let weakSelf = self else { return }
            if weakSelf.logging { debugPrint(response) }
        }
    }
    
}

public extension RequestType {
    
    public var request: Alamofire.Request {
        var request: Alamofire.Request!
        
        request = Alamofire.request(method, baseURL + path, parameters: parameters as? [String: AnyObject], encoding: encoding, headers: headers)
        
        if let parameters = parameters as? [AnyObject] where method != .GET {
            let encodedURLRequest = encodeURLRequest(request.request!, parameters: parameters).0
            request = Alamofire.request(encodedURLRequest)
        }
        
        return request
    }
    
    private func encodeURLRequest(URLRequest: URLRequestConvertible, parameters: [AnyObject]?) -> (NSMutableURLRequest, NSError?) {
        let mutableURLRequest = URLRequest.URLRequest
        
        guard let parameters = parameters where !parameters.isEmpty else {
            return (mutableURLRequest, nil)
        }
        
        var encodingError: NSError? = nil
        
        switch encoding {
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
