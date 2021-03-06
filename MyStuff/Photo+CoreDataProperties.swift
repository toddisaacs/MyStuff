//
//  Photo+CoreDataProperties.swift
//  MyStuff
//
//  Created by Isaacs, Todd on 8/11/17.
//  Copyright © 2017 Isaacs, Todd. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var imageKey: String?
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var item: Item?
    @NSManaged public var galleryItem: Item?

}
