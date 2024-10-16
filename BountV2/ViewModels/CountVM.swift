//
//  CountVM.swift
//  Bount
//
//  Created by Connor Hutchinson on 6/19/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

extension Date {
    func stripTime() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components) ?? self
    }
}

// MARK: Firebase Functions
extension CountVM {
    func submitCount(completion: @escaping (Bool) -> Void) {
        let countsCollection = Firestore.firestore().collection("counts")
        let countID = countsCollection.document().documentID
        
        showingSubmitConfirmationAlert = true
        addCountToFirebase(countID: countID) { success, message in
            if success {
                completion(true)
            } else {
                print("Failed to submit count: \(message)")
                completion(false)
            }
        }
    }
    
    private func addCountToFirebase(countID: String, completion: @escaping (Bool, String) -> Void) {
        guard !itemCounts.isEmpty else {
            completion(false, "Cannot upload an empty count")
            return
        }
        
        let firestore = Firestore.firestore()
        let countsCollection = firestore.collection("counts")
        let batch = firestore.batch()
        
        for (locationID, itemMap) in itemCounts {
            let timestamp = FieldValue.serverTimestamp()
            let documentRef = countsCollection.document()
            
            let itemCountMapping = itemMap
                .filter { $0.value > 0 }
                .map { ["itemID": $0.key, "itemCount": $0.value] }
            
            let locationCountData: [String: Any] = [
                "locationID": locationID,
                "countID": countID,
                "timestamp": timestamp,
                "itemCountMapping": itemCountMapping
            ]
            
            batch.setData(locationCountData, forDocument: documentRef)
        }
        
        batch.commit { error in
            if let error = error {
                completion(false, "Failed to upload counts: \(error.localizedDescription)")
            } else {
                completion(true, "Counts successfully uploaded")
            }
        }
    }
}

// MARK: Formatting
extension CountVM {
    func removePunctuation(from text: String) -> String {
        return text.filter { !$0.isPunctuation }
    }
    
    func formatTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    func formatDateTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    func normalizeDate(_ date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        return calendar.date(from: components) ?? date
    }
}

// MARK: Getters
extension CountVM {
    func getLocationName(locations: [Location], by id: String) -> String {
        return locations.first { $0.id == id }?.name ?? "Unknown Location"
    }

    func getItemName(items: [Item], by id: String) -> String {
        return items.first { $0.id == id }?.name ?? "Unknown Item"
    }
    
    func getUniqueDates(counts: [LocationCount]) -> [Date] {
        let dates = counts.compactMap { $0.timestamp?.dateValue().stripTime() }
        let uniqueDates = Array(Set(dates)).sorted()
        return uniqueDates
    }

    func getCounts(counts: [LocationCount], for date: Date) -> [LocationCount] {
        return counts.filter { Calendar.current.isDate($0.timestamp?.dateValue() ?? Date(), inSameDayAs: date) }
    }
    
    func getItemCount(for locationID: String, _ itemID: String) -> Int {
        return itemCounts[locationID]?[itemID] ?? 0
    }
}

extension CountVM {
    func setItemCount(for locationID: String, _ itemID: String, count: Int) {
        if itemCounts[locationID] == nil {
            itemCounts[locationID] = [:]
        }
        itemCounts[locationID]?[itemID] = count
    }

    func itemsByType(_ filteredItems: [Item], _ itemType: ItemType) -> [Item] {
        filteredItems.filter { $0.type == itemType }
    }
    
    func isValidCount(items: [Item], location: Location) -> Bool {
        for item in items {
            guard let locationID = location.id, let itemID = item.id else { return false }
            let count = getItemCount(for: locationID, itemID)
            if count == 0 {
                return false
            }
        }
        return true
    }
    
    func filteredItemsForType(_ itemType: ItemType, _ filteredItems: [Item]) -> [Item] {
        return filteredItems.filter { item in
            return item.type == itemType
        }
    }
}

class CountVM: ObservableObject {
    @Published var itemCounts: [String: [String: Int]] = [:]
    @Published var searchText = ""
    @Published var submittedLocations: [Location] = []
    
    // MARK: errors
    @Published var showingCancelConfirmationAlert = false
    @Published var showingSubmitConfirmationAlert = false
    @Published var showingErrorAlert = false
    @Published var errorMessage = ""
    
    init() {}
}
