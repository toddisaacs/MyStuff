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
  
  override func setUp() {
    super.setUp()
    imageStore = ImageStore.sharedInstance
  }
  
  override func tearDown() {
    super.tearDown()
    imageStore = nil
  }
 
  
  func testStoreAndGetImage() {
    XCTAssertNotNil(imageStore, "ImageStore not initialized")
    
    let testImage = UIImage(named: "noPhoto")
    var key: String?
    
    do {
      key = try imageStore!.set(image: testImage!)
      XCTAssertNotNil(key, "Expected image key to be returnerd")
    } catch {
      XCTFail("Error saving image")
    }
    
    
    let cacheImage = imageStore!.imageCache.object(forKey: key! as NSString)
    XCTAssertNotNil(cacheImage, "Image not found in cache after adding it")

    XCTAssertNotNil(imageStore!.get(forKey: key!), "Error getting image")
    
    //remove from cache and verify we can get image
    imageStore!.imageCache.removeAllObjects()
    
    let testImage2 = imageStore!.get(forKey: key!)
    XCTAssertNotNil(testImage2, "Error getting image")
    

    XCTAssertNotNil(imageStore!.imageCache.object(forKey: key! as NSString), "Image not found in cache after fetcing it from disk")
  }
  
}
