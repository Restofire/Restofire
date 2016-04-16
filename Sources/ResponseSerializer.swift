//
//  ResponseSerializer.swift
//  Restofire
//
//  Created by Rahul Katariya on 26/03/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

extension Alamofire.Request {
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter rootKeyPath:       The root keypath. `nil` by default.
    /// - parameter options:           The JSON serialization reading options. `.AllowFragments` by default.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    func response(
        rootKeyPath rootKeyPath: String? = nil,
                    options: NSJSONReadingOptions = .AllowFragments,
                    completionHandler: Response<AnyObject, NSError> -> Void)
        -> Self
    {
        return response(
            responseSerializer: Alamofire.Request.JSONResponseSerializer(rootKeyPath: rootKeyPath, options: options),
            completionHandler: completionHandler
        )
    }
    
    /// Creates a response serializer that returns a JSON object constructed from the response data using
    /// `NSJSONSerialization` with the specified reading options.
    ///
    /// - parameter rootKeyPath: The root keypath. `nil` by default.
    /// - parameter options:     The JSON serialization reading options. `.AllowFragments` by default.
    ///
    /// - returns: A JSON object response serializer.
    private static func JSONResponseSerializer(
        rootKeyPath rootKeyPath: String? = nil,
                    options: NSJSONReadingOptions = .AllowFragments)
        -> ResponseSerializer<AnyObject, NSError>
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
                var value: AnyObject!
                if let rootKeyPath = rootKeyPath {
                    if let JSON = JSON as? [String: AnyObject] {
                       value = JSON.valueForKeyPath(rootKeyPath)
                    } else {
                        let failureReason = "JSON object doesn't have the rootKeyPath - \(rootKeyPath)"
                        let error = Error.errorWithCode(-1, failureReason: failureReason)
                        return .Failure(error)
                    }
                } else {
                    value = JSON
                }
                return .Success(value)
            } catch {
                return .Failure(error as NSError)
            }
            
        }
    }
    
}