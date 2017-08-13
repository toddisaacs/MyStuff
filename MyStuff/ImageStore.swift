//
//  ImageStore.swift
//  MyStuff
//
//  Created by Isaacs, Todd on 7/29/17.
//  Copyright © 2017 Isaacs, Todd. All rights reserved.
//

import UIKit

class ImageStore {

  static let sharedInstance = ImageStore()
  private init() {}
  
  let imageCache = NSCache<NSString, UIImage>()
  
  func set(image: UIImage) throws -> String  {
    let key = UUID().uuidString
    print("Adding image to disk and cache \(key)")
    imageCache.setObject(image, forKey: key as NSString)
    
    let imageURL = getImageURL(forKey: key)
    
    if let imageData = UIImageJPEGRepresentation(image, 0.5) {
      do {
        try imageData.write(to: imageURL, options: .atomic)
      } catch let error as NSError {
        print("Error writing image to disk \(error.userInfo)")
        throw error
      }
    }
    
    return key
  }
  
  func remove(key: String) {
    //clean up cache
    imageCache.removeObject(forKey: key as NSString)
    print("Removed object from cache")
    
    //clean up disk
    let imageURL = getImageURL(forKey: key)
    
    do {
      try FileManager.default.removeItem(at: imageURL)
      print("Removed image from disk")
    } catch let error as NSError {
      print("Error removing image for KEY: \(key) ERROR: \(error.userInfo)")
    }
  }
  
  func get(forKey key:String) -> UIImage? {
    if let existingImage = imageCache.object(forKey: key as NSString) {
      print("cache hit on image \(key)")
      return existingImage
    }
    
    let imageURL = getImageURL(forKey: key)
    
    guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path) else {
      return nil
    }
    
    imageCache.setObject(imageFromDisk, forKey: key as NSString)
    print("Image from disk \(key)")
    return imageFromDisk
  }
  
  func getImageURL(forKey key: String) -> URL {
    let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = documentsDirectories.first!
    
    return documentDirectory.appendingPathComponent(key)
  }
}
