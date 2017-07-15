//
//  Room+CoreDataProperties.swift
//  MyStuff
//
//  Created by Isaacs, Todd on 7/15/17.
//  Copyright © 2017 Isaacs, Todd. All rights reserved.
//

import Foundation
import CoreData


extension Room {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Room> {
        return NSFetchRequest<Room>(entityName: "Room")
    }

    @NSManaged public var name: String?
    @NSManaged public var location: Location?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension Room {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
