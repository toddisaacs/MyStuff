//
//  AddItemViewController.swift
//  MyStuff
//
//  Created by Isaacs, Todd on 7/24/17.
//  Copyright © 2017 Isaacs, Todd. All rights reserved.
//

import UIKit
import CoreData

class AddItemViewController: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
  var delegate: AddItemViewControllerDelegate?
  
  @IBAction func cancel(_ sender: Any) {
    navigationController?.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func addPhoto(_ sender: UITapGestureRecognizer) {
    let imagePickerController = UIImagePickerController()
    imagePickerController.sourceType = .photoLibrary
    imagePickerController.delegate = self
    
    present(imagePickerController, animated: true, completion: nil)
  }
  
  @IBAction func saveItem(_ sender: Any) {
    guard let itemName = nameText.text, itemName != "" else {
      
      let itemValidationAlertController = UIAlertController(title: "Invalid Item", message: "Name is required", preferredStyle: .alert)
      itemValidationAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      
      present(itemValidationAlertController, animated: true, completion: nil)
      
      //cancel out of this method
      return
      
    }
    
    if let item = item {
      item.name = nameText.text
      item.brand = brandText.text
      item.model = modelText.text
      item.purchasePrice = 1.00
      
      delegate?.onAddItem(item: item)
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
  
  //MARK: UIImagePickerControllerDelegate
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
      else {
        fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
    }
    photo.image = selectedImage
    dismiss(animated: true, completion: nil)
  }

}




protocol AddItemViewControllerDelegate {
  func onAddItem(item:Item?)
}
