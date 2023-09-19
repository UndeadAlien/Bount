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
    
    init() {}
    
    func saveVendorToFirestore(completion: @escaping (Bool) -> Void) {
        // Convert selected item IDs to an array of strings
        let selectedItemsIDs = selectedItems.map { $0.id }

        // Create a dictionary with the vendor data
        let vendorData: [String: Any] = [
            "name": vendorName,
            "inventory": selectedItemsIDs
        ]

        // Add the vendor data to Firestore
        let vendorsRef = Firestore.firestore().collection("vendors")
        
        vendorsRef.addDocument(data: vendorData) { error in
            if let error = error {
                print("Error adding vendor to Firestore: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Vendor added successfully")
                completion(true)
            }
        }
    }
    
    func reset() {
        self.vendorName = ""
        self.selectedItems.removeAll()
    }
}
