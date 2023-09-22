//
//  AddCountVM.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/18/23.
//

import FirebaseFirestore

class AddCountVM: ObservableObject {
    
    @Published var itemCounts: [String: Int] = [:]
    @Published var searchText = ""
    
    @Published var showingCancelConfirmationAlert = false
    @Published var showingSubmitConfirmationAlert = false
    @Published var showingErrorAlert = false
    @Published var errorMessage = ""
    
    init() {}
    
    func uploadCountsToFirestore(completion: @escaping (Bool, String) -> Void) {
        let db = Firestore.firestore()

        // Filter out items with a count of zero
        let itemCountMappings: [[String: Any]] = itemCounts.compactMap { (itemID, itemCount) in
            guard itemCount > 0 else {
                return nil // Skip items with a count of zero
            }
            return [
                "itemID": itemID,
                "itemCount": itemCount
            ]
        }

        // Check if there are any items to upload
        guard !itemCountMappings.isEmpty else {
            completion(false, "Cannot upload an empty count")
            return
        }

        let newInventoryCount: [String: Any] = [
            "date": Timestamp(date: Date()),
            "itemCountMappings": itemCountMappings
        ]

        db.collection("count").addDocument(data: newInventoryCount) { error in
            if error != nil {
                completion(false, "Error uploading the inventory count")
            } else {
                completion(true, "")
            }
        }
    }


    func reset() {
        self.itemCounts = [:]
    }
}
