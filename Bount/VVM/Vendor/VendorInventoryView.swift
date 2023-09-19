//
//  VendorInventoryView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/18/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct VendorInventoryView: View {
    
    @State var vendorID: String
    @State var inventory: [String]
    
    @FirestoreQuery(collectionPath: "vendors") var vendors: [Vendor]
    @FirestoreQuery(collectionPath: "items") var items: [Item]
    
    var body: some View {
        Form {
            Section("Vendor") {
                Text(vendorName)
                    .font(.headline)
            }
            
            Section("Inventory") {
                List(itemNames, id: \.self) { itemName in
                    Text(itemName)
                }
            }
        }
    }
    
    private var vendorName: String {
        return vendors.first { $0.id == vendorID }?.name ?? "Loading..."
    }
    
    private var itemNames: [String] {
        return inventory.compactMap { itemID in
            items.first { $0.id == itemID }?.name
        }
    }

}

struct VendorInventoryView_Previews: PreviewProvider {
    static var previews: some View {
        VendorInventoryView(
            vendorID: "15Q0BsporYNSlvwHIe6O",
            inventory: ["1CJTAfQCturZABMwVNJ9", "1O1xURV3pqRndgF4MYqo"]
        )
    }
}
