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
    
    container.loadPersistentStores {
      (storeDescription, error) in
      if let error = error as NSError? {
        print("Unresolved error \(error), \(error.userInfo)")
      }
    }
    
    return container
  }()
  
  
  private let modelName: String
  
  
  //MARK: Initialization
  init(modelName: String) {
    self.modelName = modelName
  }
  
  
  //MARK: Methods
  func saveContext() {
    guard managedContext.hasChanges else { return }
    
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Unresolved error \(error), \(error.userInfo)")
    }
  }

  
  
  
}
