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
  
  var fetchedResultsController:NSFetchedResultsController<Item>!
  var coreDataStack:CoreDataStack!
  var imageStore:ImageStore!
  
  //MARK: Actions
  @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
    if let sourceViewController = sender.source as? AddItemViewController, let item = sourceViewController.item {
      //update or add
      print("Add item \(String(describing: item.name))")
    }
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()

    let sort = NSSortDescriptor(key: #keyPath(Item.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
    fetchRequest.sortDescriptors = [sort]
    
    
    fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: coreDataStack.managedContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    fetchedResultsController.delegate = self
    
    do {
      try fetchedResultsController.performFetch()
    } catch let error as NSError {
      print("Fetching error: \(error), \(error.userInfo)")
    }
  }

  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
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
    
    
    if let photoEntity = item.photos?.allObjects.first as? Photo {
     
      print("Found photo")
      let photoImage = imageStore.get(forKey: photoEntity.imageKey!)
      cell.itemImage.image = photoImage
      
    } else {
      cell.itemImage.image = UIImage(named: "noPhoto")
    }
    
    
    cell.itemDescription.text = item.descr
  }
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    switch(segue.identifier ?? "") {
    case "addItem" :
      guard let navController = segue.destination as? UINavigationController else {
        fatalError("Unexpected destination \(segue.destination), Expected UINavigationCOntroller")
      }
      
      guard let addItemController = navController.topViewController as? AddItemViewController else {
        fatalError("Unexpected destination Expected AddItemViewController")
      }
      
      //populate core data stack
      addItemController.delegate = self
      addItemController.item = Item(context: coreDataStack.managedContext)
      addItemController.imageStore = self.imageStore
    default:
      fatalError("Unexpected segue identifier \(String(describing: segue.identifier))")
      
    }
  }
}

extension ItemTableViewController: AddItemViewControllerDelegate {
  func onAddItem(item: Item?) {
    print("adding added: \(String(describing: item?.name))")
    
    do {
      try coreDataStack.saveContext()
    } catch let error as NSError {
      print("Error saving data \(error)")
      
    }
  }
}

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
