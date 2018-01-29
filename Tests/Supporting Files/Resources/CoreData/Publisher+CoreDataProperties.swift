//
//  Publisher+CoreDataProperties.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//
//

import Foundation
import CoreData


extension Publisher {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Publisher> {
        return NSFetchRequest<Publisher>(entityName: "Publisher")
    }

}

// MARK: Generated accessors for books
extension Publisher {

    @objc(addBooksObject:)
    @NSManaged public func addToBooks(_ value: Book)

    @objc(removeBooksObject:)
    @NSManaged public func removeFromBooks(_ value: Book)

    @objc(addBooks:)
    @NSManaged public func addToBooks(_ values: NSSet)

    @objc(removeBooks:)
    @NSManaged public func removeFromBooks(_ values: NSSet)

}
