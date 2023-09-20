//
//  ItemVM.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/13/23.
//

import Foundation
import FirebaseFirestore

class ItemVM : ObservableObject {
    
    func saveChanges(item: inout Item, editedPrice: String, editedType: ItemType, completion: @escaping (Bool) -> Void) {
        // Update Firestore with edited values
        guard let price = Int(editedPrice) else {
            completion(false)
            return
        }

        item.price = price
        item.type = editedType

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
            "price": item.price ?? 0,
            "type": item.type.rawValue
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
}
