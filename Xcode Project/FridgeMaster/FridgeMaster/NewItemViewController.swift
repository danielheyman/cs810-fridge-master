//
//  NewItemViewController.swift
//  FridgeMaster
//
//  Created by Matthew Gomez on 8/21/17.
//  Copyright © 2017 Matthew Gomez. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var upcField: UITextField!
    @IBOutlet weak var purchaseDate: UITextField!
    @IBOutlet weak var expirationDate: UITextField!
    @IBOutlet var errorField: UILabel!

    var upcString = String()
    var nutrition: Nutrition? = nil
    var errorString: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upcField.text = upcString
        upcField.isEnabled = false
        nameField.text = nutrition?.name
        errorField.text = errorString
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        purchaseDate.text = formatter.string(from: date)
        // Add a week in seconds
        expirationDate.text = formatter.string(from: date.addingTimeInterval(60 * 60 * 24 * 7))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createButtonPress(_ sender:UIButton) {
        let item = FoodItem(name: nameField.text!, upc: upcField.text!, expirationDate: expirationDate.text!, purchaseDate: purchaseDate.text!, nutrition: nutrition)
        if let x = UserDefaults.standard.object(forKey: "foodList") as? Data {
            var decoded = NSKeyedUnarchiver.unarchiveObject(with: x) as! [FoodItem]
            decoded.append(item)
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: decoded)
            UserDefaults.standard.set(encodedData, forKey: "foodList")
        } else {
            var foodListArray = [FoodItem]()
            foodListArray.append(item)
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: foodListArray)
            UserDefaults.standard.set(encodedData, forKey: "foodList")
        }
        print("Stored Item: ", item)
        
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "invetoryTableSegue", sender: nil)
        })

    }

}
