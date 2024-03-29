//
//  LocationDetailVM.swift
//  Bount
//
//  Created by Connor Hutchinson on 3/12/24.
//

import SwiftUI
import FirebaseFirestore

class LocationDetailVM: ObservableObject {
    @Published var isEditing = false
    @Published var showingDeleteConfirmationAlert = false
    
    @Published var editedName: String = ""
    @Published var editedInventory: [String] = []
    
    @Published var selectedItems: Set<Item> = []
    @Published var isSelectingItems = false
    
    func saveChanges(location: inout Location, editedName: String, editedInventory: [String], completion: @escaping (Bool) -> Void) {

        location.name = editedName
        location.inventory = editedInventory

        // Get a reference to your Firestore database
        let db = Firestore.firestore()

        guard let locationID = location.id else {
            print("Location ID is nil. Cannot update Firestore document.")
            completion(false)
            return
        }
        let itemRef = db.collection("locations").document(locationID)

        // Create a data dictionary with the updated values
        let updatedData: [String: Any] = [
            "name": location.name,
            "inventory": location.inventory
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
