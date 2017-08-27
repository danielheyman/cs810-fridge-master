//
//  storageClass.swift
//  FridgeMaster
//
//  Created by Matthew Gomez on 8/22/17.
//  Copyright © 2017 Matthew Gomez. All rights reserved.
//

import Foundation

class NutritionFact: NSObject, NSCoding {
    var name: String
    var value: Float
    
    init(name: String, value: Float) {
        self.name = name
        self.value = value
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.value = aDecoder.decodeFloat(forKey: "value")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(value, forKey: "value")
    }
}

class Nutrition: NSObject, NSCoding {
    var ndb_id: Int32 = 0
    var name: String = ""
    var unit: Float = 0
    var unit_type: String = ""
    var eq_gram: Float = 0
    var ingredients: [String] = []
    var nutrition_facts: [NutritionFact] = []
    
    override init() {}
    
    required init?(coder aDecoder: NSCoder) {
        self.ndb_id = aDecoder.decodeInt32(forKey: "ndb_id")
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.unit = aDecoder.decodeFloat(forKey: "unit")
        self.unit_type = aDecoder.decodeObject(forKey: "unit_type") as? String ?? ""
        self.eq_gram = aDecoder.decodeFloat(forKey: "eq_gram")
        self.ingredients = aDecoder.decodeObject(forKey: "ingredients") as? [String] ?? []
        self.nutrition_facts = aDecoder.decodeObject(forKey: "nutrition_facts") as? [NutritionFact] ?? []
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(ndb_id, forKey: "ndb_id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(unit, forKey: "unit")
        aCoder.encode(unit_type, forKey: "unit_type")
        aCoder.encode(eq_gram, forKey: "eq_gram")
        aCoder.encode(ingredients, forKey: "ingredients")
        aCoder.encode(nutrition_facts, forKey: "nutrition_facts")
    }
}

class FoodItem: NSObject, NSCoding {
    var name: String!
    var upc: String!
    var expirationDate: String!
    var purchaseDate: String!
    var nutrition: Nutrition?
    
    init(name:String, upc:String, expirationDate:String, purchaseDate:String, nutrition:Nutrition?) {
        self.name = name
        self.upc = upc
        self.expirationDate = expirationDate
        self.purchaseDate = purchaseDate
        self.nutrition = nutrition
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.upc = aDecoder.decodeObject(forKey: "upc") as? String ?? ""
        self.expirationDate = aDecoder.decodeObject(forKey: "expirationDate") as? String ?? ""
        self.purchaseDate = aDecoder.decodeObject(forKey: "purchaseDate") as? String ?? ""
        self.nutrition = aDecoder.decodeObject(forKey: "nutrition") as? Nutrition ?? nil
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(upc, forKey: "upc")
        aCoder.encode(expirationDate, forKey: "expirationDate")
        aCoder.encode(purchaseDate, forKey: "purchaseDate")
        aCoder.encode(nutrition, forKey: "nutrition")
    }
}
