//
//  Location.swift
//  Bount
//
//  Created by Connor Hutchinson on 3/7/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: - Location Model
struct Location: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?  // Firestore document ID
    var name: String             // Location name
    var venueID: String          // Identifier for the venue this location belongs to
    
    // Firestore collection name
    var collectionName: String {
        return "locations"
    }

    // Dictionary representation for Firestore
    var dictionary: [String: Any] {
        return [
            "name": name,
            "venueID": venueID
        ]
    }
}

extension Location {
    static let testLocations: [Location] = [
        Location(id: "1", name: "Location 1", venueID: "venue1"),
        Location(id: "2", name: "Location 2", venueID: "venue1"),
        Location(id: "3", name: "Location 3", venueID: "venue2"),
        Location(id: "4", name: "Location 4", venueID: "venue2"),
        Location(id: "5", name: "Location 5", venueID: "venue3"),
        Location(id: "6", name: "Location 6", venueID: "venue3"),
        Location(id: "7", name: "Location 7", venueID: "venue4"),
        Location(id: "8", name: "Location 8", venueID: "venue4"),
        Location(id: "9", name: "Location 9", venueID: "venue5"),
        Location(id: "10", name: "Location 10", venueID: "venue5")
    ]
}
