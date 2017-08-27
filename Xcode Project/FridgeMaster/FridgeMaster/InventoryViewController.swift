//
//  InventoryViewController.swift
//  FridgeMaster
//
//  Created by Daniel Heyman on 8/23/17.
//  Copyright © 2017 Matthew Gomez. All rights reserved.
//

import UIKit

class InventoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var foods: [FoodItem] = []
    var selectedIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let x = UserDefaults.standard.object(forKey: "foodList") as? Data {
            foods = NSKeyedUnarchiver.unarchiveObject(with: x) as! [FoodItem]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InventoryTableViewCell
        cell.title.text = foods[indexPath.row].name
        cell.expiration.text = foods[indexPath.row].expirationDate
        if let nutrition = foods[indexPath.row].nutrition {
            var protein: Float = 0
            var carbs: Float = 0
            var fat: Float = 0
            
            for fact in nutrition.nutrition_facts {
                if fact.name == "Protein" {
                    protein = fact.value
                }
                else if fact.name == "Carbohydrate, by difference" {
                    carbs = fact.value
                }
                else if fact.name == "Total lipid (fat)" {
                    fat = fact.value
                }
            }

            let calories = protein * 4 + carbs * 4 + fat * 9
            if calories != 0 {
                protein = (protein * 4 / calories * 100).rounded()
                carbs = (carbs * 4 / calories * 100).rounded()
                fat = (fat * 9 / calories * 100).rounded()
            }
            
            cell.nutrition.text = "P:\(Int(protein))% F:\(Int(fat))% C:\(Int(carbs))%"
        } else {
            cell.nutrition.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete from storage
            foods.remove(at: indexPath.row)
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: foods)
            UserDefaults.standard.set(encodedData, forKey: "foodList")
            
            // Delete from table view
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async(execute: {
            self.selectedIndex = indexPath.row
            self.performSegue(withIdentifier: "viewItemSegue", sender: self)
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewItemSegue" {
            let secondController = segue.destination as! ViewItemViewController
            secondController.item = foods[selectedIndex]
        }
    }
}
