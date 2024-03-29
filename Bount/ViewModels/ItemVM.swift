//
//  ItemVM.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/13/23.
//

import Foundation
import FirebaseFirestore

class ItemVM : ObservableObject {
    
    @Published var isEditing = false
    
    // editing
    @Published var editedName: String = ""
    @Published var editedPrice: Int = 0
    @Published var editedType: ItemType = .VODKA
    @Published var editedActivity: Bool = false
    
    @Published var showingDeleteConfirmationAlert = false
    
    func saveChanges(
        item: inout Item,
        editedName: String,
        editedPrice: Int,
        editedType: ItemType,
        editedActivity: Bool,
        completion: @escaping (Bool) -> Void)
    {
        // Update Firestore with edited values
        guard editedPrice >= 0 else {
            completion(false)
            return
        }

        item.name = editedName
        item.price = editedPrice
        item.type = editedType
        item.isActive = editedActivity

        // Get a reference to your Firestore database
        let db = Firestore.firestore()

        guard let itemID = item.id else {
            print("Item ID is nil. Cannot update Firestore document.")
            completion(false)
            return
        }
        let itemRef = db.collection("items").document(itemID)

        // Create a data dictionary with the updated values
        let updatedData: [String: Any] = [
            "name": item.name,
            "price": item.price ?? 0,
            "type": item.type.rawValue,
            "isActive": item.isActive
        ]

        // Update the document in Firestore
        itemRef.updateData(updatedData) { error in
            if let error = error {
                // Handle the error here
                print("Error updating document: \(error.localizedDescription)")
                completion(false)
            } else {
                // Document updated successfully
                print("Document updated successfully!")
                completion(true)
            }
        }
    }
    
    func deleteItem(item: Item, completion: @escaping (Bool) -> Void) {
        guard let itemId = item.id else {
            completion(false)
            return // Item does not have an ID, so it cannot be deleted
        }

        // Reference to the Firestore collection containing items
        let itemsCollection = Firestore.firestore().collection("items")

        // Delete the item from Firestore
        itemsCollection.document(itemId).delete { error in
            if let error = error {
                completion(false)
                print("Error deleting item: \(error.localizedDescription)")
            } else {
                completion(true)
                print("Item deleted successfully!")
            }
        }
    }
}
