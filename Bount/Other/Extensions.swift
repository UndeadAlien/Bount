//
//  Extensions.swift
//  Bount
//
//  Created by Connor Hutchinson on 8/27/23.
//

import Foundation

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

        if item.price != nil {
            dictionary["price"] = item.price
        }

        return dictionary
    }
}
