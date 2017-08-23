//
//  storageClass.swift
//  FridgeMaster
//
//  Created by Matthew Gomez on 8/22/17.
//  Copyright © 2017 Matthew Gomez. All rights reserved.
//

import Foundation

class FoodItem:NSObject {
    var name: String!
    var upc: String!
    var expirationDate: String!
    var purchaseDate: String!
    
    init(name:String, upc:String, expirationDate:String, purchaseDate:String) {
        self.name = name
        self.upc = upc
        self.expirationDate = expirationDate
        self.purchaseDate = purchaseDate
    }
}
