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
            
            convertFromRes(res: res!)
            
        }
    }.resume()
}

struct Nutrition {
    var ndb_id: Int = 0
    var name: String = ""
    var unit: Float = 0
    var unit_type: String = ""
    var eq_gram: Float = 0
    var ingredients: [String] = []
    var nutrition_facts: [NutritionFact] = []
}

struct NutritionFact {
    let name: String
    let value: Float
}

func convertFromRes(res: String) {
    print(res)
    var obj = Nutrition();
    
    let regex = try! NSRegularExpression(pattern: "for: (\\d+), ([\\S ]+), UPC[\\S\\s]+?,\"([.\\d]+) ([\\S ]+) = ([.\\d]+)g")
    let results = regex.matches(in: res, range: NSRange(location: 0, length: res.characters.count))
    if results.count == 1 {
        obj.ndb_id = Int((res as NSString).substring(with: results[0].rangeAt(1)))!
        obj.name = (res as NSString).substring(with: results[0].rangeAt(2))
        obj.unit = Float((res as NSString).substring(with: results[0].rangeAt(3)))!
        obj.unit_type = (res as NSString).substring(with: results[0].rangeAt(4))
        obj.eq_gram = Float((res as NSString).substring(with: results[0].rangeAt(5)))!
    }
    
    let regexIngredients = try! NSRegularExpression(pattern: "Ingredients\\s\"([\\S\\s]+?)\\.{0,1}\"")
    let resultsIngredients = regexIngredients.matches(in: res, range: NSRange(location: 0, length: res.characters.count))
    if resultsIngredients.count == 1 {
        obj.ingredients = (res as NSString).substring(with: resultsIngredients[0].rangeAt(1)).components(separatedBy: ",")
    }
    
    let regexAll = try! NSRegularExpression(pattern: "\"([\\S ]+)\",\\w+(?:\\S+)?,([\\d.]+),[\\d.]+")
    let resultsAll = regexAll.matches(in: res, range: NSRange(location: 0, length: res.characters.count))
    if resultsAll.count > 0 {
        obj.nutrition_facts = resultsAll.map {x -> NutritionFact in
            return NutritionFact(
                name: (res as NSString).substring(with: x.rangeAt(1)),
                value: Float((res as NSString).substring(with: x.rangeAt(2)))!
            )
        }
    }
    
    print(obj)
}

findFromUpc(upc: "743289")
findFromUpc(upc: "041331024914")


/* Example response:
 > CANNOT FIND UPC 743289
 > FOUND UPC 041331024914
Nutrition(
 ndb_id: 45108270, 
 name: "YELLOW SPLIT PEAS", 
 unit: 0.25, 
 unit_type: "cup", 
 eq_gram: 50.0, 
 ingredients: ["YELLOW SPLIT PEAS"],
 nutrition_facts: [
    NutritionFact(name: "Energy", value: 180.0),
    NutritionFact(name: "Protein", value: 11.0),
    NutritionFact(name: "Total lipid (fat)", value: 1.0),
    NutritionFact(name: "Carbohydrate, by difference", value: 32.0),
    NutritionFact(name: "Fiber, total dietary", value: 16.0),
    NutritionFact(name: "Sugars, total", value: 1.0),
    NutritionFact(name: "Calcium, Ca", value: 20.0),
    NutritionFact(name: "Iron, Fe", value: 1.08),
    NutritionFact(name: "Sodium, Na", value: 0.0),
    NutritionFact(name: "Vitamin C, total ascorbic acid", value: 1.2),
    NutritionFact(name: "Vitamin A, IU", value: 0.0),
    NutritionFact(name: "Fatty acids, total saturated", value: 0.0),
    NutritionFact(name: "Fatty acids, total trans", value: 0.0),
    NutritionFact(name: "Cholesterol", value: 0.0)
 ]
)
*/
