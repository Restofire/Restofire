//
//  RequestType.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

public protocol RestofireProtocol {

    associatedtype Model
    var path: String { get set }
    
    //Optionals
    var baseURL: String { get }
    var method: Alamofire.Method { get }
    var encoding: Alamofire.ParameterEncoding { get }
    var headers: [String : String]? { get }
    var parameters: AnyObject? { get set }
    var rootKey: String? { get }
    var logging: Bool { get }
    
}

public extension RestofireProtocol {
    
    public var baseURL: String {
        get { return Configuration.defaultConfiguration.baseURL }
    }
    
    public var method: Alamofire.Method {
        get { return Configuration.defaultConfiguration.method }
    }
    
    public var encoding: Alamofire.ParameterEncoding {
        get { return Configuration.defaultConfiguration.encoding }
    }
    
    public var headers: [String: String]? {
        get { return Configuration.defaultConfiguration.headers }
    }
    
    public var parameters: AnyObject? {
        get { return nil }
        set {}
    }
    
    public var rootKey: String? {
        get { return Configuration.defaultConfiguration.rootKey }
    }
    
    public var logging: Bool {
        get { return Configuration.defaultConfiguration.logging }
    }
    
    public func executeRequest(completionHandler: Response<Model, NSError> -> Void) {
        let request = self.alamofireRequest()
        request.responseGLOSS(rootKey: self.rootKey) { (response: Response<Model, NSError>) -> Void in
            completionHandler(response)
            //TODO: - Better Logging
            if self.logging {
                print(response.request.debugDescription)
                print(response.timeline)
                print(response.response)
                if response.result.isSuccess {
                    print(response.result.value!)
                } else {
                    print(response.result.error!)
                }
            }
        }
    }
    
}

extension RestofireProtocol {
    
    private func alamofireRequest() -> Alamofire.Request {
        var request: Alamofire.Request!
        
        request = Alamofire.request(self.method, self.baseURL + self.path, parameters: self.parameters as? [String: AnyObject], encoding: self.encoding, headers: self.headers)
        
        if let parameters = self.parameters as? [AnyObject] where self.method != .GET {
            let encodedURLRequest = self.encodeURLRequest(request.request!, parameters: parameters).0
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
        
        switch self.encoding {
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
