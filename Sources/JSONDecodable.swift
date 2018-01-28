//
//  Alamofire+JSONDecodable.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - JSON

class RequestJSONDecodableResponseSerializer {
    /// Returns a JSON object contained in a result type constructed from the response data using `JSONSerialization`
    /// with the specified reading options.
    ///
    /// - parameter options:  The JSON serialization reading options. Defaults to `.allowFragments`.
    /// - parameter response: The response from the server.
    /// - parameter data:     The data returned from the server.
    /// - parameter error:    The error already encountered if it exists.
    ///
    /// - returns: The result data type.
    public static func serializeResponseJSONDecodable<T: Decodable>(
        keyPath: String? = nil,
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
            let object = try JSONDecoder().decode(T.self, from: validData)
            return .success(object)
        } catch {
            return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
        }
    }
}

extension DataRequest {
    /// Creates a response serializer that returns a JSON object result type constructed from the response data using
    /// `JSONSerialization` with the specified reading options.
    ///
    /// - parameter options: The JSON serialization reading options. Defaults to `.allowFragments`.
    ///
    /// - returns: A JSON object response serializer.
    public static func JSONDecodableResponseSerializer<T: Decodable>(
        keyPath: String? = nil)
        -> DataResponseSerializer<T>
    {
        return DataResponseSerializer { _, response, data, error in
            return RequestJSONDecodableResponseSerializer.serializeResponseJSONDecodable(keyPath: keyPath, response: response, data: data, error: error)
        }
    }
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter options:           The JSON serialization reading options. Defaults to `.allowFragments`.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseJSONDecodable<T: Decodable>(
        queue: DispatchQueue? = nil,
        keyPath: String? = nil,
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.JSONDecodableResponseSerializer(keyPath: keyPath),
            completionHandler: completionHandler
        )
    }
}

extension DownloadRequest {
    /// Creates a response serializer that returns a JSON object result type constructed from the response data using
    /// `JSONSerialization` with the specified reading options.
    ///
    /// - parameter options: The JSON serialization reading options. Defaults to `.allowFragments`.
    ///
    /// - returns: A JSON object response serializer.
    public static func JSONDecodableResponseSerializer<T: Decodable>(
        keyPath: String? = nil)
        -> DownloadResponseSerializer<T>
    {
        return DownloadResponseSerializer { _, response, fileURL, error in
            guard error == nil else { return .failure(error!) }
            
            guard let fileURL = fileURL else {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileNil))
            }
            
            do {
                let data = try Data(contentsOf: fileURL)
                return RequestJSONDecodableResponseSerializer.serializeResponseJSONDecodable(keyPath: keyPath, response: response, data: data, error: error)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileReadFailed(at: fileURL)))
            }
        }
    }
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter options:           The JSON serialization reading options. Defaults to `.allowFragments`.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseJSONDecodable<T: Decodable>(
        queue: DispatchQueue? = nil,
        keyPath: String? = nil,
        completionHandler: @escaping (DownloadResponse<T>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DownloadRequest.JSONDecodableResponseSerializer(keyPath: keyPath),
            completionHandler: completionHandler
        )
    }
}
