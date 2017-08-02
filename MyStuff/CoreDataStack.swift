//
//  CoreDataStack.swift
//  MyStuff
//
//  Created by Isaacs, Todd on 7/14/17.
//  Copyright © 2017 Isaacs, Todd. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
  
  //MARK: Properties
  lazy var managedContext: NSManagedObjectContext = {
    return self.storeContainer.viewContext
  }()
  
  
  private lazy var storeContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: self.modelName)
    
    if self.inMemory {
      let description = NSPersistentStoreDescription()
      description.type = NSInMemoryStoreType
      //description.configuration = .default
      container.persistentStoreDescriptions = [description]
    }
    container.loadPersistentStores {
      (storeDescription, error) in
      if let error = error as NSError? {
        print("Unresolved error \(error), \(error.userInfo)")
      }
    }
    
    return container
  }()
  
  
  private let modelName: String
  private var inMemory = false
  
  //MARK: Initialization
  init(modelName: String, inMemory: Bool) {
    self.modelName = modelName
    self.inMemory = inMemory
  }
  
  
  //MARK: Methods
  func saveContext() throws {
    //var error: NSError?
    
    guard managedContext.hasChanges else { return }
    
    do {
      try managedContext.save()
    } catch let saveError as NSError {
      throw saveError
    }
  }
  
}
