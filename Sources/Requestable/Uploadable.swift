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
public protocol Uploadable: _Requestable {
    
    /// The Alamofire upload request validation.
    var validationBlock: DataRequest.Validation? { get }
 
    /// The uplaod request for subclasses to provide the implementation.
    func asRequest() throws -> UploadRequest
    
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

public extension Uploadable {
    
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

public extension Uploadable {
    
    /// Creates a `RequestOperation` for the specified `Requestable` object.
    ///
    /// - parameter uploadProgressHandler: A closure to be executed once the
    ///                                    upload progresses. `nil` by default.
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `RequestOperation`.
    @discardableResult
    public func operation(
        uploadProgressHandler: ((Progress) -> Void)? = nil,
        completionHandler: ((DataResponse<Response>) -> Void)? = nil
    ) throws -> UploadOperation<Self> {
        let request = try self.asRequest()
        return operation(
            request: request,
            uploadProgressHandler: uploadProgressHandler,
            completionHandler: completionHandler
        )
    }
    
    /// Creates a `RequestOperation` for the specified `Requestable` object.
    ///
    /// - parameter request: A data request instance
    /// - parameter uploadProgressHandler: A closure to be executed once the
    ///                                    upload progresses. `nil` by default.
    /// - parameter completionHandler: A closure to be executed once the request
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `RequestOperation`.
    public func operation(
        request: @autoclosure @escaping () -> UploadRequest,
        uploadProgressHandler: ((Progress) -> Void)? = nil,
        completionHandler: ((DataResponse<Response>) -> Void)? = nil
    ) -> UploadOperation<Self> {
        let uploadOperation = UploadOperation(
            uploadable: self,
            request: request,
            uploadProgressHandler: uploadProgressHandler,
            completionHandler: completionHandler
        )
        return uploadOperation
    }
    
    /// Creates a `UploadOperation` for the specified `Uploadable` object and
    /// asynchronously executes it.
    ///
    /// - parameter uploadProgressHandler: A closure to be executed once the
    ///                                    upload progresses. `nil` by default.
    /// - parameter completionHandler: A closure to be executed once the download
    ///                                has finished. `nil` by default.
    ///
    /// - returns: The created `UploadOperation`.
    @discardableResult
    public func execute(
        uploadProgressHandler: ((Progress) -> Void)? = nil,
        completionHandler: ((DataResponse<Response>) -> Void)? = nil
    ) throws -> UploadOperation<Self> {
        let request = try self.asRequest()
        return execute(
            request: request,
            uploadProgressHandler: uploadProgressHandler,
            completionHandler: completionHandler
        )
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
    public func execute(
        request: @autoclosure @escaping () -> UploadRequest,
        uploadProgressHandler: ((Progress) -> Void)? = nil,
        completionHandler: ((DataResponse<Response>) -> Void)? = nil
    ) -> UploadOperation<Self> {
        let uploadOperation = operation(
            request: request,
            uploadProgressHandler: uploadProgressHandler,
            completionHandler: completionHandler
        )
        uploadQueue.addOperation(uploadOperation)
        return uploadOperation
    }
    
}
