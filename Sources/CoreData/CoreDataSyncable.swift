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
    
    public func sync(completion: ((Error?) -> ())? = nil) {
        self.context.perform {
            do {
                try self.shouldSync() { flag in
                    guard flag else {
                        DispatchQueue.main.async { completion?(nil) }
                        return
                    }
                    try self.request.execute { result, response in
                        guard let result = result else {
                            DispatchQueue.main.async { completion?(response.error!) }
                            return
                        }
                        self.context.perform {
                            do {
                                try self.insert(model: result) {
                                    self.context.perform {
                                        do {
                                            try self.context.save()
                                            DispatchQueue.main.async { completion?(nil) }
                                        } catch {
                                            DispatchQueue.main.async { completion?(error) }
                                        }
                                    }
                                }
                            } catch {
                                DispatchQueue.main.async { completion?(error) }
                            }
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async { completion?(error) }
            }
        }
    }
    
}
