//
//  InventoryViewController.swift
//  FridgeMaster
//
//  Created by Daniel Heyman on 8/23/17.
//  Copyright © 2017 Matthew Gomez. All rights reserved.
//

import UIKit

class InventoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var foods: [FoodItem] = [FoodItem(name: "Apple", upc: "Testing", expirationDate: "Expires", purchaseDate: "Purchased")]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = foods[indexPath.row].name + " Expires: " + foods[indexPath.row].expirationDate
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        // shouldn't this be editItemSegue
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "newItemSegue", sender: self)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newItemSegue" {
            let secondController = segue.destination as! NewItemViewController
            secondController.upcString = foods[selectedIndex].upc
        }
        // attempting to pass the fooditem array, not working as of writing this
        if segue.identifier == "deleteItemSegue" {
            let secondController = segue.destination as! DeleteViewController
            secondController.foods = foods
        }
    }
}
