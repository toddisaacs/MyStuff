//
//  Item+CoreDataProperties.swift
//  MyStuff
//
//  Created by Isaacs, Todd on 8/11/17.
//  Copyright © 2017 Isaacs, Todd. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var brand: String?
    @NSManaged public var descr: String?
    @NSManaged public var itemValue: NSDecimalNumber?
    @NSManaged public var lastUpdated: NSDate?
    @NSManaged public var model: String?
    @NSManaged public var name: String?
    @NSManaged public var purchasePrice: NSDecimalNumber?
    @NSManaged public var serialNumber: String?
    @NSManaged public var category: Category?
    @NSManaged public var location: Location?
    @NSManaged public var photos: NSSet?
    @NSManaged public var galleryImage: Photo?

}

// MARK: Generated accessors for photos
extension Item {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}
