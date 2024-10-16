//
//  Extensions.swift
//  Bount
//
//  Created by Connor Hutchinson on 8/27/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

extension Encodable {
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            return json ?? [:]
        }
        catch {
            return [:]
        }
    }
    
    func itemToDictionary(item: Item) -> [String: Any] {
        var dictionary: [String: Any] = [
            "name": item.name,
            "type": item.type.rawValue
        ]
        
        return dictionary
    }
}

extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}

extension Timestamp: Comparable {
    public static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.dateValue() < rhs.dateValue()
    }
    
    public static func == (lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.dateValue() == rhs.dateValue()
    }
}
