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
    
    init() {}
    
    func uploadCountsToFirestore(completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        
        let itemCountMappings: [[String: Any]] = itemCounts.map { (itemID, itemCount) in
            return [
                "itemID": itemID,
                "itemCount": itemCount
            ]
        }

        let newInventoryCount: [String: Any] = [
            "date": Timestamp(date: Date()),
            "itemCountMappings": itemCountMappings
        ]
        
        db.collection("count").addDocument(data: newInventoryCount) { error in
            if let error = error {
                print("Error adding weekly inventory count: \(error.localizedDescription)")
                completion(false) // Call the completion handler with false on failure
            } else {
                print("Weekly inventory count added successfully.")
                completion(true) // Call the completion handler with true on success
            }
        }
    }
    
    func reset() {
        self.itemCounts = [:]
    }
}
