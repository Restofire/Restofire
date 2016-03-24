//
//  Utils.swift
//  Restofire
//
//  Created by Rahul Katariya on 24/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

class Utils {

    class func alamofireRequest(object: RestofireProtocol) -> Alamofire.Request {
        var request: Alamofire.Request!
        
        //TODO: - Move Configuration.defaultConfiguration.headers Dependency to Extension
        request = Alamofire.request(object.method, object.baseURL + object.path, parameters: object.parameters as? [String: AnyObject], encoding: object.encoding, headers: object.headers + Configuration.defaultConfiguration.headers)
        
        if let parameters = object.parameters as? [AnyObject] where object.method != .GET {
            let encodedURLRequest = self.encode(object, URLRequest: request.request!, parameters: parameters).0
            request = Alamofire.request(encodedURLRequest)
        }
        
        return request
    }
    
    class func encode(object: RestofireProtocol, URLRequest: URLRequestConvertible, parameters: [AnyObject]?) -> (NSMutableURLRequest, NSError?) {
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
