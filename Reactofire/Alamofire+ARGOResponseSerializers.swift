//
//  Alamofire+ARGOResponseSerializers.swift
//  Reactofire
//
//  Created by Rahul Katariya on 25/10/15.
//  Copyright © 2015 AarKay. All rights reserved.
//

import Alamofire
import Argo

// MARK: - ARGO

extension Request {
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter options:           The ARGO serialization reading options. `.AllowFragments` by default.
     - parameter completionHandler: A closure to be executed once the request has finished.
     
     - returns: The request.
     */
    public func responseARGO<T: Decodable where T == T.DecodedType>(
        rootKey rootKey: String? = nil,
        options: NSJSONReadingOptions = .AllowFragments,
        completionHandler: Response<T, NSError> -> Void)
        -> Self
    {
        return response(
            responseSerializer: Request.ARGOResponseSerializer(rootKey: rootKey, options: options),
            completionHandler: completionHandler
        )
    }
    
    /**
     Creates a response serializer that returns a ARGO object constructed from the response data using
     `NSJSONSerialization` with the specified reading options.
     
     - parameter options: The ARGO serialization reading options. `.AllowFragments` by default.
     
     - returns: A ARGO object response serializer.
     */
    public static func ARGOResponseSerializer<T: Decodable where T == T.DecodedType>(
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
                let JSON = try NSJSONSerialization.JSONObjectWithData(validData, options: options)
                let obj: Decoded<T>
                if let rootKey = rootKey {
                    obj = decodeWithRootKey(rootKey, JSON)
                } else {
                    obj = decode(JSON)
                }
                switch obj {
                case .Success(let value):
                    return .Success(value)
                case .Failure(let error):
                    return .Failure(NSError(domain:"ArgoErrorDomain", code:-1, userInfo:
                        [NSLocalizedDescriptionKey:error.description]))
                }
            } catch {
                return .Failure(error as NSError)
            }
        }
    }
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter options:           The ARGO serialization reading options. `.AllowFragments` by default.
     - parameter completionHandler: A closure to be executed once the request has finished.
     
     - returns: The request.
     */
    public func responseARGO<T: Decodable where T == T.DecodedType>(
        rootKey rootKey: String? = nil,
        options: NSJSONReadingOptions = .AllowFragments,
        completionHandler: Response<[T], NSError> -> Void)
        -> Self
    {
        return response(
            responseSerializer: Request.ARGOResponseSerializer(rootKey: rootKey, options: options),
            completionHandler: completionHandler
        )
    }
    
    /**
     Creates a response serializer that returns a ARGO object constructed from the response data using
     `NSJSONSerialization` with the specified reading options.
     
     - parameter options: The ARGO serialization reading options. `.AllowFragments` by default.
     
     - returns: A ARGO object response serializer.
     */
    public static func ARGOResponseSerializer<T: Decodable where T == T.DecodedType>(
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
                let JSON = try NSJSONSerialization.JSONObjectWithData(validData, options: options)
                let obj: Decoded<[T]>
                if let rootKey = rootKey {
                    obj = decodeWithRootKey(rootKey, JSON)
                } else {
                    obj = decode(JSON)
                }
                switch obj {
                case .Success(let value):
                    return .Success(value)
                case .Failure(let error):
                    return .Failure(NSError(domain:"ArgoErrorDomain", code:-1, userInfo:
                        [NSLocalizedDescriptionKey:error.description]))
                }
            } catch {
                return .Failure(error as NSError)
            }
        }
    }
    
}