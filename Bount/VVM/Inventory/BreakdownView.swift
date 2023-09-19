//
//  CountHistoryBreakdownView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/18/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct BreakdownView: View {

    @StateObject var viewModel = BreakdownVM()

    @State var date: Timestamp
    @State var items: [InventoryCountMapping]

    var body: some View {
        NavigationStack {
            List {
                ForEach(ItemType.allCases, id: \.rawValue) { itemType in
                    Section(header: Text(itemType.rawValue)) {
                        ForEach(filteredItems(for: itemType), id: \.self) { item in
                            HStack {
                                if let itemName = viewModel.dbItems.first(where: { $0.id == item.itemID })?.name {
                                    Text("\(itemName)")
                                }

                                Spacer()

                                Text("\(item.itemCount)")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchItems()
            }
        }
    }

    func filteredItems(for itemType: ItemType) -> [InventoryCountMapping] {
        // Filter the items based on the ItemType
        return items.filter { item in
            if let itemObj = viewModel.dbItems.first(where: { $0.id == item.itemID }) {
                return itemObj.type.rawValue == itemType.rawValue
            }
            return false
        }
    }
}
