//
//  ItemTableViewController.swift
//  MyStuff
//
//  Created by Isaacs, Todd on 7/14/17.
//  Copyright © 2017 Isaacs, Todd. All rights reserved.
//

import UIKit

class ItemTableViewController: UITableViewController {

  var items = ["item1", "item2"]
  
  var coreDataStack:CoreDataStack!
  
  //MARK: Actions
  @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
    if let sourceViewController = sender.source as? AddItemViewController, let item = sourceViewController.item {
      //update or add
      print("Add item \(String(describing: item.name))")
    }
  }
  
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as! ItemTableViewCell

      if indexPath.row == 1 {
        cell.itemName.text = "Samsung Color Laser Printer"
        cell.itemValue.text = "$45.00"
        cell.itemDescription.text = "not working well"
      }
      

        return cell
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
        addItemController.coreDataStack = coreDataStack
      default:
        fatalError("Unexpected segue identifier \(String(describing: segue.identifier))")
        
    }
 
  }
  

}
