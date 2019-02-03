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
        completionQueue: DispatchQueue = .main,
        completion: ((Error?) -> ())? = nil
    ) {
        self.context.perform {
            do {
                try self.shouldSync() { flag in
                    guard flag else {
                        completionQueue.async { completion?(nil) }
                        return
                    }
                    try self.request.execute { response in
                        switch response.result {
                        case .success(let value):
                            self.context.perform {
                                do {
                                    try self.insert(model: value) {
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
                }
            } catch {
                completionQueue.async { completion?(error) }
            }
        }
    }
    
}
