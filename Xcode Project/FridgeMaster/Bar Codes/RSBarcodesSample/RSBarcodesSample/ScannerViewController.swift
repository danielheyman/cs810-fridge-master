//
//  BarcodeReaderViewController.swift
//  RSBarcodesSample
//
//  Created by R0CKSTAR on 6/10/14.
//
//  Updated by Jarvie8176 on 01/21/2016
//
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//
// Modified by Matthew Gomez on 7/16/2017
//

import UIKit
import AVFoundation
import RSBarcodes

class ScannerViewController: RSCodeReaderViewController {

    @IBOutlet var toggle: UIButton!
    @IBAction func toggle(_ sender: AnyObject?) {
        print(self.toggleTorch());
    }
    
    var barcode: String = ""
    var dispatched: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.focusMarkLayer.strokeColor = UIColor.red.cgColor
        
        self.cornersLayer.strokeColor = UIColor.yellow.cgColor
        
        // MARK: NOTE: If you want to detect specific barcode types, you should update the types
        let types = NSMutableArray(array: self.output.availableMetadataObjectTypes)
        // MARK: NOTE: Uncomment the following line remove QRCode scanning capability
        types.remove(AVMetadataObjectTypeQRCode)
        self.output.metadataObjectTypes = NSArray(array: types) as [AnyObject]
        
        self.toggle.isEnabled = self.hasTorch()
        
        self.barcodesHandler = { barcodes in
            if !self.dispatched { // triggers for only once
                self.dispatched = true
                for barcode in barcodes {
                    var upc:String = barcode.stringValue
                    if upc.characters.first == "0"
                    {
                        upc.remove(at: upc.startIndex)
                    }

                    self.barcode = upc
                    print("Barcode found: type= " + barcode.type + " value= " + barcode.stringValue)
                    DispatchQueue.main.async(execute: {
                        self.performSegue(withIdentifier: "loadingNutritionSegue", sender: nil)
                    })
                    //self.reset();
                    return;
                }
            }
        }
    }
    
    
    @IBAction func DemoButtonPress(_ sender: UIButton) {
        barcode = "076301721289"
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "loadingNutritionSegue", sender: nil)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loadingNutritionSegue" {
            let secondController = segue.destination as! LoadingNutritionViewController
            secondController.upcString = barcode
        }
    }
    
    func reset() {
        self.dispatched = false;
    }
}
