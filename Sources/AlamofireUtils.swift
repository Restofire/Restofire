//
//  AlamofireRequest.swift
//  Restofire
//
//  Created by Rahul Katariya on 19/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

class AlamofireUtils {
    
    static func alamofireRequestFromRequestable<R: Requestable>(_ requestable: R) -> Alamofire.DataRequest {
        
        var request = requestable.sessionManager.request(requestable.baseURL + requestable.path, method: requestable.method, parameters: requestable.parameters as? [String: Any], encoding: requestable.encoding, headers: requestable.headers)
        
        if let parameters = requestable.parameters as? [Any] {
            do {
                let encodedURLRequest = try encode(request.request!, parameters: parameters, encoding: requestable.encoding)
                request = Alamofire.request(encodedURLRequest)
            } catch let error as NSError {
                print("[Restofire] - Encoding Error: " + error.localizedDescription)
            } catch let error as AFError {
                print(error.errorDescription)
            }
        }
        
        authenticateRequest(request, usingCredential: requestable.credential)
        validateRequest(request, forAcceptableContentTypes: requestable.acceptableContentTypes)
        validateRequest(request, forAcceptableStatusCodes: requestable.acceptableStatusCodes)
        validateRequest(request, forValidation: requestable.validationBlock)
        
        return request
        
    }
    
    static func jsonResponseSerializer<M>() -> Alamofire.DataResponseSerializer<M> {
        return Alamofire.DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let validData = data, validData.count > 0 else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: validData, options: .allowFragments)
                if let json = json as? M {
                    return .success(json)
                } else {
                    let error = NSError(domain: "com.rahulkatariya.Restofire", code: -1, userInfo: [NSLocalizedDescriptionKey:"TypeMismatch(Expected \(M.self), got \(type(of: json)))"])
                    return .failure(error)
                }
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
            }
            
        }
    }
    
    fileprivate static func encode(_ urlRequest: URLRequestConvertible, parameters: [Any]?, encoding: ParameterEncoding) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        guard let parameters = parameters , !parameters.isEmpty else {
            return urlRequest
        }
        
        switch encoding {
        case let enc as JSONEncoding:
            do {
                let data = try JSONSerialization.data(withJSONObject: parameters, options: enc.options)
                
                if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
                
                urlRequest.httpBody = data
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
            return urlRequest
        case let enc as PropertyListEncoding:
            do {
                let data = try PropertyListSerialization.data(
                    fromPropertyList: parameters,
                    format: enc.format,
                    options: enc.options
                )
                
                if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                    urlRequest.setValue("application/x-plist", forHTTPHeaderField: "Content-Type")
                }
                
                urlRequest.httpBody = data
            } catch {
                throw AFError.parameterEncodingFailed(reason: .propertyListEncodingFailed(error: error))
            }
            return urlRequest
        default:
            throw NSError(domain: "com.rahulkatariya.Restofire", code: -1, userInfo: [NSLocalizedDescriptionKey: "parameters as array are only implemented in .JSON and .Propertylist parameter encoding. If you think it is an issue, please create one or send a pull request if you can solve it at http://github.com/Restofire/Restofire."])
        }
        
    }
    
    fileprivate static func authenticateRequest(_ request: Alamofire.DataRequest, usingCredential credential:URLCredential?) {
        guard let credential = credential else { return }
        request.authenticate(usingCredential: credential)
    }
    
    fileprivate static func validateRequest(_ request: Alamofire.DataRequest, forAcceptableContentTypes contentTypes:[String]?) {
        guard let contentTypes = contentTypes else { return }
        request.validate(contentType: contentTypes)
    }
    
    fileprivate static func validateRequest(_ request: Alamofire.DataRequest, forAcceptableStatusCodes statusCodes:[CountableRange<Int>]?) {
        guard let statusCodes = statusCodes else { return }
        for statusCode in statusCodes {
            request.validate(statusCode: statusCode)
        }
    }
    
    fileprivate static func validateRequest(_ request: Alamofire.DataRequest, forValidation validation:Alamofire.DataRequest.Validation?) {
        guard let validation = validation else { return }
        request.validate(validation)
    }
    
}

extension Alamofire.DataRequest {
    
    @discardableResult
    func restofireResponse<M>(
        queue: DispatchQueue? = nil,
        responseSerializer: Alamofire.DataResponseSerializer<M>,
        completionHandler: @escaping (Alamofire.DataResponse<M>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: responseSerializer,
            completionHandler: completionHandler
        )
        
    }
    
}
