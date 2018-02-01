//
//  Alamofire+JSONDecodable.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

/// An extension of Alamofire.Request
extension Request {
    
    /// Returns a JSON Decodable object contained in a result type constructed from the
    /// response data using `JSONDecoder`.
    ///
    /// - parameter decoder:  The JSONDecoder opject. Defaults to `JSONDecoder()`.
    /// - parameter response: The response from the server.
    /// - parameter data:     The data returned from the server.
    /// - parameter error:    The error already encountered if it exists.
    ///
    /// - returns: The result data type.
    public static func serializeResponseJSONDecodable<T: Decodable>(
        decoder: JSONDecoder = JSONDecoder(),
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
        -> Result<T>
    {
        guard error == nil else { return .failure(error!) }
        
        guard let validData = data, validData.count > 0 else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
        }
        
        do {
            let object = try decoder.decode(T.self, from: validData)
            return .success(object)
        } catch {
            return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
        }
    }
}

/// An extension of Alamofire.DataRequest
extension DataRequest {
    
    /// Creates a response serializer that returns a JSON Decodable object result type
    /// constructed from the response data using `JSONDecoder` with the specified reading options.
    ///
    /// - parameter decoder: The JSONDecoder opject. Defaults to `JSONDecoder()`.
    ///
    /// - returns: A JSON Decodable object response serializer.
    public static func JSONDecodableResponseSerializer<T: Decodable>(
        decoder: JSONDecoder = JSONDecoder())
        -> DataResponseSerializer<T>
    {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponseJSONDecodable(decoder: decoder, response: response, data: data, error: error)
        }
    }
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter decoder: The JSONDecoder opject. Defaults to `JSONDecoder()`.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseJSONDecodable<T: Decodable>(
        queue: DispatchQueue? = nil,
        decoder: JSONDecoder = JSONDecoder(),
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.JSONDecodableResponseSerializer(decoder: decoder),
            completionHandler: completionHandler
        )
    }
}

/// An extension of Alamofire.DownloadRequest
extension DownloadRequest {
    
    /// Creates a response serializer that returns a JSON Decodable object result type
    /// constructed from the response data using `JSONDecoder` with the specified reading options.
    ///
    /// - parameter decoder: The JSONDecoder opject. Defaults to `JSONDecoder()`.
    ///
    /// - returns: A JSON Decodable object response serializer.
    public static func JSONDecodableResponseSerializer<T: Decodable>(
        decoder: JSONDecoder = JSONDecoder())
        -> DownloadResponseSerializer<T>
    {
        return DownloadResponseSerializer { _, response, fileURL, error in
            guard error == nil else { return .failure(error!) }
            
            guard let fileURL = fileURL else {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileNil))
            }
            
            do {
                let data = try Data(contentsOf: fileURL)
                return Request.serializeResponseJSONDecodable(decoder: decoder, response: response, data: data, error: error)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileReadFailed(at: fileURL)))
            }
        }
    }
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter decoder: The JSONDecoder opject. Defaults to `JSONDecoder()`.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseJSONDecodable<T: Decodable>(
        queue: DispatchQueue? = nil,
        decoder: JSONDecoder = JSONDecoder(),
        completionHandler: @escaping (DownloadResponse<T>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DownloadRequest.JSONDecodableResponseSerializer(decoder: decoder),
            completionHandler: completionHandler
        )
    }
}
