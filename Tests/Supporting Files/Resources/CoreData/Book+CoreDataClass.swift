//
//  Book+CoreDataClass.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//
//

import Foundation
import CoreData

@objc
public class Book: NSManagedObject {
    
    @NSManaged public var title: String
    @NSManaged public var authors: Set<Author>?
    @NSManaged public var publisher: Publisher?

}
