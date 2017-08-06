//
//  TestCoreDataStack.swift
//  MyStuff
//
//  Created by Isaacs, Todd on 8/6/17.
//  Copyright © 2017 Isaacs, Todd. All rights reserved.
//

import Foundation
import CoreData

class InMemoryDataStack: CoreDataStack {
  convenience init() {
    self.init(modelName: "MyStuff")
  }
  
  override init(modelName: String) {
    super.init(modelName: modelName)
    
    let persistentStoreDescription = NSPersistentStoreDescription()
    persistentStoreDescription.type = NSInMemoryStoreType
    
    let container = NSPersistentContainer(name: modelName)
    container.persistentStoreDescriptions = [persistentStoreDescription]
    
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    
    self.storeContainer = container
  }
  
}
