//
//  storageClass.swift
//  FridgeMaster
//
//  Created by Matthew Gomez on 8/22/17.
//  Copyright © 2017 Matthew Gomez. All rights reserved.
//

import Foundation

class FoodItem:NSObject, NSCoding {
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
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.upc = aDecoder.decodeObject(forKey: "upc") as? String ?? ""
        self.expirationDate = aDecoder.decodeObject(forKey: "expirationDate") as? String ?? ""
        self.purchaseDate = aDecoder.decodeObject(forKey: "purchaseDate") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(upc, forKey: "upc")
        aCoder.encode(expirationDate, forKey: "expirationDate")
        aCoder.encode(purchaseDate, forKey: "purchaseDate")
    }
}
