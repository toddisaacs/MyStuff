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
  
  var coreDataStack:CoreDataStack?
  
  override func setUp() {
    super.setUp()
    // create in memory context
    coreDataStack = CoreDataStack(modelName: "MyStuff", inMemory: true)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()

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

}
