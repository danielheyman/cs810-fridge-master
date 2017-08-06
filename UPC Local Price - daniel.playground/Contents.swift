import UIKit
import PlaygroundSupport
import Foundation

// Suport for API requests
PlaygroundPage.current.needsIndefiniteExecution = true
URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)


func findFromUpc(upc: String) {
    
    let urlString = URL(string: "https://shop.shoprite.com/api/product/v5/product/store/7EF2370/sku/\(upc)")
    
    var request = URLRequest(url: urlString!)
    // Set headers
    request.setValue("6f165087-ef7a-e711-a7af-d89d6763b1d9", forHTTPHeaderField: "authorization")
    let completionHandler = {(data: Data?, response: URLResponse?, error: Error?) -> Void in
        if error != nil {
            print("error")
        } else if let httpResponse = response as? HTTPURLResponse {
            let res = String(data: data!, encoding: String.Encoding.utf8)
            if httpResponse.statusCode == 200 {
                let regex = try! NSRegularExpression(pattern: "\"\\$([\\d.]+)\"")
                let results = regex.matches(in: res!, range: NSRange(location: 0, length: res!.characters.count))
                if results.count > 0 {
                    let price = (res! as NSString).substring(with: results[0].rangeAt(1))
                    print("> Price for UPC \(upc) is $\(price)")
                } else {
                    print("> A strange error occured with UPC \(upc)")
                }
            } else {
                print("> CANNOT FIND UPC \(upc)")
            }
        } else {
            print("> CANNOT FIND UPC \(upc)")
        }
    }
    
    URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
}

findFromUpc(upc: "743289")
findFromUpc(upc: "048121277079")


/* Example response:
 > CANNOT FIND UPC 743289
 > Price for UPC 048121277079 is $4.69
*/
