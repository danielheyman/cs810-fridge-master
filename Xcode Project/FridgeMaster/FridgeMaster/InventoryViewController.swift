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
            var energy: Float = 0
            var protein: Float = 0
            var carbs: Float = 0
            var fat: Float = 0
            for fact in nutrition.nutrition_facts {
                if fact.name == "Energy" {
                    energy = fact.value
                }
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
            if energy != 0 {
                protein = (protein * 4 / energy * 1000).rounded() / 10
                carbs = (carbs * 4 / energy * 1000).rounded() / 10
                fat = (fat * 9 / energy * 1000).rounded() / 10
            }
            cell.nutrition.text = "P\(protein)%/F\(fat)%/C\(carbs)%"
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
