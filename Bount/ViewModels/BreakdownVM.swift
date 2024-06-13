//
//  BreakdownVM.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/18/23.
//

import Firebase
import FirebaseFirestore

class BreakdownVM : ObservableObject {
    @Published var selectedItem: Item? = nil
    
    @Published var dbItems: [Item] = []
    
    @Published var searchText = ""
    
    let db = Firestore.firestore()
    
    init() {}
    
    func removePunctuation(from text: String) -> String {
        let punctuationSet = CharacterSet.punctuationCharacters
        let filteredText = text.components(separatedBy: punctuationSet).joined(separator: "")
        return filteredText
    }
    
    func sortItems(mapping: [InventoryCountMapping]) -> [InventoryCountMapping] {
        let sortedItems = mapping.sorted { item1, item2 in
            guard let item1Name = self.dbItems.first(where: { $0.id == item1.itemID })?.name,
                  let item2Name = self.dbItems.first(where: { $0.id == item2.itemID })?.name else {
                return false
            }

            let item1NumericValue = extractLeadingNumericValue(from: item1Name)
            let item2NumericValue = extractLeadingNumericValue(from: item2Name)

            switch (item1NumericValue, item2NumericValue) {
            case let (num1?, num2?):
                // Both names start with numeric values
                if num1 == num2 {
                    return item1Name < item2Name
                }
                return num1 < num2
            case (nil, nil):
                // Neither name starts with a numeric value
                return item1Name < item2Name
            case (nil, _?):
                // Only item2 starts with a numeric value
                return false
            case (_?, nil):
                // Only item1 starts with a numeric value
                return true
            }
        }
        return sortedItems
    }

    func extractLeadingNumericValue(from name: String) -> Int? {
        let scanner = Scanner(string: name)
        var numericValue: Int = 0
        if scanner.scanInt(&numericValue) {
            return numericValue
        }
        return nil
    }
    
    // Define a function to format the date
    func formattedDate(from timestamp: Timestamp?) -> String {
        guard let timestamp = timestamp else {
            return "No date available"
        }
        
        let date = timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    func fetchItems() {
        let db = Firestore.firestore()
        db.collection("items").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching items: \(error.localizedDescription)")
                return
            }

            guard let querySnapshot = querySnapshot else {
                return
            }

            self.dbItems = querySnapshot.documents.compactMap { (document) -> Item? in
                do {
                    return try document.data(as: Item.self)
                } catch {
                    print("Error decoding items: \(error.localizedDescription)")
                    return nil
                }
            }
        }
    }
    
    // Function to fetch an item by ID from Firestore
    func fetchItemByID(itemID: String) {
        let db = Firestore.firestore()
        let itemsRef = db.collection("items")
        
        // Query Firestore to get the item with a matching ID
        itemsRef.document(itemID).getDocument { (document, error) in
            if let error = error {
                print("Error fetching item by ID: \(error.localizedDescription)")
            } else if let document = document, document.exists {
                do {
                    let item = try document.data(as: Item.self)
                    // Update the @State variable to store the fetched item
                    self.selectedItem = item
                } catch {
                    print("Error decoding item: \(error.localizedDescription)")
                }
            } else {
                print("Item with ID \(itemID) not found")
            }
        }
    }
}
