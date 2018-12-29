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
    func insert(model: Response) -> Error?
    
}

extension CoreDataSyncable {
    
    func sync(completion: @escaping (Error?) -> ()) {
        do {
            try request().execute { result, response in
                if let result = result {
                    self.context.perform {
                        if let error = self.insert(model: result) {
                            DispatchQueue.main.async { completion(error) }
                        } else {
                            do {
                                try self.context.save()
                            } catch {
                                DispatchQueue.main.async { completion(error) }
                            }
                            DispatchQueue.main.async { completion(nil) }
                        }
                    }
                } else {
                    DispatchQueue.main.async { completion(response.error!) }
                }
            }
        } catch {
            DispatchQueue.main.async { completion(error) }
        }
    }
    
}
