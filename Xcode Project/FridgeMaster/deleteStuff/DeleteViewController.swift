//
//  DeleteViewController.swift
//  FridgeMaster
//
//  Created by Jeremy Doll on 8/24/17.
//  Copyright © 2017 Matthew Gomez. All rights reserved.
//

import Foundation

import UIKit

class DeleteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // delete this/dragndrop new
    // @IBOutlet var tableView: UITableView!
    
    // hopefully naming this the same doesn't cause issues
    @IBOutlet weak var tableView: UITableView!
    
    //var foods: [FoodItem] = [FoodItem(name: "Apple", upc: "Testing", expirationDate: "Expires", purchaseDate: "Purchased")]
    var foods: [FoodItem] = []
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // i suspect this is whats breaking it
        //if let x = UserDefaults.standard.object(forKey: "foodList") as? Data {
            //foods = NSKeyedUnarchiver.unarchiveObject(with: x) as! [FoodItem]
        //}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // makes proper number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count;
    }
    // puts stuff in cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = foods[indexPath.row].name + " Expires: " + foods[indexPath.row].expirationDate
        
        return cell
    }

    // the idea i was trying to implement: youtube.com/watch?v=peSXZi_nxek at like 28-29 minutes
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // delete dayta
            foods.remove(at: indexPath.row)
            // delete rows
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "removeToInventorySegue" {
            let secondController = segue.destination as! InventoryViewController
            secondController.foods = foods // not dure if right way to do this
        }
    }
}
