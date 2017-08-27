//
//  LoadingNutritionViewController.swift
//  FridgeMaster
//
//  Created by Daniel Heyman on 8/26/17.
//  Copyright © 2017 Matthew Gomez. All rights reserved.
//

import UIKit

class LoadingNutritionViewController: UIViewController {
    
    var upcString = String()
    var nutrition: Nutrition? = nil
    var errorString: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        findFromUpc(upc: upcString)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setError(error: String) {
        DispatchQueue.main.async(execute: {
            self.errorString = error
            self.performSegue(withIdentifier: "newItemSegue", sender: nil)
        })
    }
    
    func findFromUpc(upc: String) {
        let urlString = URL(string: "https://ndb.nal.usda.gov/ndb/search/list?qlookup=\(upc)")
        
        URLSession.shared.dataTask(with: urlString!) { (data, response, error) in
            if error != nil {
                self.setError(error: "Nutrition DB down - Error #1")
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
                self.setError(error: "Nutrition DB down - Error #2")
            } else {
                let res = String(data: data!, encoding: String.Encoding.utf8)
                
                if res != nil {
                    self.convertFromRes(res: res!)
                } else {
                    self.setError(error: "Nutrition DB down - Error #3")
                }
            }
        }.resume()
    }
    
    func convertFromRes(res: String) {
        let obj = Nutrition();
        
        let regex = try! NSRegularExpression(pattern: "for: (\\d+), ([\\S ]+), UPC[\\S\\s]+?,\"([.\\d]+) ([\\S ]+) = ([.\\d]+)g")
        let results = regex.matches(in: res, range: NSRange(location: 0, length: res.characters.count))
        if results.count == 1 {
            obj.ndb_id = Int32((res as NSString).substring(with: results[0].rangeAt(1)))!
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
        
        DispatchQueue.main.async(execute: {
            self.nutrition = obj
            self.performSegue(withIdentifier: "newItemSegue", sender: nil)
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newItemSegue" {
            let secondController = segue.destination as! NewItemViewController
            secondController.upcString = self.upcString
            secondController.nutrition = self.nutrition
            secondController.errorString = self.errorString
        }
    }

}
