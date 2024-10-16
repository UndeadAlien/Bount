//
//  Venue.swift
//  BountV2
//
//  Created by Connor Hutchinson on 10/9/24.
//

import FirebaseFirestoreSwift

struct Venue: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    
    var name: String
    var locationsIDs: [String]
    var adminIDs: [String]
    var employeeIDs: [String]
    
    var collectionName: String {
        return "venue"
    }

    var dictionary: [String: Any] {
        return [
            "name": name,
            "locationIDs": [locationsIDs],
            "adminIDs": [adminIDs],
            "employeesIDs": [employeeIDs]
        ]
    }
}
