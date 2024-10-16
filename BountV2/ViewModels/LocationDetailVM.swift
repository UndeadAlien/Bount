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
    
    func saveChanges(location: inout Location, editedName: String, completion: @escaping (Bool) -> Void) {

        location.name = editedName

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
            "name": location.name
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
    
    func deleteLocation(location: String, completion: @escaping (Bool) -> Void) {
        // Reference to the Firestore collection containing items
        let locationsCollection = Firestore.firestore().collection("locations")

        // Delete the item from Firestore
        locationsCollection.document(location).delete { error in
            if let error = error {
                completion(false)
                print("Error deleting location: \(error.localizedDescription)")
            } else {
                completion(true)
                print("Location deleted successfully!")
            }
        }
    }
}
