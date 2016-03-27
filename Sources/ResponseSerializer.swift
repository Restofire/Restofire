//
//  ResponseSerializer.swift
//  Restofire
//
//  Created by Rahul Katariya on 26/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

extension Request {
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter options:           The JSON serialization reading options. `.AllowFragments` by default.
     - parameter completionHandler: A closure to be executed once the request has finished.
     
     - returns: The request.
     */
    public func responseJSON<T>(
        rootKeyPath rootKeyPath: String? = nil,
                options: NSJSONReadingOptions = .AllowFragments,
                completionHandler: Response<T, NSError> -> Void)
        -> Self
    {
        return response(
            responseSerializer: Request.JSONResponseSerializer(rootKeyPath: rootKeyPath, options: options),
            completionHandler: completionHandler
        )
    }
    
    /**
     Creates a response serializer that returns a JSON object constructed from the response data using
     `NSJSONSerialization` with the specified reading options.
     
     - parameter options: The JSON serialization reading options. `.AllowFragments` by default.
     
     - returns: A JSON object response serializer.
     */
    public static func JSONResponseSerializer<T>(
        rootKeyPath rootKeyPath: String? = nil,
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
                if let rootKeyPath = rootKeyPath where JSONObject is [String: AnyObject] {
                    value = JSONObject.valueForKeyPath(rootKeyPath) as? T
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
    
}