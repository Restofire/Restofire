//
//  Alamofire+GlossResponseSerializer.swift
//  Reactofire
//
//  Created by Rahul Katariya on 31/10/15.
//  Copyright © 2015 AarKay. All rights reserved.
//

import Alamofire
import Gloss

// MARK: - GLOSS

extension Request {
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter options:           The GLOSS serialization reading options. `.AllowFragments` by default.
     - parameter completionHandler: A closure to be executed once the request has finished.
     
     - returns: The request.
     */
    public func responseGLOSS<T>(
        rootKey rootKey: String? = nil,
        options: NSJSONReadingOptions = .AllowFragments,
        completionHandler: Response<T, NSError> -> Void)
        -> Self
    {
        return response(
            responseSerializer: Request.GLOSSResponseSerializer(rootKey: rootKey, options: options),
            completionHandler: completionHandler
        )
    }
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter options:           The GLOSS serialization reading options. `.AllowFragments` by default.
     - parameter completionHandler: A closure to be executed once the request has finished.
     
     - returns: The request.
     */
    public func responseGLOSS<T: Decodable>(
        rootKey rootKey: String? = nil,
        options: NSJSONReadingOptions = .AllowFragments,
        completionHandler: Response<T, NSError> -> Void)
        -> Self
    {
        return response(
            responseSerializer: Request.GLOSSResponseSerializer(rootKey: rootKey, options: options),
            completionHandler: completionHandler
        )
    }
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter options:           The GLOSS serialization reading options. `.AllowFragments` by default.
     - parameter completionHandler: A closure to be executed once the request has finished.
     
     - returns: The request.
     */
    public func responseGLOSS<T: Decodable>(
        rootKey rootKey: String? = nil,
        options: NSJSONReadingOptions = .AllowFragments,
        completionHandler: Response<[T], NSError> -> Void)
        -> Self
    {
        return response(
            responseSerializer: Request.GLOSSResponseSerializer(rootKey: rootKey, options: options),
            completionHandler: completionHandler
        )
    }
    
    /**
     Creates a response serializer that returns a GLOSS object constructed from the response data using
     `NSJSONSerialization` with the specified reading options.
     
     - parameter options: The GLOSS serialization reading options. `.AllowFragments` by default.
     
     - returns: A GLOSS object response serializer.
     */
    public static func GLOSSResponseSerializer<T>(
        rootKey rootKey: String? = nil,
        options: NSJSONReadingOptions = .AllowFragments)
        -> ResponseSerializer<T, NSError>
    {
        return ResponseSerializer { _, _, data, error in
            guard error == nil else { return .Failure(error!) }
            
            guard let validData = data where validData.length > 0 else {
                let failureReason = "JSON could not be serialized. Input data was nil or zero length."
                let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            do {
                let JSONObject = try NSJSONSerialization.JSONObjectWithData(validData, options: options)
                var value: T?
                if let rootKey = rootKey where JSONObject is [String: AnyObject] {
                    value = JSONObject.valueForKeyPath(rootKey) as? T
                } else {
                    value = JSONObject as? T
                }
                if let value = value {
                    return .Success(value)
                } else {
                    let failureReason = "JSON parsing to object Failed"
                    let error = Error.errorWithCode(-1, failureReason: failureReason)
                    return .Failure(error)
                }
            } catch {
                return .Failure(error as NSError)
            }
        }
    }
    
    /**
     Creates a response serializer that returns a GLOSS object constructed from the response data using
     `NSJSONSerialization` with the specified reading options.
     
     - parameter options: The GLOSS serialization reading options. `.AllowFragments` by default.
     
     - returns: A GLOSS object response serializer.
     */
    public static func GLOSSResponseSerializer<T: Decodable>(
        rootKey rootKey: String? = nil,
        options: NSJSONReadingOptions = .AllowFragments)
        -> ResponseSerializer<T, NSError>
    {
        return ResponseSerializer { _, _, data, error in
            guard error == nil else { return .Failure(error!) }
            
            guard let validData = data where validData.length > 0 else {
                let failureReason = "JSON could not be serialized. Input data was nil or zero length."
                let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            do {
                let JSONObject = try NSJSONSerialization.JSONObjectWithData(validData, options: options)
                var value: T?
                if let rootKey = rootKey where JSONObject is [String: AnyObject] {
                    value = T(json: JSONObject.valueForKeyPath(rootKey) as! JSON)
                } else {
                    value = T(json: JSONObject as! JSON)
                }
                if let value = value {
                    return .Success(value)
                } else {
                    let failureReason = "JSON parsing to object Failed"
                    let error = Error.errorWithCode(-1, failureReason: failureReason)
                    return .Failure(error)
                }
            } catch {
                return .Failure(error as NSError)
            }
        }
    }
    
    /**
     Creates a response serializer that returns a GLOSS object constructed from the response data using
     `NSJSONSerialization` with the specified reading options.
     
     - parameter options: The GLOSS serialization reading options. `.AllowFragments` by default.
     
     - returns: A GLOSS object response serializer.
     */
    public static func GLOSSResponseSerializer<T: Decodable>(
        rootKey rootKey: String? = nil,
        options: NSJSONReadingOptions = .AllowFragments)
        -> ResponseSerializer<[T], NSError>
    {
        return ResponseSerializer { _, _, data, error in
            guard error == nil else { return .Failure(error!) }
            
            guard let validData = data where validData.length > 0 else {
                let failureReason = "JSON could not be serialized. Input data was nil or zero length."
                let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            do {
                let JSONObject = try NSJSONSerialization.JSONObjectWithData(validData, options: options)
                var value: [T]?
                if let rootKey = rootKey where JSONObject is [String: AnyObject] {
                    value = T.modelsFromJSONArray(JSONObject.valueForKeyPath(rootKey) as! [JSON])
                } else {
                    value = T.modelsFromJSONArray(JSONObject as! [JSON])
                }
                if let value = value {
                    return .Success(value)
                } else {
                    let failureReason = "JSON parsing to object Failed"
                    let error = Error.errorWithCode(-1, failureReason: failureReason)
                    return .Failure(error)
                }
            } catch {
                return .Failure(error as NSError)
            }
        }
    }
    
}