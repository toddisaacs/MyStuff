//
//  CoreDataStackTests.swift
//  MyStuff
//
//  Created by Isaacs, Todd on 7/30/17.
//  Copyright © 2017 Isaacs, Todd. All rights reserved.
//

import XCTest
import CoreData

@testable import MyStuff

class CoreDataStackTests: XCTestCase {
  
  var coreDataStack:CoreDataStack!
  
  override func setUp() {
    super.setUp()
    coreDataStack = InMemoryDataStack()
  }
  
  override func tearDown() {
    super.tearDown()
    coreDataStack = nil
  }
  
  func testInsertItem() {
    guard  let stack = coreDataStack, let context = coreDataStack?.managedContext else {
      XCTFail()
      return
    }
    
    let item = Item(context: context)
    item.name = "Test Insert"
    
    
    XCTAssertNoThrow(try stack.saveContext(), "Failed to save an Item")
  }
  
  func testImageManipulation() {
    guard  let stack = coreDataStack, let context = coreDataStack?.managedContext else {
      XCTFail()
      return
    }
    
    let item = Item(context: context)
    item.name = "Test Insert"
    
    let photo = Photo(context: context)
    XCTAssertNoThrow(try photo.setImage(image: UIImage(named: "noPhoto")!) )
    
    item.galleryImage = photo
    
    XCTAssertNoThrow(try stack.saveContext(), "Failed to save an Item")
    
    //swap image
    let oldImageKey = item.galleryImage?.imageKey
    XCTAssertNotNil(oldImageKey)
    
     XCTAssertNoThrow(try photo.setImage(image: UIImage(named: "noPhoto")!) )
    XCTAssertNoThrow(try stack.saveContext(), "Failed to save an Item")
    
    //delete image
    item.galleryImage = nil
    XCTAssertNoThrow(try stack.saveContext(), "Failed to save an Item")
  }

}
