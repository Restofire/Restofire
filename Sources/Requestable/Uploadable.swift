//
//  Uploadable.swift
//  Restofire
//
//  Created by Rahul Katariya on 30/01/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation

/// Represents an abstract `Uploadable`.
///
/// Instead implement FileUploadable, DataUploadable, StreamUploadable,
/// AMultipartUplodable protocols.
public protocol Uploadable: BaseRequestable {
    
    /// The Alamofire upload request validation.
    var validationBlock: DataRequest.Validation? { get }
 
    /// The uplaod request for subclasses to provide the implementation.
    func asRequest<T: Encodable>(parametersType: ParametersType<T>) throws -> () -> UploadRequest
    
    /// Called when the Request succeeds.
    ///
    /// - parameter request: The Alamofire.UploadRequest
    /// - parameter value: The Response
    func request(_ request: UploadOperation<Self>, didCompleteWithValue value: Response)
    
    /// Called when the Request fails
    ///
    /// - parameter request: The Alamofire.UploadRequest
    /// - parameter error: The Error
    func request(_ request: UploadOperation<Self>, didFailWithError error: Error)
    
}

extension Uploadable {
    
    /// `.post`
    public var method: HTTPMethod {
        return .post
    }
    
    /// `Validation.default.uploadValidation`
    public var validationBlock: DataRequest.Validation? {
        return validation.uploadValidation
    }

    /// `Does Nothing`
    func request(_ request: UploadOperation<Self>, didCompleteWithValue value: Response) {}
    
    /// `Does Nothing`
    func request(_ request: UploadOperation<Self>, didFailWithError error: Error) {}
    
}

extension Uploadable {
    
    /// Creates a `UploadOperation` for the specified `Uploadable` object.
    ///
    /// - parameter request: A data request instance
    /// - parameter uploadProgressHandler: A closure to be executed once the
    ///                                    upload progresses. `nil` by default.
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `UploadOperation`.
    func operation<T: Encodable>(
        parametersType: ParametersType<T>,
        uploadProgressHandler: (((Progress) -> Void), queue: DispatchQueue?)? = nil,
        completionQueue: DispatchQueue = .main,
        completionHandler: ((DataResponse<Response>) -> Void)? = nil
    ) throws  -> UploadOperation<Self> {
        let request = try self.asRequest(parametersType: parametersType)
        let uploadOperation = UploadOperation(
            uploadable: self,
            request: request,
            uploadProgressHandler: uploadProgressHandler,
            completionQueue: completionQueue,
            completionHandler: completionHandler
        )
        return uploadOperation
    }
    
    /// Creates a `UploadOperation` for the specified `Uploadable` object and
    /// asynchronously executes it.
    ///
    /// - parameter request: An upload request instance
    /// - parameter uploadProgressHandler: A closure to be executed once the
    ///                                    upload progresses. `nil` by default.
    /// - parameter completionHandler: A closure to be executed once the download
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `UploadOperation`.
    @discardableResult
    func enqueue<T: Encodable>(
        parametersType: ParametersType<T>,
        uploadProgressHandler: (((Progress) -> Void), queue: DispatchQueue?)? = nil,
        completionQueue: DispatchQueue = .main,
        completionHandler: ((DataResponse<Response>) -> Void)? = nil
    ) throws -> Cancellable {
        let uploadOperation = try operation(
            parametersType: parametersType,
            uploadProgressHandler: uploadProgressHandler,
            completionQueue: completionQueue,
            completionHandler: completionHandler
        )
        uploadQueue.addOperation(uploadOperation)
        return uploadOperation
    }
    
}

extension Uploadable {
    
    /// Creates a `UploadOperation` for the specified `Uploadable` object.
    ///
    /// - parameter uploadProgressHandler: A closure to be executed once the
    ///                                    upload progresses. `nil` by default.
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `UploadOperation`.
    @discardableResult
    public func operation(
        parameters: Any? = nil,
        uploadProgressHandler: (((Progress) -> Void), queue: DispatchQueue?)? = nil,
        completionQueue: DispatchQueue = .main,
        completionHandler: ((DataResponse<Response>) -> Void)? = nil
    ) throws -> UploadOperation<Self> {
        let parametersType = ParametersType<EmptyCodable>.any(parameters)
        return try operation(
            parametersType: parametersType,
            uploadProgressHandler: uploadProgressHandler,
            completionQueue: completionQueue,
            completionHandler: completionHandler
        )
    }
    
    /// Creates a `UploadOperation` for the specified `Uploadable` object and
    /// asynchronously executes it.
    ///
    /// - parameter uploadProgressHandler: A closure to be executed once the
    ///                                    upload progresses. `nil` by default.
    /// - parameter completionHandler: A closure to be executed once the download
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `Cancellable`.
    @discardableResult
    public func enqueue(
        parameters: Any? = nil,
        uploadProgressHandler: (((Progress) -> Void), queue: DispatchQueue?)? = nil,
        completionQueue: DispatchQueue = .main,
        completionHandler: ((DataResponse<Response>) -> Void)? = nil
    ) throws -> Cancellable {
        let parametersType = ParametersType<EmptyCodable>.any(parameters)
        return try enqueue(
            parametersType: parametersType,
            uploadProgressHandler: uploadProgressHandler,
            completionQueue: completionQueue,
            completionHandler: completionHandler
        )
    }
    
}

extension Uploadable {
    
    /// Creates a `UploadOperation` for the specified `Uploadable` object.
    ///
    /// - parameter uploadProgressHandler: A closure to be executed once the
    ///                                    upload progresses. `nil` by default.
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `UploadOperation`.
    @discardableResult
    public func operation<T: Encodable>(
        parameters: T,
        uploadProgressHandler: (((Progress) -> Void), queue: DispatchQueue?)? = nil,
        completionQueue: DispatchQueue = .main,
        completionHandler: ((DataResponse<Response>) -> Void)? = nil
    ) throws -> UploadOperation<Self> {
        let parametersType = ParametersType<T>.encodable(parameters)
        return try operation(
            parametersType: parametersType,
            uploadProgressHandler: uploadProgressHandler,
            completionQueue: completionQueue,
            completionHandler: completionHandler
        )
    }
    
    /// Creates a `UploadOperation` for the specified `Uploadable` object and
    /// asynchronously executes it.
    ///
    /// - parameter uploadProgressHandler: A closure to be executed once the
    ///                                    upload progresses. `nil` by default.
    /// - parameter completionHandler: A closure to be executed once the download
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `Cancellable`.
    @discardableResult
    public func enqueue<T: Encodable>(
        parameters: T,
        uploadProgressHandler: (((Progress) -> Void), queue: DispatchQueue?)? = nil,
        completionQueue: DispatchQueue = .main,
        completionHandler: ((DataResponse<Response>) -> Void)? = nil
    ) throws -> Cancellable {
        let parametersType = ParametersType<T>.encodable(parameters)
        return try enqueue(
            parametersType: parametersType,
            uploadProgressHandler: uploadProgressHandler,
            completionQueue: completionQueue,
            completionHandler: completionHandler
        )
    }
    
}
