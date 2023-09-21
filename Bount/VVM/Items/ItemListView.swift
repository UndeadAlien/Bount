//
//  ItemListView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/20/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ItemListView: View {
    @StateObject var viewModel = ItemListVM()
    
    @FirestoreQuery(collectionPath: "items") var items: [Item]
    
    var filteredItems: [Item] {
        let searchText = viewModel.searchText.lowercased()
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
            
            SearchBarView(text: $viewModel.searchText)
            
            List {
                ForEach(ItemType.allCases, id: \.rawValue) { itemType in
                    let itemsForType = filteredItemsForType(itemType)
                    if !itemsForType.isEmpty {
                        Section(header: Text(itemType.rawValue)) {
                            ForEach(itemsForType, id: \.self) { item in
                                NavigationLink(destination: ItemView(item: item)) {
                                    Text("\(item.name)")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Items")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddItemView()) {
                        Label("", systemImage: "plus")
                    }
                }
            }
        }
    }

    func filteredItemsForType(_ itemType: ItemType) -> [Item] {
        return filteredItems.filter { item in
            return item.type == itemType
        }
    }
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView()
    }
}
