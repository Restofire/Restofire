//
//  Author+CoreDataClass.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//
//

import Foundation
import CoreData

@objc
public class Author: NSManagedObject {
    
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var books: Set<Book>?
    
}
