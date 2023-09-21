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
    @Published var showingDeleteConfirmationAlert = false
    @Published var selectedIndices: IndexSet = []
    
    private var db = Firestore.firestore()
    
    init() {}
    
    func deleteCount(at index: Int) {
        guard index >= 0 && index < countHistory.count else {
            return
        }

        let count = countHistory[index]

        guard let countID = count.id else {
            return
        }

        // Reference to the Firestore collection containing counts
        let countsCollection = Firestore.firestore().collection("count")

        // Delete the count from Firestore
        countsCollection.document(countID).delete { error in
            if let error = error {
                print("Error deleting count: \(error.localizedDescription)")
            } else {
                // Remove the count from the array
                self.countHistory.remove(at: index)
                print("Count deleted successfully!")
            }
        }
    }
    
    func fetchCountHistory() {
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
