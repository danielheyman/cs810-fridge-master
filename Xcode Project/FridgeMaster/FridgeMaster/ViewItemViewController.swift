//
//  ViewItemViewController.swift
//  FridgeMaster
//
//  Created by Daniel Heyman on 8/24/17.
//  Copyright © 2017 Matthew Gomez. All rights reserved.
//

import UIKit

class ViewItemViewController: UIViewController {
    
    @IBOutlet var resultLabel: UITextView!
    
    var item: FoodItem? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var resText = "upc: \(item!.upc!)\n\n" +
            "name: \(item!.name!)\n\n";
        
        if let nutrition = item!.nutrition {
            resText += "Serving size: \(nutrition.unit) \(nutrition.unit_type)\n\n";
            
            for fact in nutrition.nutrition_facts {
                resText += "\(fact.name): \(fact.value)\n";
            }
            
            resText += "\nIngredients:\n";
            
            for ingredient in nutrition.ingredients {
                resText += "\(ingredient)\n";
            }

        }

        self.resultLabel.text = resText;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
