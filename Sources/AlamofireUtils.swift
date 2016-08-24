//
//  AlamofireRequest.swift
//  Restofire
//
//  Created by Rahul Katariya on 19/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

class AlamofireUtils {
    
    static func alamofireRequestFromRequestable<R: Requestable>(_ requestable: R) -> Alamofire.Request {
        
        var request = requestable.sessionManager.request(requestable.baseURL + requestable.path, withMethod: requestable.method, parameters: requestable.parameters as? [String: AnyObject], encoding: requestable.encoding, headers: requestable.headers)
        
        if let parameters = requestable.parameters as? [AnyObject] {
            let (encodedURLRequest, error) = encodeURLRequest(request.request!, parameters: parameters, encoding: requestable.encoding)
            if let error = error {
                print("[Restofire] - Encoding Error: " + error.localizedDescription)
            } else {
                request = Alamofire.request(encodedURLRequest)
            }
        }
        
        authenticateRequest(request, usingCredential: requestable.credential)
        validateRequest(request, forAcceptableContentTypes: requestable.acceptableContentTypes)
        validateRequest(request, forAcceptableStatusCodes: requestable.acceptableStatusCodes)
        validateRequest(request, forValidation: requestable.validation)
        
        return request
        
    }
    
    static func JSONResponseSerializer<M>() -> ResponseSerializer<M, NSError> {
        return ResponseSerializer { _, _, data, error in
            
            guard error == nil else { return .failure(error!) }
            
            guard let validData = data , validData.count > 0 else {
                let failureReason = "JSON could not be serialized. Input data was nil or zero length."
                let error = NSError(code: .jsonSerializationFailed, failureReason: failureReason)
                return .failure(error)
            }
            
            do {
                let JSON = try JSONSerialization.jsonObject(with: validData, options: .allowFragments)
                if let JSON = JSON as? M {
                    return .success(JSON)
                } else {
                    let error = NSError(domain: "com.rahulkatariya.Restofire", code: -1, userInfo: [NSLocalizedDescriptionKey:"TypeMismatch(Expected \(M.self), got \(type(of: JSON)))"])
                    return .failure(error)
                }
                
            } catch {
                return .failure(error as NSError)
            }
            
        }
    }
    
    fileprivate static func encodeURLRequest(_ URLRequest: URLRequestConvertible, parameters: [AnyObject]?, encoding: ParameterEncoding) -> (URLRequest, NSError?) {
        var mutableURLRequest = URLRequest.urlRequest
        
        guard let parameters = parameters , !parameters.isEmpty else {
            return (mutableURLRequest, nil)
        }
        
        var encodingError: NSError? = nil
        
        switch encoding {
        case .json:
            do {
                let options = JSONSerialization.WritingOptions()
                let data = try JSONSerialization.data(withJSONObject: parameters, options: options)
                
                mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                mutableURLRequest.httpBody = data
            } catch {
                encodingError = error as NSError
            }
        case .propertyList(let format, let options):
            do {
                let data = try PropertyListSerialization.data(
                    fromPropertyList: parameters,
                    format: format,
                    options: options
                )
                mutableURLRequest.setValue("application/x-plist", forHTTPHeaderField: "Content-Type")
                mutableURLRequest.httpBody = data
            } catch {
                encodingError = error as NSError
            }
        default:
            encodingError = NSError(domain: "com.rahulkatariya.Restofire", code: -1, userInfo: [NSLocalizedDescriptionKey: "parameters as array are only implemented in .JSON and .Propertylist parameter encoding. If you think it is an issue, please create one or send a pull request if you can solve it at http://github.com/Restofire/Restofire."])
            break
        }
        
        return (mutableURLRequest, encodingError)
    }
    
    fileprivate static func authenticateRequest(_ request: Alamofire.Request, usingCredential credential:URLCredential?) {
        guard let credential = credential else { return }
        request.authenticate(usingCredential: credential)
    }
    
    fileprivate static func validateRequest(_ request: Alamofire.Request, forAcceptableContentTypes contentTypes:[String]?) {
        guard let contentTypes = contentTypes else { return }
        request.validate(contentType: contentTypes)
    }
    
    fileprivate static func validateRequest(_ request: Alamofire.Request, forAcceptableStatusCodes statusCodes:[CountableRange<Int>]?) {
        guard let statusCodes = statusCodes else { return }
        for statusCode in statusCodes {
            request.validate(statusCode: statusCode)
        }
    }
    
    fileprivate static func validateRequest(_ request: Alamofire.Request, forValidation validation:Alamofire.Request.Validation?) {
        guard let validation = validation else { return }
        request.validate(validation)
    }
    
}

extension Alamofire.Request {
    
    @discardableResult
    func restofireResponse<M>(
        queue: DispatchQueue? = nil,
        responseSerializer: ResponseSerializer<M, NSError>,
        completionHandler: @escaping (Response<M, NSError>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: responseSerializer,
            completionHandler: completionHandler
        )
        
    }
    
}
