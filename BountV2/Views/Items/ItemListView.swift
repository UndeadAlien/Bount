//
//  ItemListView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/20/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ItemListView: View {
    @FirestoreQuery(collectionPath: "items") var items: [Item]
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var searchText = ""
    
    var filteredItems: [Item] {
        let searchText = searchText.lowercased()
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { item in
                let itemName = item.name.lowercased()
                let itemType = item.type.rawValue.lowercased()
                return itemName.contains(searchText) || itemType.contains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            InlineHeaderView(title: "Items") {
                itemList()
            }
        }
    }
    
    @ViewBuilder
    func itemList() -> some View {
        List {
            ForEach(ItemType.allCases, id: \.rawValue) { itemType in
                let itemsForType = filteredItemsForType(itemType)
                
                if !itemsForType.isEmpty {
                    Section(header:
                                Text(itemType.rawValue)
                                    .foregroundStyle(.purple)
                                    .modifier(FontMod(size: 16, isBold: true))
                    ) {
                        ForEach(itemsForType.sorted(by: { $0.name < $1.name }), id: \.self) { item in
                            NavigationLink(destination: ItemView(item: item)) {
                                Text("\(item.name)")
                                    .modifier(FontMod(size: 14, isBold: true))
                            }
                            .foregroundStyle(
                                colorScheme == .dark ? .white : .black
                            )
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .listStyle(InsetListStyle())
    }

    func filteredItemsForType(_ itemType: ItemType) -> [Item] {
        return filteredItems.filter { item in
            return item.type == itemType
        }
    }
}

#Preview {
    ItemListView()
        .preferredColorScheme(.dark)
}

