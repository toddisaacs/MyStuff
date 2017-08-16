//
//  ItemTableViewCell.swift
//  MyStuff
//
//  Created by Isaacs, Todd on 7/14/17.
//  Copyright © 2017 Isaacs, Todd. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

  //MARK: Properties
  @IBOutlet weak var itemImage: UIImageView!
  @IBOutlet weak var itemName: UILabel!
  @IBOutlet weak var itemDescription: UILabel!
  @IBOutlet weak var itemValue: UILabel!
  @IBOutlet weak var itemMake: UILabel!
  @IBOutlet weak var itemModel: UILabel!
  @IBOutlet weak var itemPurchaseDate: UILabel!
  @IBOutlet weak var itemSerialNumber: UILabel!
  
  
  //MARK: Initialization
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  //MARK: Overrides
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

}
