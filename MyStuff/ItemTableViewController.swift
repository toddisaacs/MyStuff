//
//  ItemTableViewController.swift
//  MyStuff
//
//  Created by Isaacs, Todd on 7/14/17.
//  Copyright © 2017 Isaacs, Todd. All rights reserved.
//

import UIKit
import CoreData

class ItemTableViewController: UITableViewController {
  
  // MARK: Properties
  var fetchedResultsController:NSFetchedResultsController<Item>!
  var coreDataStack:CoreDataStack!
  var imageStore:ImageStore!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchedResultsController = setupFetchedResultsController()
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      coreDataStack.managedContext.delete(fetchedResultsController.object(at: indexPath))
      do {
        try coreDataStack.saveContext()
      } catch let error as NSError {
        showAlert(title: "Data Error", message: "Could not delete item", error: error)
      }
    }
  }
  
  lazy var dateFormatter:DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    
    return formatter
  }()
}



// MARK: IBActions
extension ItemTableViewController {

  @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
    if let sourceViewController = sender.source as? AddItemViewController, let item = sourceViewController.item {
      //update or add
      print("Add item \(String(describing: item.name))")
    }
  }
}

// MARK: NSFetchedResultsController
private extension ItemTableViewController {
  func setupFetchedResultsController() -> NSFetchedResultsController<Item> {
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: itemsFetchRequest(),
      managedObjectContext: coreDataStack.managedContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    fetchedResultsController.delegate = self
    
    do {
      try fetchedResultsController.performFetch()
    } catch let error as NSError {
      print("NSFetchedResultsController not configured error: \(error), \(error.userInfo)")
    }
    
    return fetchedResultsController
  }
  
  func itemsFetchRequest() -> NSFetchRequest<Item> {
    let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
    
    let sort = NSSortDescriptor(key: #keyPath(Item.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
    fetchRequest.sortDescriptors = [sort]
      
    return fetchRequest
  }
  
  func showAlert(title: String, message: String, error:NSError?) {
    let displayMessage:String!
    if let error = error {
      displayMessage = message + " \(error.code)"
    } else {
      displayMessage = message
    }
    
    let alertController = UIAlertController(title: title, message: displayMessage, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
    present(alertController, animated: true, completion: nil)
  }
}

// MARK: Navigation
extension ItemTableViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    switch(segue.identifier ?? "") {
    //ADD ITEM
    case "AddItem":
      guard let navController = segue.destination as? UINavigationController,
      let addItemController = navController.topViewController as? AddItemViewController else {
        fatalError("Unexpected destination \(segue.destination), Expected UINavigationCOntroller")
      }

      let childContext = getChildContext()
      let item = Item(context: childContext)
      setupItemViewController(controller: addItemController, item: item, context: childContext)
      
    //EDIT ITEM
    case "EditItem":
      guard let addItemController = segue.destination as? AddItemViewController,
        let indexPath = tableView.indexPathForSelectedRow else {
        showAlert(title: "System Failure", message: "Invalid Configuration", error: nil)
          return
      }

      let childContext = getChildContext()
      let item = fetchedResultsController.object(at: indexPath)
      //move item to child context
      let tempItem = childContext.object(with: item.objectID) as? Item
      setupItemViewController(controller: addItemController, item: tempItem!, context: childContext)
 
    default:
      showAlert(title: "System Failure", message: "Invalid Configuration", error: nil)
    }
  }
  
  func getChildContext() -> NSManagedObjectContext {
    let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    childContext.parent = coreDataStack.managedContext
    
    return childContext
  }
  
  func setupItemViewController(controller: AddItemViewController, item: Item, context: NSManagedObjectContext) {
    controller.delegate = self
    controller.item = item
    controller.imageStore = self.imageStore
    controller.context = context
  }
}


// MARK: UITableViewDataSource
extension ItemTableViewController {
 
  override func numberOfSections(in tableView: UITableView) -> Int {
    guard let sections = fetchedResultsController.sections else {
      return 0
    }
    
    return sections.count
  }
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sectionInfo = fetchedResultsController.sections?[section] else {
      return 0
    }
    
    return sectionInfo.numberOfObjects
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as! ItemTableViewCell
    
    configure(cell: cell, for: indexPath)
    
    return cell
  }
  
  
  func configure(cell: UITableViewCell, for indexPath: IndexPath) {
    guard let cell = cell as? ItemTableViewCell else {
      return
    }
    
    let item = fetchedResultsController.object(at: indexPath)
    cell.itemName.text = item.name
    
    if let value = item.itemValue {
      cell.itemValue.text = NumberFormatter.localizedString(from: value, number: .currency)
    }
    
    
    if let photoEntity = item.galleryImage {
      print("Found photo")
      let photoImage = imageStore.get(forKey: photoEntity.imageKey!)
      cell.itemImage.image = photoImage
    } else {
      cell.itemImage.image = UIImage(named: "noPhoto")
    }
    
    cell.itemMake.text = item.brand
    cell.itemModel.text = item.model
    cell.itemSerialNumber.text = item.serialNumber
    
    if let purchaseDate = item.purchaseDate {
       cell.itemPurchaseDate.text = dateFormatter.string(from: purchaseDate)
    }
   
  }
}



// MARK: NSFetchedResultsControllerDelegate
extension ItemTableViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    //let tableview know we are going to update
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      tableView.insertRows(at: [newIndexPath!], with: .automatic)
    case .delete:
      tableView.deleteRows(at: [indexPath!], with: .automatic)
    case .update:
      let cell = tableView.cellForRow(at: indexPath!) as! ItemTableViewCell
      configure(cell: cell, for: indexPath!)
    case .move:
      tableView.deleteRows(at: [indexPath!], with: .automatic)
      tableView.insertRows(at: [newIndexPath!], with: .automatic)
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
}


// MARK: AddItemViewCOntrollerDelegate
extension ItemTableViewController: AddItemViewControllerDelegate {
  func didFinish(viewController: AddItemViewController, didSave: Bool) {
    guard didSave,
      let context = viewController.context,
      context.hasChanges else {
        viewController.dismissUniveral()
        return
    }
    
    context.perform {
      do {
        print("saving child context")
        try context.save()
      } catch let error as NSError {
        fatalError("Error: \(error.localizedDescription)")
      }
      
      do {
        print("saving main context")
        try self.coreDataStack.saveContext()
      } catch let error as NSError {
        print("Error \(error.localizedDescription)")
      }
    }
    viewController.dismissUniveral()
  }
  
}


