//
//  Publisher+CoreDataClass.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//
//

import Foundation
import CoreData

@objc
public class Publisher: NSManagedObject {
    
    @NSManaged public var name: String
    @NSManaged public var books: Set<Book>?
    
}
