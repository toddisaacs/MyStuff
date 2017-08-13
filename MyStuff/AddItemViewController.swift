//
//  AddItemViewController.swift
//  MyStuff
//
//  Created by Isaacs, Todd on 7/24/17.
//  Copyright © 2017 Isaacs, Todd. All rights reserved.
//

import UIKit
import CoreData

/**
 * Inform the delegate a save is needed or not.  The entites are setup in the child or main context passed in by the caller
 */
protocol AddItemViewControllerDelegate {
  func  didFinish(viewController: AddItemViewController, didSave: Bool)
}

class AddItemViewController: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  //REQUIRED
  var imageStore:ImageStore!
  
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
  var context: NSManagedObjectContext!
  var delegate: AddItemViewControllerDelegate?
  
  @IBAction func cancel(_ sender: Any) {
    dismissUniveral()
  }
  
  func dismissUniveral() {
    let isPresentingInAddMode = presentingViewController is UINavigationController
    
    if isPresentingInAddMode {
      dismiss(animated: true, completion: nil)
    } else if let owningNavController = navigationController {
      owningNavController.popViewController(animated: true)
    }
  }
  
  @IBAction func addPhoto(_ sender: UITapGestureRecognizer) {
    let imagePickerController = UIImagePickerController()
    imagePickerController.sourceType = .photoLibrary
    imagePickerController.delegate = self
    
    present(imagePickerController, animated: true, completion: nil)
  }
  
  @IBAction func saveItem(_ sender: Any) {
    guard let itemName = nameText.text, itemName != "" else {
      
      let itemValidationAlertController = UIAlertController(title: "Invalid Item",
                                                            message: "Name is required",
                                                            preferredStyle: .alert)
      itemValidationAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      
      present(itemValidationAlertController, animated: true, completion: nil)
      
      //cancel out of this method
      return
    }
    
    let saveFlag = updateItem()
    
    delegate?.didFinish(viewController:self, didSave:saveFlag)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "testing"
    if let item = item {
      nameText.text = item.name
      brandText.text = item.brand
      modelText.text = item.model
      
      purchasePriceText.text = item.purchasePrice?.stringValue ?? "0.00"
      valueText.text = item.itemValue?.stringValue ?? purchasePriceText.text
      serialNumberText.text = item.serialNumber
      
      if let galleryPhoto = item.galleryImage {
        //for now the gallery photo is the first photo
        if let key = galleryPhoto.imageKey, let photoImage = imageStore.get(forKey: key) {
          photo.image = photoImage as UIImage
        }
      }
    }
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
    
    //update view
    photo.image = selectedImage
    dismiss(animated: true, completion: nil)
  }
  
}

// MARK: Update Item
private extension AddItemViewController {
  
  func updateItem() -> Bool {
    guard let item = item else { return false}
    
    item.name = nameText.text
    item.brand = brandText.text
    item.model = modelText.text
    
    let price = Decimal(string: purchasePriceText.text!) ?? 0
    let value = Decimal(string: valueText.text!) ?? price
    
    item.purchasePrice = price as NSDecimalNumber
    item.itemValue = value as NSDecimalNumber
    
    item.serialNumber = serialNumberText.text
    
    //if we have a photo create photo entity and save image
    
    
    if let image = photo.image {
      if let photoEntity = item.galleryImage {
        context.delete(photoEntity)
      }
      
      let photoEntity = Photo(context: context)
      item.galleryImage = photoEntity
      
      do {
        try photoEntity.setImage(image: image)
      } catch let error as NSError {
        let itemValidationAlertController = UIAlertController(title: "System Error", message: "Error saving photo to disk \(error.code)", preferredStyle: .alert)
        itemValidationAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(itemValidationAlertController, animated: true, completion: nil)
        return false
      }
      print("photo key \(String(describing: photoEntity.imageKey))")
    }
    
    return true
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





