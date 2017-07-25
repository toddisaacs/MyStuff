//
//  AddItemViewController.swift
//  MyStuff
//
//  Created by Isaacs, Todd on 7/24/17.
//  Copyright © 2017 Isaacs, Todd. All rights reserved.
//

import UIKit
import CoreData

class AddItemViewController: ViewController {

  @IBOutlet weak var saveButton: UIBarButtonItem!
  
  @IBOutlet weak var nameText: UITextField!

  @IBOutlet weak var brandText: UITextField!
  @IBOutlet weak var modelText: UITextField!
  @IBOutlet weak var serialNumberText: UITextField!
  @IBOutlet weak var purchasePriceText: UITextField!
  @IBOutlet weak var valueText: UITextField!
  
  @IBOutlet weak var photo: UIImageView!
  
  //Properties
  var item: Item?
  var coreDataStack: CoreDataStack!
  
  @IBAction func cancel(_ sender: Any) {
    navigationController?.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func saveItem(_ sender: Any) {
    guard let itemName = nameText.text, itemName != "" else {
      
      let itemValidationAlertController = UIAlertController(title: "Invalid Item", message: "Name is required", preferredStyle: .alert)
      itemValidationAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      
      present(itemValidationAlertController, animated: true, completion: nil)
      
      //cancel out of this method
      return
      
    }
    
    
    item = Item(context: coreDataStack.managedContext)
   
    item?.name = nameText.text
    item?.brand = brandText.text
    item?.model = modelText.text
    
    do {
      try coreDataStack.saveContext()
    } catch let error as NSError {
      print("Error \(error.userInfo)")
    }
    
    
    performSegue(withIdentifier: "unwindToItemList", sender: nil)
  }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
      
        print("prepare")
    }
 

}
