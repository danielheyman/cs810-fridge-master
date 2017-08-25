//
//  ViewItemViewController.swift
//  FridgeMaster
//
//  Created by Daniel Heyman on 8/24/17.
//  Copyright © 2017 Matthew Gomez. All rights reserved.
//

import UIKit

struct Nutrition {
    var ndb_id: Int = 0
    var name: String = ""
    var unit: Float = 0
    var unit_type: String = ""
    var eq_gram: Float = 0
    var ingredients: [String] = []
    var nutrition_facts: [NutritionFact] = []
}

struct NutritionFact {
    let name: String
    let value: Float
}

class ViewItemViewController: UIViewController {
    
    @IBOutlet var resultLabel: UITextView!
    
    var upcString = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        findFromUpc(upc: upcString);

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setError(error: String) {
        DispatchQueue.main.async(execute: {
            self.resultLabel.text = error;
        })
    }
    
    func findFromUpc(upc: String) {
        let urlString = URL(string: "https://ndb.nal.usda.gov/ndb/search/list?qlookup=\(upc)")
        
        URLSession.shared.dataTask(with: urlString!) { (data, response, error) in
            if error != nil {
                self.setError(error: "Nutrition DB down")
            } else {
                let res = String(data: data!, encoding: String.Encoding.utf8)
                
                if res!.range(of:"Click to view reports for this food") != nil {
                    let id = (res!).components(separatedBy: "/ndb/foods/show/")[1].components(separatedBy: "?")[0]
                    
                    self.findFromId(upc: upc, id: id)
                } else {
                    self.setError(error: "Cannot find upc \(upc)")
                }
                
            }
        }.resume()
    }
    
    
    func findFromId(upc: String, id: String) {
        let urlString = URL(string: "https://ndb.nal.usda.gov/ndb/foods/show/\(id)?format=Abridged&reportfmt=csv&Qv=1")
        
        URLSession.shared.dataTask(with: urlString!) { (data, response, error) in
            if error != nil {
                self.setError(error: "Nutrition DB down")
            } else {
                let res = String(data: data!, encoding: String.Encoding.utf8)
                
                if res != nil {
                    self.convertFromRes(res: res!)
                } else {
                    self.setError(error: "Nutrition DB down")
                }
            }
        }.resume()
    }
    
    func convertFromRes(res: String) {
        var obj = Nutrition();
        
        let regex = try! NSRegularExpression(pattern: "for: (\\d+), ([\\S ]+), UPC[\\S\\s]+?,\"([.\\d]+) ([\\S ]+) = ([.\\d]+)g")
        let results = regex.matches(in: res, range: NSRange(location: 0, length: res.characters.count))
        if results.count == 1 {
            obj.ndb_id = Int((res as NSString).substring(with: results[0].rangeAt(1)))!
            obj.name = (res as NSString).substring(with: results[0].rangeAt(2))
            obj.unit = Float((res as NSString).substring(with: results[0].rangeAt(3)))!
            obj.unit_type = (res as NSString).substring(with: results[0].rangeAt(4))
            obj.eq_gram = Float((res as NSString).substring(with: results[0].rangeAt(5)))!
        }
        
        let regexIngredients = try! NSRegularExpression(pattern: "Ingredients\\s\"([\\S\\s]+?)\\.{0,1}\"")
        let resultsIngredients = regexIngredients.matches(in: res, range: NSRange(location: 0, length: res.characters.count))
        if resultsIngredients.count == 1 {
            obj.ingredients = (res as NSString).substring(with: resultsIngredients[0].rangeAt(1)).components(separatedBy: ",")
        }
        
        let regexAll = try! NSRegularExpression(pattern: "\"([\\S ]+)\",\\w+(?:\\S+)?,([\\d.]+),[\\d.]+")
        let resultsAll = regexAll.matches(in: res, range: NSRange(location: 0, length: res.characters.count))
        if resultsAll.count > 0 {
            obj.nutrition_facts = resultsAll.map {x -> NutritionFact in
                return NutritionFact(
                    name: (res as NSString).substring(with: x.rangeAt(1)),
                    value: Float((res as NSString).substring(with: x.rangeAt(2)))!
                )
            }
        }
        
        var resText = "upc: \(self.upcString)\n\n" +
            "name: \(obj.name)\n\n" +
            "Serving size: \(obj.unit) \(obj.unit_type)\n\n";
        
        for fact in obj.nutrition_facts {
            resText += "\(fact.name): \(fact.value)\n";
        }

        resText += "\nIngredients:\n";
        
        for ingredient in obj.ingredients {
            resText += "\(ingredient)\n";
        }
        
        DispatchQueue.main.async(execute: {
            self.resultLabel.text = resText;
        })
        
        // return obj;
    }
}
