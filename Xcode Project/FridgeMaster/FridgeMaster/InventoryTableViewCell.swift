//
//  InventoryTableViewCell.swift
//  FridgeMaster
//
//  Created by Daniel Heyman on 8/24/17.
//  Copyright © 2017 Matthew Gomez. All rights reserved.
//

import UIKit

class InventoryTableViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    
    @IBOutlet var expiration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
