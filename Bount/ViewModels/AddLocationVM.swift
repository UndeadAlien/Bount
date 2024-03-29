//
//  AddLocationVM.swift
//  Bount
//
//  Created by Connor Hutchinson on 3/8/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class AddLocationVM: ObservableObject {
    @Published var locationName = ""
    @Published var locationInventory: [String] = []
    
    @Published var selectedItems: Set<Item> = []
    @Published var isSelectingItems = false
    
    @Published var showingErrorAlert = false
    @Published var errorMessage = ""
    
    init() {}
    
    func addLocationToFirebase(completion: @escaping (Bool, String) -> Void) {
        if self.locationName.isEmpty {
            completion(false, "Location name cannot be empty")
            return
        }

        // Check if a vendor with the same name already exists
        Firestore.firestore().collection("locations")
            .whereField("name", isEqualTo: self.locationName)
            .getDocuments { (snapshot, error) in
                if error != nil {
                    completion(false, "Error checking location name")
                    return
                }

                if let snapshot = snapshot, !snapshot.isEmpty {
                    // Location with the same name already exists
                    completion(false, "Location with the same name already exists")
                    return
                }

                // Convert selected item IDs to an array of strings
                let selectedItemsIDs = self.selectedItems.map { $0.id }

                // Create a dictionary with the location data
                let locationData: [String: Any] = [
                    "name": self.locationName,
                    "inventory": selectedItemsIDs
                ]

                // Add the location data to Firestore
                Firestore.firestore().collection("locations").addDocument(data: locationData) { error in
                    if error != nil {
                        completion(false, "Error adding location")
                    } else {
                        completion(true, "")
                    }
                }
            }
    }

    
    func reset() {
        self.locationName = ""
        self.selectedItems.removeAll()
    }
}
