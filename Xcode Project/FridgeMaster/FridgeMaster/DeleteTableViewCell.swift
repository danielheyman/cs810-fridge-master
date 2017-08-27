//
//  DeleteTableViewCell.swift
//  FridgeMaster
//
//  Created by Jeremy Doll on 8/26/17.
//  Copyright © 2017 Matthew Gomez. All rights reserved.
//

import Foundation

import UIKit

class DeleteTableViewCell: UITableViewCell {

    
    @IBOutlet var item: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
