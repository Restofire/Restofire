//
//  ResponseSerializable.swift
//  Restofire
//
//  Created by Rahul Katariya on 29/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation
import Alamofire

public protocol _ResponseSerializable {
    
    /// The response type.
    associatedtype Response
    
    /// The keypath.
    var keypath: String? { get }
    
    /// context.
    var context: [String: Any]? { get }
    
}

extension _ResponseSerializable {
    
    /// `nil`
    public var keypath: String? {
        return nil
    }
    
    /// `nil`
    public var context: [String: Any]? {
        return nil
    }
    
}

/// Represents a `Alamofire.DataResponseSerializer` that is associated with `Requestable`.
public protocol ResponseSerializable: _ResponseSerializable {
    
    /// The data response serializer.
    var responseSerializer: AnyResponseSerializer<Result<Response>> { get }
    
}

public extension ResponseSerializable where Response == Data {
    
    /// `Alamofire.DataRequest.dataResponseSerializer()`
    public var responseSerializer: AnyResponseSerializer<Result<Response>> {
        return AnyResponseSerializer<Result<Response>>.init(dataSerializer: { (request, response, data, error) -> Result<Response> in
            return Result { try DataResponseSerializer().serialize(
                request: request, response: response, data: data, error: error
            )}
        })
    }
    
}

public class AnyResponseSerializer<Value>: ResponseSerializer {
    
    /// A closure which can be used to serialize data responses.
    public typealias DataSerializer = (_ request: URLRequest?, _ response: HTTPURLResponse?, _ data: Data?, _ error: Error?) throws -> Value
    /// A closure which can be used to serialize download reponses.
    public typealias DownloadSerializer = (_ request: URLRequest?, _ response: HTTPURLResponse?, _ fileURL: URL?, _ error: Error?) throws -> Value
    
    let dataSerializer: DataSerializer
    let downloadSerializer: DownloadSerializer?
    
    /// Initializes the `ResponseSerializer` instance with the given serialize response closure.
    ///
    /// - Parameters:
    ///   - dataSerializer:     A `DataSerializer` closure.
    ///   - downloadSerializer: A `DownloadSerializer` closure.
    public init(dataSerializer: @escaping DataSerializer, downloadSerializer: @escaping DownloadSerializer) {
        self.dataSerializer = dataSerializer
        self.downloadSerializer = downloadSerializer
    }
    
    /// Initialze the instance with a `DataSerializer` closure. Download serialization will fallback to a default
    /// implementation.
    ///
    /// - Parameters:
    ///   - dataSerializer:     A `DataSerializer` closure.
    public init(dataSerializer: @escaping DataSerializer) {
        self.dataSerializer = dataSerializer
        self.downloadSerializer = nil
    }
    
    public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> Value {
        return try dataSerializer(request, response, data, error)
    }
    
    public func serializeDownload(request: URLRequest?, response: HTTPURLResponse?, fileURL: URL?, error: Error?) throws -> Value {
        return try downloadSerializer?(request, response, fileURL, error) ?? { (request, response, fileURL, error) in
            guard error == nil else { throw error! }
            
            guard let fileURL = fileURL else {
                throw AFError.responseSerializationFailed(reason: .inputFileNil)
            }
            
            let data: Data
            do {
                data = try Data(contentsOf: fileURL)
            } catch {
                throw AFError.responseSerializationFailed(reason: .inputFileReadFailed(at: fileURL))
            }
            
            do {
                return try serialize(request: request, response: response, data: data, error: error)
            } catch {
                throw error
            }
            }(request, response, fileURL, error)
    }
    
}
