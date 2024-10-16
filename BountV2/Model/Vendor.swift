//
//  Vendor.swift
//  Bount
//
//  Created by Connor Hutchinson on 8/27/23.
//

import FirebaseFirestoreSwift

struct Vendor: ProFirebase {
    @DocumentID var id: String?
    
    var name: String
    var inventory: [String]
    
    var collectionName: String {
        return "vendor"
    }

    var dictionary: [String: Any] {
        return [
            "name": name,
            "inventory": inventory
        ]
    }
}

extension Vendor {
    static let testVendors: [Vendor] = [
        Vendor(id: "1", name: "Vendor A", inventory: ["1", "2", "3"]),
        Vendor(id: "2", name: "Vendor B", inventory: ["4", "5", "6"]),
        Vendor(id: "3", name: "Vendor C", inventory: ["7", "8", "9"]),
        Vendor(id: "4", name: "Vendor D", inventory: ["10", "11"]),
        Vendor(id: "5", name: "Vendor E", inventory: ["12", "13", "14"]),
        Vendor(id: "6", name: "Vendor F", inventory: ["15", "16"]),
        Vendor(id: "7", name: "Vendor G", inventory: ["17", "18", "19"]),
        Vendor(id: "8", name: "Vendor H", inventory: ["20", "21"]),
        Vendor(id: "9", name: "Vendor I", inventory: ["22", "23", "24"]),
        Vendor(id: "10", name: "Vendor J", inventory: ["25", "26", "27"])
    ]
}


