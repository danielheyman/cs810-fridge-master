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
    
    var upcString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upcField.text = upcString;
        // Do any additional setup after loading the view.
        
        // This is a test of getting the stored data. The stored data will be written to the console.
        if let x = UserDefaults.standard.object(forKey: "foodList") as? Data {
            let decoded = NSKeyedUnarchiver.unarchiveObject(with: x) as! [FoodItem]
            print(decoded)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createButton() {
        let item = FoodItem(name: nameField.text!, upc: upcField.text!, expirationDate: expirationDate.text!, purchaseDate: purchaseDate.text!)
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
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
