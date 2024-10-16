//
//  Item.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/4/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: - ItemType Model
struct ItemType: Identifiable, Codable, Hashable {
    @DocumentID var id: String?  // Firestore document ID
    var name: String             // Name of the item type
    
    var collectionName: String {
        return "item_type"
    }

    var dictionary: [String: Any] {
        return ["name": name]
    }
}

extension ItemType {
    static let testItemTypes: [ItemType] = [
        ItemType(id: "1", name: "Vodka"),
        ItemType(id: "2", name: "Rum"),
        ItemType(id: "3", name: "Gin"),
        ItemType(id: "4", name: "Tequila"),
        ItemType(id: "5", name: "Whiskey"),
        ItemType(id: "6", name: "Liqueur"),
        ItemType(id: "7", name: "Beer"),
        ItemType(id: "8", name: "Wine"),
        ItemType(id: "9", name: "Mixer"),
        ItemType(id: "10", name: "Food"),
        ItemType(id: "11", name: "Fruit"),
        ItemType(id: "12", name: "Supplies"),
        ItemType(id: "13", name: "Seltzer"),
        ItemType(id: "14", name: "Keg"),
        ItemType(id: "15", name: "Unknown")
    ]
}

// MARK: - Updated Item Model
struct Item: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?   // Firestore document ID
    var name: String              // Item name
    var type: ItemType            // Reference to the ItemType object
    var vendor: Vendor?           // Associated vendor, if any
    var venueID: String           // Identifier for the venue this item belongs to

    // Firestore collection name
    var collectionName: String {
        return "items"
    }

    // Dictionary representation for Firestore
    var dictionary: [String: Any] {
        var dict: [String: Any] = [
            "name": name,
            "type": [
                "id": type.id ?? "",
                "name": type.name
            ],
            "venueID": venueID
        ]
        
        // Include vendor information if available
        if let vendor = vendor {
            dict["vendor"] = vendor.dictionary
        }
        
        return dict
    }
}

extension Item {
    // Sample data for testing
    static let testItems: [Item] = [
        Item(id: "1", name: "Budweiser", type: ItemType(id: "7", name: "Beer"), vendor: Vendor.testVendors[0], venueID: "venue1"),
        Item(id: "2", name: "Whiskey", type: ItemType(id: "5", name: "Whiskey"), vendor: Vendor.testVendors[1], venueID: "venue1"),
        Item(id: "3", name: "Cabernet Sauvignon", type: ItemType(id: "8", name: "Wine"), vendor: Vendor.testVendors[2], venueID: "venue2"),
        Item(id: "4", name: "Coke", type: ItemType(id: "9", name: "Mixer"), vendor: Vendor.testVendors[3], venueID: "venue2"),
        Item(id: "5", name: "Orange Juice", type: ItemType(id: "9", name: "Mixer"), vendor: Vendor.testVendors[4], venueID: "venue3"),
        Item(id: "6", name: "Bottled Water", type: ItemType(id: "9", name: "Mixer"), vendor: Vendor.testVendors[5], venueID: "venue3"),
        Item(id: "7", name: "Peanuts", type: ItemType(id: "10", name: "Food"), vendor: Vendor.testVendors[6], venueID: "venue4"),
        Item(id: "8", name: "Nachos", type: ItemType(id: "10", name: "Food"), vendor: Vendor.testVendors[7], venueID: "venue4"),
        Item(id: "9", name: "Lemon Slices", type: ItemType(id: "11", name: "Fruit"), vendor: Vendor.testVendors[8], venueID: "venue5"),
        Item(id: "10", name: "Ice", type: ItemType(id: "10", name: "Food"), vendor: Vendor.testVendors[9], venueID: "venue5")
    ]
}


// MARK: - ItemCountMapping Model
struct ItemCountMapping: Identifiable, Codable, Hashable {
    @DocumentID var id: String?   // Firestore document ID
    var itemID: String            // Identifier for the item
    var itemCount: Int            // Count of items
    
    // Dictionary representation for Firestore
    var dictionary: [String: Any] {
        return [
            "itemID": itemID,
            "itemCount": itemCount
        ]
    }
}

extension ItemCountMapping {
    static let testMappings: [ItemCountMapping] = [
        ItemCountMapping(id: "1", itemID: "item1", itemCount: 5),
        ItemCountMapping(id: "2", itemID: "item2", itemCount: 10),
        ItemCountMapping(id: "3", itemID: "item3", itemCount: 8),
        ItemCountMapping(id: "4", itemID: "item4", itemCount: 12)
    ]
}

