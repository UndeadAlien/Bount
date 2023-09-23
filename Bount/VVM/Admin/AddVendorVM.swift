//
//  AddVendorVM.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/19/23.
//

import FirebaseFirestore

class AddVendorVM : ObservableObject {
    
    @Published var vendorName = ""
    @Published var vendorInventory: [String] = []
    @Published var selectedItems: Set<Item> = []
    @Published var isSelectingItems = false
    
    @Published var showingErrorAlert = false
    @Published var errorMessage = ""
    
    init() {}
    
    func addVendorToFirestore(completion: @escaping (Bool, String) -> Void) {
        if vendorName.isEmpty {
            completion(false, "Vendor name cannot be empty")
            return
        }

        // Check if a vendor with the same name already exists
        Firestore.firestore().collection("vendors")
            .whereField("name", isEqualTo: vendorName)
            .getDocuments { (snapshot, error) in
                if error != nil {
                    completion(false, "Error checking vendor name")
                    return
                }

                if let snapshot = snapshot, !snapshot.isEmpty {
                    // Vendor with the same name already exists
                    completion(false, "Vendor with the same name already exists")
                    return
                }

                // Convert selected item IDs to an array of strings
                let selectedItemsIDs = self.selectedItems.map { $0.id }

                // Create a dictionary with the vendor data
                let vendorData: [String: Any] = [
                    "name": self.vendorName,
                    "inventory": selectedItemsIDs
                ]

                // Add the vendor data to Firestore
                Firestore.firestore().collection("vendors").addDocument(data: vendorData) { error in
                    if error != nil {
                        completion(false, "Error adding vendor")
                    } else {
                        completion(true, "")
                    }
                }
            }
    }

    
    func reset() {
        self.vendorName = ""
        self.selectedItems.removeAll()
    }
}
