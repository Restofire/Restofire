//
//  CoreDataSyncable.swift
//  Restofire
//
//  Created by RahulKatariya on 27/12/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import CoreData

public protocol CoreDataSyncable: Syncable {
    var context: NSManagedObjectContext { get }
}

extension CoreDataSyncable {
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
        var networkOperation: Cancellable?
        self.context.performAndWait {
            do {
                let flag = try self.shouldSync()
                guard flag else {
                    completionQueue.async { completion?(nil) }
                    return
                }
                let completionHandler = { (response: DataResponse<Self.Request.Response>) in
                    switch response.result {
                    case .success(let value):
                        self.context.perform {
                            do {
                                try self.insert(model: value) {
                                    if let operation = networkOperation,
                                        operation.isCancelled {
                                        return
                                    }
                                    self.context.perform {
                                        do {
                                            try self.context.save()
                                            completionQueue.async { completion?(nil) }
                                        } catch {
                                            completionQueue.async { completion?(error) }
                                        }
                                    }
                                }
                            } catch {
                                completionQueue.async { completion?(error) }
                            }
                        }
                    case .failure(let error):
                        completionQueue.async { completion?(error) }
                    }
                }
                let operation = try self.request.operation(
                    parametersType: parametersType,
                    downloadProgressHandler: downloadProgressHandler,
                    completionQueue: completionQueue,
                    completionHandler: completionHandler
                )
                if immediate { operation.start() } else {
                    request.requestQueue.addOperation(operation)
                }
                networkOperation = operation
            } catch {
                completionQueue.async { completion?(error) }
            }
        }
        return networkOperation
    }
}
