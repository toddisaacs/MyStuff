//
//  Location+CoreDataProperties.swift
//  MyStuff
//
//  Created by Isaacs, Todd on 7/15/17.
//  Copyright © 2017 Isaacs, Todd. All rights reserved.
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var address1: String?
    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var postalCode: String?
    @NSManaged public var name: String?
    @NSManaged public var items: NSSet?
    @NSManaged public var rooms: NSSet?

}

// MARK: Generated accessors for items
extension Location {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

// MARK: Generated accessors for rooms
extension Location {

    @objc(addRoomsObject:)
    @NSManaged public func addToRooms(_ value: Room)

    @objc(removeRoomsObject:)
    @NSManaged public func removeFromRooms(_ value: Room)

    @objc(addRooms:)
    @NSManaged public func addToRooms(_ values: NSSet)

    @objc(removeRooms:)
    @NSManaged public func removeFromRooms(_ values: NSSet)

}
