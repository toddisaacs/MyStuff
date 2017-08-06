//
//  ImageStoreTests.swift
//  MyStuff
//
//  Created by Isaacs, Todd on 8/1/17.
//  Copyright © 2017 Isaacs, Todd. All rights reserved.
//


import XCTest

@testable import MyStuff

class ImageStoreTests: XCTestCase {
  
  var imageStore:ImageStore?
  let IMAGE_KEY = "NOPHOTO"
  
  override func setUp() {
    super.setUp()
    imageStore = ImageStore()
  }
  
  override func tearDown() {
    super.tearDown()
    imageStore = nil
  }
 
  
  func testStoreImage() {
    XCTAssertNotNil(imageStore, "ImageStore not initialized")
    
    let testImage = UIImage(named: "noPhoto")
    XCTAssertNoThrow(try imageStore!.set(image: testImage!, key: IMAGE_KEY), "Unable to save image")
    
    let cacheImage = imageStore!.imageCache.object(forKey: IMAGE_KEY as NSString)
    XCTAssertNotNil(cacheImage, "Image not found in cache after adding it")
  }
  
  func testGetImage() {
    let testImage = imageStore!.get(forKey: IMAGE_KEY)
    XCTAssertNotNil(testImage, "Error getting image")
    
    //remove from cache and verify we can get image
    imageStore!.imageCache.removeAllObjects()
    
    let testImage2 = imageStore!.get(forKey: IMAGE_KEY)
    XCTAssertNotNil(testImage2, "Error getting image")
    
    let cacheImage = imageStore!.imageCache.object(forKey: IMAGE_KEY as NSString)
    XCTAssertNotNil(cacheImage, "Image not found in cache after fetcing it from disk")
  }
  
}
