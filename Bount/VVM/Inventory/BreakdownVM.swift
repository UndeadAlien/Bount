//
//  BreakdownVM.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/18/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class BreakdownVM : ObservableObject {
    @Published var selectedItem: Item? = nil // To store the fetched item
    
    @Published var items: [Item] = []
    @Published var dbItems: [Item] = []
    
    let db = Firestore.firestore()
    
    init() {}
    
    
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
