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
    var foods: [FoodItem] = [FoodItem(name: "Apple Juice", upc: "076301721289", expirationDate: "10/10/17", purchaseDate: "9/10/17")]
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "viewItemSegue", sender: self)
        })
    }
    
    // this is the delete function
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // delete dayta
            foods.remove(at: indexPath.row)
            // delete rows
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewItemSegue" {
            let secondController = segue.destination as! ViewItemViewController
            secondController.upcString = foods[selectedIndex].upc
        }
        //if segue.identifier == "deleteItemSegue" {
          //  let secondController = segue.destination as! DeleteViewController
            //secondController.foodArr = foods
        //}
    }
}
