//
//  Inventory.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/17/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct InventoryCountMapping: Identifiable, Codable, Hashable {
    @DocumentID var id: String?

    var itemID: String
    var itemCount: Int
}

struct InventoryCount: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    
    @ServerTimestamp var date: Timestamp?
    var itemCountMappings: [InventoryCountMapping]
}
