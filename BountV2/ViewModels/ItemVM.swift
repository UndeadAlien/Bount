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
    @Published var editedName: String = ""
    @Published var editedType: ItemType = .VODKA
    @Published var editedActivity: Bool = false
    
    @Published var showingDeleteConfirmationAlert = false
    
    func saveChanges(
        item: inout Item,
        editedName: String,
        editedType: ItemType,
        editedActivity: Bool,
        completion: @escaping (Bool) -> Void)
    {

        item.name = editedName
        item.type = editedType

        let db = Firestore.firestore()

        guard let itemID = item.id else {
            print("Item ID is nil. Cannot update Firestore document.")
            completion(false)
            return
        }
        let itemRef = db.collection("items").document(itemID)

        let updatedData: [String: Any] = [
            "name": item.name,
            "type": item.type.rawValue
        ]
        
        itemRef.updateData(updatedData) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Document updated successfully!")
                completion(true)
            }
        }
    }
    
    func deleteItem(item: Item, completion: @escaping (Bool) -> Void) {
        guard let itemId = item.id else {
            completion(false)
            return
        }
        
        let itemsCollection = Firestore.firestore().collection("items")

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
