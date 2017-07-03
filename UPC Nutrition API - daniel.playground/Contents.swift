import UIKit
import PlaygroundSupport
import Foundation

// Suport for API requests
PlaygroundPage.current.needsIndefiniteExecution = true
URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)


func findFromUpc(upc: String) {
    let urlString = URL(string: "https://ndb.nal.usda.gov/ndb/search/list?qlookup=\(upc)")
    
    URLSession.shared.dataTask(with: urlString!) { (data, response, error) in
        if error != nil {
            print("error")
        } else {
            let res = String(data: data!, encoding: String.Encoding.utf8)
            
            if res!.range(of:"Click to view reports for this food") != nil {
                let id = (res!).components(separatedBy: "/ndb/foods/show/")[1].components(separatedBy: "?")[0]
                
                findFromId(upc: upc, id: id)
            } else {
                print("> CANNOT FIND UPC \(upc)")
            }
            
        }
    }.resume()
}


func findFromId(upc: String, id: String) {
    let urlString = URL(string: "https://ndb.nal.usda.gov/ndb/foods/show/\(id)?format=Abridged&reportfmt=csv&Qv=1")
    
    URLSession.shared.dataTask(with: urlString!) { (data, response, error) in
        if error != nil {
            print("error")
        } else {
            let res = String(data: data!, encoding: String.Encoding.utf8)
            
            print("> FOUND UPC \(upc)")
            print(res!)
            
        }
    }.resume()
}

findFromUpc(upc: "743289")
findFromUpc(upc: "041331024914")


/* Example response:
 > CANNOT FIND UPC 743289
 > FOUND UPC 041331024914
 Source: USDA Branded Food Products Database Release June 2017 Software v.3.8.5.1 2017-06-28
 Report Run at: July 02, 2017 23:05 EDT
 "Nutrient data for: 45108270, YELLOW SPLIT PEAS, UPC: 041331024914"
 Food Group:  Branded Food Products Database
 Common Name:
 
 Nutrient,Unit,Data points,Std. Error,"0.25 cup = 50.0g",1Value per 100 g,
 Proximates
 "Energy",kcal,--,--,180,360
 "Protein",g,--,--,11.00,22.00
 "Total lipid (fat)",g,--,--,1.00,2.00
 "Carbohydrate, by difference",g,--,--,32.00,64.00
 "Fiber, total dietary",g,--,--,16.0,32.0
 "Sugars, total",g,--,--,1.00,2.00
 Minerals
 "Calcium, Ca",mg,--,--,20,40
 "Iron, Fe",mg,--,--,1.08,2.16
 "Sodium, Na",mg,--,--,0,0
 Vitamins
 "Vitamin C, total ascorbic acid",mg,--,--,1.2,2.4
 "Vitamin A, IU",IU,--,--,0,0
 Lipids
 "Fatty acids, total saturated",g,--,--,0.000,0.000
 "Fatty acids, total trans",g,--,--,0.000,0.000
 "Cholesterol",mg,--,--,0,0
 Amino Acids
 Other
 Ingredients
 "YELLOW SPLIT PEAS" Date available: 03/22/2017 Date last updated by company: 03/22/2017
*/
