//
//  VendorInventoryVM.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/20/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class VendorInventoryVM: ObservableObject {
    @Published var isEditing = false
    @Published var showingDeleteConfirmationAlert = false
    
    @Published var editedName: String = ""
    @Published var editedInventory: [String] = []
    
    @Published var selectedItems: Set<Item> = []
    @Published var isSelectingItems = false
    
    init() {}
    
    func saveChanges(vendor: inout Vendor, editedName: String, editedInventory: [String], completion: @escaping (Bool) -> Void) {

        vendor.name = editedName
        vendor.inventory = editedInventory

        // Get a reference to your Firestore database
        let db = Firestore.firestore()

        guard let vendorID = vendor.id else {
            print("Vendor ID is nil. Cannot update Firestore document.")
            completion(false)
            return
        }
        let itemRef = db.collection("vendors").document(vendorID)

        // Create a data dictionary with the updated values
        let updatedData: [String: Any] = [
            "name": vendor.name,
            "inventory": vendor.inventory
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
    
    func deleteVendor(vendor: String, completion: @escaping (Bool) -> Void) {
        // Reference to the Firestore collection containing items
        let itemsCollection = Firestore.firestore().collection("vendors")

        // Delete the item from Firestore
        itemsCollection.document(vendor).delete { error in
            if let error = error {
                completion(false)
                print("Error deleting vendor: \(error.localizedDescription)")
            } else {
                completion(true)
                print("Vendor deleted successfully!")
            }
        }
    }
    
}

