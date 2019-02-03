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
    
    func shouldSync(completion: (Bool) throws -> ()) throws
    func insert(model: Request.Response, completion: @escaping () throws -> ()) throws
}

extension Syncable {
    
    public func shouldSync(completion: (Bool) throws -> ()) throws {
        try completion(true)
    }
    
    public func sync(
        completionQueue: DispatchQueue = .main,
        completion: ((Error?) -> ())? = nil
    ) {
        do {
            try self.shouldSync() { flag in
                guard flag else {
                    completionQueue.async { completion?(nil) }
                    return
                }
                try self.request.execute { response in
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
            }
        } catch {
            completionQueue.async { completion?(error) }
        }
    }
    
}
