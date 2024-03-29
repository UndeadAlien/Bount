//
//  Location.swift
//  Bount
//
//  Created by Connor Hutchinson on 3/7/24.
//

import FirebaseFirestoreSwift

struct Location : Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    
    var name: String
    var inventory: [String]
}
