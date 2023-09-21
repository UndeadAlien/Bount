//
//  CSVtoFirebaseView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/21/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ContentView: View {
    // Firestore reference
    let db = Firestore.firestore()
    
    func parseCSV(from fileURL: URL) -> [[String: Any]] {
        guard let csvString = try? String(contentsOf: fileURL) else {
            print("Failed to read CSV file.")
            return []
        }
        
        var dataArray: [[String: Any]] = []
        
        let rows = csvString.split(separator: "\r\n").map { $0 }
        
        for row in rows {
            let columns = row.split(separator: ",").map { String($0) } // Convert to String
                
            if columns.count >= 2 {
                let itemName = columns[0]
                let priceString = columns[1]
                
                if let price = Int(priceString) {
                    let itemData: [String: Any] = [
                        "name": itemName,
                        "price": price,
                    ]
                    
                    dataArray.append(itemData)
                } else {
                    print("Invalid price format in CSV row: \(row)")
                }
            } else {
                print("Invalid CSV row format: \(row)")
            }
        }
        
        return dataArray
    }

    
    func uploadToFirestore(from fileURL: URL) {
        let items = parseCSV(from: fileURL)
        
        let batch = db.batch()
        
        for item in items {
            let itemName = item["name"] as! String
            let itemPrice = item["price"] as! Int
            
            let newItem = Item(name: itemName, price: itemPrice, type: ItemType.UNKNOWN)
            print(newItem)
            
            let newItemRef = db.collection("items").document()
            batch.setData(newItem.itemToDictionary(item: newItem), forDocument: newItemRef)
        }
        
        batch.commit { error in
            if let error = error {
                print("Error committing batch: \(error)")
            } else {
                print("Batch write successful")
            }
        }
    }


    var body: some View {
        VStack {
            Button("Upload CSV to Firestore") {
                if let fileURL = Bundle.main.url(forResource: "inventory_no_vendors", withExtension: "csv") {
                    uploadToFirestore(from: fileURL)
                } else {
                    print("CSV file not found.")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
