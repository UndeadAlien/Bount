//
//  CountHistoryVM.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/19/23.
//

import Foundation
import Firebase
import FirebaseFirestore

class CountHistoryVM : ObservableObject {
    
    @Published var countHistory: [InventoryCount] = []
    
    init() {}
    
    func fetchItems() {
        let db = Firestore.firestore()
        db.collection("count").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching count history: \(error.localizedDescription)")
                return
            }

            guard let querySnapshot = querySnapshot else {
                return
            }

            self.countHistory = querySnapshot.documents.compactMap { (document) -> InventoryCount? in
                do {
                    return try document.data(as: InventoryCount.self)
                } catch {
                    print("Error decoding items: \(error.localizedDescription)")
                    return nil
                }
            }
        }
    }
    
    // Define a function to format the date
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
}
