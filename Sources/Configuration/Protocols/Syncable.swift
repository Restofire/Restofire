//
//  Syncable.swift
//  Restofire
//
//  Created by RahulKatariya on 31/12/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import Foundation

public protocol Syncable {
    associatedtype Request: Requestable
    var request: Request { get }

    func shouldSync() throws -> Bool
    func insert(model: Request.Response, completion: @escaping () throws -> Void) throws
}

extension Syncable {
    public func shouldSync() throws -> Bool {
        return true
    }

    public func sync(
        parameters: Any? = nil,
        downloadProgressHandler: ((Progress) -> Void, queue: DispatchQueue?)? = nil,
        completionQueue: DispatchQueue = .main,
        immediate: Bool = false,
        completion: ((Error?) -> Void)? = nil
    ) -> Cancellable? {
        let parametersType = ParametersType<EmptyCodable>.any(parameters)
        return sync(
            parametersType: parametersType,
            downloadProgressHandler: downloadProgressHandler,
            completionQueue: completionQueue,
            immediate: immediate,
            completion: completion
        )
    }

    public func sync<T: Encodable>(
        parameters: T,
        downloadProgressHandler: ((Progress) -> Void, queue: DispatchQueue?)? = nil,
        completionQueue: DispatchQueue = .main,
        immediate: Bool = false,
        completion: ((Error?) -> Void)? = nil
    ) -> Cancellable? {
        let parametersType = ParametersType<T>.encodable(parameters)
        return sync(
            parametersType: parametersType,
            downloadProgressHandler: downloadProgressHandler,
            completionQueue: completionQueue,
            immediate: immediate,
            completion: completion
        )
    }

    public func sync<T: Encodable>(
        parametersType: ParametersType<T>,
        downloadProgressHandler: ((Progress) -> Void, queue: DispatchQueue?)? = nil,
        completionQueue: DispatchQueue = .main,
        immediate: Bool = false,
        completion: ((Error?) -> Void)? = nil
    ) -> Cancellable? {
        do {
            let flag = try self.shouldSync()
            guard flag else {
                completionQueue.async { completion?(nil) }
                return nil
            }
            let completionHandler = { (response: DataResponse<Self.Request.Response>) in
                switch response.result {
                case .success(let value):
                    do {
                        try self.insert(model: value) {
                            completionQueue.async { completion?(nil) }
                        }
                    } catch {
                        completionQueue.async { completion?(error) }
                    }
                case .failure(let error):
                    completionQueue.async { completion?(error) }
                }
            }
            let operation: RequestOperation<Request> = try self.request.operation(
                parametersType: parametersType,
                downloadProgressHandler: downloadProgressHandler,
                completionQueue: completionQueue,
                completionHandler: completionHandler
            )
            if immediate { operation.start() } else {
                request.requestQueue.addOperation(operation)
            }
            return operation
        } catch {
            completionQueue.async { completion?(error) }
            return nil
        }
    }
}
