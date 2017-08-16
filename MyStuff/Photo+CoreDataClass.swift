//
//  Photo+CoreDataClass.swift
//  MyStuff
//
//  Created by Isaacs, Todd on 7/24/17.
//  Copyright © 2017 Isaacs, Todd. All rights reserved.
//

import UIKit
import CoreData

/**
 * Photo entity will be used to track photos related to inventory.  This class will not
 * be regenerated when making change to the data model
 *
 * NOTE: The actual image will be saved on disk but the life cycle will be managed by this
 *       this entity via the NSManagedObject.  The actual removal and setting an image will
 *       will be delegated to the ImageStore.
 */
public class Photo: NSManagedObject {
  
  public override func prepareForDeletion() {
    if self.imageKey != nil {
      ImageStore.sharedInstance.remove(key: self.imageKey!)
    }
  }
  
  /**
   * Not using getter and setter here becuase of the throws.
   *
   * This function will also handle cleanup of images if an new image is set.  However, keep in mind that
   * NSFetchedResultsController will not detect child entity changes so it may be easier to just remove
   * and add a new Photo when changing an image to get the controller auto detect benefit.
   * 
   * NOTE: the workflow for photo image updates is to remove the existing photo and create a new on.  This 
   * delete of image data will happen when the entity is removed, so auto cleanup of image files on delete.
   */
  func setImage(image:UIImage) throws {

    //save image to store and set imageKey
    do {
      try self.imageKey = ImageStore.sharedInstance.set(image: image)
    } catch let error as NSError {
      throw(error)
    }
  }
  
  func getImage() -> UIImage? {
    guard let key = self.imageKey else {
      return nil
    }
    return ImageStore.sharedInstance.get(forKey: key)
  }
}
