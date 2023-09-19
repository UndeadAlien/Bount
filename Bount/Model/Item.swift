//
//  Item.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/4/23.
//

import Foundation
import FirebaseFirestoreSwift

extension ItemType: Identifiable {
    var id: RawValue { rawValue }
}

// todo: add ItemTypes to the database so they can be altered
enum ItemType : String, Codable, CaseIterable {
    case VODKA
    case RUM
    case GIN
    case TEQUILA
    case WHISKEY
    case CORDIAL
    case LIQUEUR
    case BEER
    case SELTZER
    case KEG
    case FRUIT
    case SUPPLIES
}

struct Item : Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    
    var name: String
    var price: Int?
    var type: ItemType
    var vendor: Vendor?
}
