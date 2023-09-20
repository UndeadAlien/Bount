//
//  Vendor.swift
//  Bount
//
//  Created by Connor Hutchinson on 8/27/23.
//

import FirebaseFirestoreSwift

struct Vendor: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    
    var name: String
    var inventory: [String]
}

