//
//  SeedData.swift
//  MyStuff
//
//  Created by Isaacs, Todd on 7/24/17.
//  Copyright © 2017 Isaacs, Todd. All rights reserved.
//

import CoreData

class SeedData {
  static func seed(stack: CoreDataStack) {

    let managedContext = stack.managedContext
    
    
    //********** Home Location ***************
    let homeLocationName = "Home"
    let homeLocationFetch: NSFetchRequest<Location> = Location.fetchRequest()
    homeLocationFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Location.name), homeLocationName)
    
    var homeLocation: Location?
    
    do {
      let results = try managedContext.fetch(homeLocationFetch)
      
      if results.count > 0 {
        homeLocation = results.first
      } else {
        homeLocation = Location(context: managedContext)
        homeLocation?.name = homeLocationName
        homeLocation?.address1 = "470 Woodland Pl"
        homeLocation?.city = "Pittsboro"
        homeLocation?.postalCode = "46167"
      }
    } catch let error as NSError {
      print("Fetch Error: \(error) description: \(error.userInfo)")
    }
    
    
    
    //********** Hand Gun Category ***************
    let categoryName = "Hand Gun"
    let categoryFetch: NSFetchRequest<Category> = Category.fetchRequest()
    categoryFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Category.name), categoryName)
    
    var handGunCategory: Category?
    
    do {
      let results = try managedContext.fetch(categoryFetch)
      
      if results.count > 0 {
        handGunCategory = results.first
      } else {
        handGunCategory = Category(context: managedContext)
        handGunCategory?.name = categoryName
      }
    } catch let error as NSError {
      print("Fetch Error: \(error) description: \(error.userInfo)")
    }

    
    //********** LCP Item ***************
    let itemName = "LCP 380"
    let itemFetch: NSFetchRequest<Item> = Item.fetchRequest()
    itemFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Item.name), itemName)
    
    var lcpItem: Item?
    
    do {
      let results = try managedContext.fetch(itemFetch)
      
      if results.count > 0 {
        lcpItem = results.first
      } else {
        lcpItem = Item(context: managedContext)
        lcpItem?.name = "LCP 380"
        lcpItem?.brand = "Ruger"
        lcpItem?.model = "LCP"
        lcpItem?.serialNumber = "123W2322SS34"
        lcpItem?.itemValue = 100.00
        lcpItem?.purchasePrice = 230.00
        
        //add related items
        homeLocation?.addToItems(lcpItem!)
        handGunCategory?.addToItems(lcpItem!)
      }
    } catch let error as NSError {
      print("Fetch Error: \(error) description: \(error.userInfo)")
    }
    
    
    //Save
    try! managedContext.save()
  }

}
