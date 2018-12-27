//
//  CoreDataSyncable.swift
//  Restofire
//
//  Created by RahulKatariya on 27/12/18.
//  Copyright © 2018 Restofire. All rights reserved.
//

import CoreData

protocol CoreDataSyncable {
    
    associatedtype Response
    associatedtype Request: Requestable where Request.Response == Response
    
    var context: NSManagedObjectContext { get }
    
    func request() -> Request
    func map(model: Response) -> Error?
    
}

extension CoreDataSyncable {
    
    func sync(completion: @escaping (Error?) -> ()) throws {
        try request().execute { result, response in
            if let result = result {
                self.context.perform {
                    if let error = self.map(model: result) {
                        completion(error)
                    } else {
                        do {
                            try self.context.save()
                        } catch {
                            completion(error)
                        }
                        completion(nil)
                    }
                }
            } else {
                completion(response.error!)
            }
        }
    }
    
}
